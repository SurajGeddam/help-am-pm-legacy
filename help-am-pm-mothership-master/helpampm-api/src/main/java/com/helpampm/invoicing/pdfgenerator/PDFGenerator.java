/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing.pdfgenerator;

import com.helpampm.common.services.FileService;
import com.helpampm.invoicing.Invoice;
import com.helpampm.invoicing.InvoiceDataMapperService;
import com.helpampm.invoicing.InvoiceException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Map;

@Component
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class PDFGenerator {
    private final PdfRenderer pdfRenderer;
    private final ThymeleafProcessor thymeleafProcessor;
    private final InvoiceDataMapperService invoiceDataMapperService;
    private final FileService fileService;
    @Value("${aws.s3.upload-bucket}")
    protected String bucketName;

    public String generateInvoicePdf(final Invoice invoice, String invoiceTemplateName) {
        try {
            log.info("Running:  invoice summary Generator");
            Map<String, Object> invoiceData = invoiceDataMapperService.invoiceMapper(invoice);
            String html = thymeleafProcessor.process(invoiceTemplateName, invoiceData);
            ByteArrayOutputStream actual = pdfRenderer.runRenderer("/templates", html);
            log.info("Completed:  invoice Generator");

            assert actual != null;
            ByteArrayInputStream input = new ByteArrayInputStream(actual.toByteArray());
            fileService.uploadFileStreamToS3(bucketName, "invoices/invoice-summary-" + invoice.getUniqueId() + ".pdf", input);
            log.info("File uploaded to S3");
            return "invoices/invoice-summary-" + invoice.getUniqueId() + ".pdf";

        } catch (Exception e) {
            log.error(e.getMessage());
            throw new InvoiceException("Generating invoice failed. " + e.getMessage());
        }
    }

}
