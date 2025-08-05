/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import com.helpampm.common.StringUtils;
import com.helpampm.common.services.FileService;
import com.helpampm.config.EmailTemplateConfig;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerRepository;
import com.helpampm.invoicing.pdfgenerator.PDFGenerator;
import com.helpampm.metadata.pricing.Currency;
import com.helpampm.metadata.tax.Tax;
import com.helpampm.notifications.email.EmailNotificationMessage;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.notifications.push.PushNotificationMessage;
import com.helpampm.notifications.push.PushNotificationService;
import com.helpampm.notifications.sms.SMSNotificationMessage;
import com.helpampm.notifications.sms.SMSNotificationService;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteHelper;
import com.helpampm.quote.QuoteRepository;
import com.helpampm.quote.QuoteStatus;
import com.helpampm.quote.quotecustomers.QuoteCustomer;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class InvoiceServiceImpl implements InvoiceService {
    public static final String HELP_INVOICE_EMAIL_SUBJECT = "HELP: Service Invoice";
    private final EmailNotificationService emailNotificationService;
    private final InvoiceDataMapperService invoiceDataMapperService;
    private final InvoiceRepository repository;
    private final QuoteRepository quoteRepository;
    private final PDFGenerator pdfGenerator;
    private final FileService fileService;
    private final CustomerRepository customerRepository;
    private final PushNotificationService pushNotificationService;
    private final SMSNotificationService smsNotificationService;
    @Value("${aws.s3.upload-bucket}")
    protected String bucketName;
    private final EmailTemplateConfig emailTemplateConfig;

    private static InvoicePayment createInvoicePayment() {
        //TODO: Create payment record. Payment will be integrated in frontend,
        // this endpoint will capture information only
        return new InvoicePayment();
    }

    private static InvoiceCustomer createInvoiceCustomer(QuoteCustomer customer) {
        InvoiceCustomer invoiceCustomer = new InvoiceCustomer();
        invoiceCustomer.setName(customer.getCustomerName());
        invoiceCustomer.setEmail(customer.getEmail());
        invoiceCustomer.setPhone(customer.getPhone());
        invoiceCustomer.setAddress(customer.getQuoteAddress().getBuilding());
        return invoiceCustomer;
    }

    private static Set<InvoiceItem> createInvoiceItems(Quote quote) {
        Set<InvoiceItem> invoiceItems = Objects.nonNull(quote.getItems()) ? quote.getItems()
                .stream().map(item ->
                {
                    InvoiceItem invoiceItem = new InvoiceItem();
                    invoiceItem.setDescription(item.getDescription());
                    invoiceItem.setPrice(item.getPrice());
                    return invoiceItem;
                }).collect(Collectors.toSet()) : new HashSet<>();
        InvoiceItem serviceChargeItem = new InvoiceItem();
        serviceChargeItem.setPrice(quote.getServiceCharge());
        serviceChargeItem.setDescription("Service Charges");
        invoiceItems.add(serviceChargeItem);
        return invoiceItems;
    }

    @Override
    public Invoice create(Quote quote) {
        assert Objects.nonNull(quote);
        Invoice invoice = createInvoiceFromOrder(quote);
        invoice.setQuoteUniqueId(quote.getQuoteUniqueId());
        invoice.validate();
        invoice = repository.save(invoice);
        quote.setInvoice(invoice);
        quoteRepository.save(quote);
        try {
            generateInvoicePdf(quote.getQuoteUniqueId());
            sendInvoiceNotification(invoice, quote.getQuoteCustomer().getUniqueId());
        } catch (Throwable th) {
            th.printStackTrace();
            log.warn("Invoice notification failed for order " + quote.getQuoteUniqueId() + "\n" + th.getMessage());
        }
        return invoice;
    }

    private void sendInvoiceNotification(Invoice invoice, String customerUniqueId) {
        Customer customer = customerRepository
                .findByCustomerUniqueId(customerUniqueId)
                .orElseThrow(() -> new InvoiceException("Invalid customer id " + customerUniqueId));
        if(customer.isEmailNotificationEnabled()) {
            sendInvoiceEmail(invoice);
        }
        if(customer.isPushNotificationEnabled()) {
            sendPushNotification(invoice, customer);
        }
        if(customer.isSmsNotificationEnabled()) {
            sendSmsNotification(invoice, customer);
        }
    }

    private void sendSmsNotification(Invoice invoice, Customer customer) {
        SMSNotificationMessage notificationMessage = SMSNotificationMessage.builder()
                .withSubject("New Invoice")
                .withMessage("A new invoice is received, please use your HELP app to " +
                        "pay the due amount.\nYour total bill is $ "
                        + invoice.getTotalPrice())
                .withRecipientName(customer.getFirstName())
                .withIsTransactional(true)
                .build();
        smsNotificationService.send(notificationMessage, customer.getPhone(), customer.getPhone());
    }

    private void sendPushNotification(Invoice invoice, Customer customer) {
        Map<String, Object> pushMap = new HashMap<>();
        pushMap.put("body", "A new invoice is received!");
        pushMap.put("totalAmount", invoice.getTotalPrice());
        pushMap.put("invoiceId", invoice.getUniqueId());
        PushNotificationMessage notificationMessage = PushNotificationMessage.builder()
                .withBody("A new invoice is received!")
                .withData(pushMap)
                .withTitle("Invoice")
                .withStatus(QuoteStatus.PAYMENT_PENDING.name())
                .build();
        pushNotificationService.send(notificationMessage, customer.getUserLoginDetails().getUsername());
    }

    private Invoice createInvoiceFromOrder(Quote quote) {
        QuoteCustomer customer = quote.getQuoteCustomer();
        Tax tax = quote.getTax();
        Invoice invoice = new Invoice();
        invoice.setUniqueId(generateInvoiceId(quote));
        invoice.setCurrency(Objects.nonNull(quote.getTimeSlot().getPricing().getCurrency())
                ? quote.getTimeSlot().getPricing().getCurrency().getSymbol()
                : Currency.DOLLAR.getSymbol());
        invoice.setCreatedAt(LocalDateTime.now());
        invoice.setCustomer(createInvoiceCustomer(customer));
        invoice.setPayment(null);
        invoice.setPaidAt(null);
        invoice.setTax(calculateTax(tax, quote));
        invoice.setTotalPrice(calculateTotalBill(quote, tax));
        invoice.setItems(createInvoiceItems(quote));
        return invoice;
    }

    private double calculateTotalBill(Quote quote, Tax tax) {
        return QuoteHelper.calculateGrossTotal(quote.getItems(), quote.getServiceCharge())
                + calculateTax(tax, quote).getAmount();
    }

    private InvoiceTax calculateTax(Tax tax, Quote quote) {
        Double totalBill = QuoteHelper.calculateGrossTotal(quote.getItems(), quote.getServiceCharge());
        Double taxAmount = (totalBill * tax.getTaxRate()) / 100;
        InvoiceTax invoiceTax = new InvoiceTax();
        invoiceTax.setAmount(taxAmount);
        invoiceTax.setName(tax.getTaxName());
        return invoiceTax;
    }

    private String generateInvoiceId(Quote quote) {
        return "Invoice_"+quote.getCategoryName() + "-"
                + quote.getQuoteCustomer().getUniqueId()
                + "-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("MMddyyyyHHmmss"));
    }

    @Override
    //Only payment status should be allowed to change
    public Invoice update(Invoice invoice) {
        assert Objects.nonNull(invoice) && Objects.nonNull(invoice.getId());
        Long invoiceId = invoice.getId();
        Invoice oldInvoice = repository.findById(invoiceId)
                .orElseThrow(() -> new InvoiceException("No invoice found with id " + invoiceId));
        oldInvoice.copyNonNullValues(invoice);
        invoice.validateOnUpdate();
        return repository.save(invoice);
    }

    @Override
    public Invoice findByInvoiceUniqueId(String invoiceUniqueId) {
        return repository.findByUniqueId(invoiceUniqueId);
    }

    private void sendInvoiceEmail(Invoice invoice) {
        log.info(String.format("Sending invoice email: InvoiceId %s for quote: quoteId %s", invoice.getUniqueId(), invoice.getQuoteUniqueId()));
        EmailNotificationMessage message = EmailNotificationMessage.builder()
                .withSubject(HELP_INVOICE_EMAIL_SUBJECT)
                .withRecipientName(invoice.getCustomer().getName())
                .withRecipientEmail(invoice.getCustomer().getEmail())
                .withEmailTemplateName(emailTemplateConfig.getInvoiceTemplateName())
                .withModelData(invoiceDataMapperService.invoiceMapper(invoice))
                .build();
        emailNotificationService.send(message, invoice.getCustomer().getEmail());
        log.info(String.format("Invoice email sent: InvoiceId %s for quote: quoteId %s", invoice.getUniqueId(), invoice.getQuoteUniqueId()));
    }


    @Override
    public byte[] generateInvoicePdf(String quoteUniqueId) {
        Invoice invoice = quoteRepository.findByQuoteUniqueId(quoteUniqueId).getInvoice();
        log.info(String.format("Generating S3 invoice file: InvoiceId %s for quote: quoteId %s", invoice.getUniqueId(), invoice.getQuoteUniqueId()));
        if (!StringUtils.isNullOrEmpty(invoice.getInvoicePath())) {
            log.info(String.format("Downloading: InvoiceId %s for quote: quoteId %s", invoice.getUniqueId(), invoice.getQuoteUniqueId()));
        } else {
            log.info(String.format("Saving to S3: InvoiceId %s for quote: quoteId %s", invoice.getUniqueId(), invoice.getQuoteUniqueId()));
            String filePath = pdfGenerator.generateInvoicePdf(invoice, emailTemplateConfig.getInvoiceTemplateName());
            invoice.setInvoicePath(filePath);
            update(invoice);
        }
        return fileService.downloadAsBytes(invoice.getInvoicePath(), bucketName);
    }

}
