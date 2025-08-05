/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.dto;

import com.helpampm.address.Address;
import com.helpampm.common.CommonUtils;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteException;
import com.helpampm.quote.QuoteHelper;
import com.helpampm.quote.QuoteStatus;
import com.helpampm.quote.quoteaddress.QuoteAddress;
import com.helpampm.quote.quoteproviders.QuoteProviderAddress;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;
import org.springframework.http.HttpStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Objects;

@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
@Builder(setterPrefix = "with")
@ToString
/*
  @author kuldeep
 */
public class QuoteDTO {
    private String quoteUniqueId;
    private String categoryName;
    private Address address;
    private boolean residentialService;
    private boolean commercialService;
    private boolean isScheduled;
    private String serviceDescription;
    private LocalDate serviceDate;
    private Timeslot timeslot;
    private double serviceCharge;
    private double grossBill;
    private double taxAmount;
    private double totalBill;
    private QuoteStatus quoteStatus;
    private double searchRadius;
    private String customerName;
    private String providerName;
    private LocalDateTime createdAt;
    private String customerPhone;
    private QuoteAddress quoteAddress;
    private QuoteProviderAddress providerAddress;
    private String imagePath;
    private String eta;
    private byte[] image;


    public static QuoteDTO buildFromQuote(Quote quote) {
        if (Objects.isNull(quote)) {
            throw new QuoteException("Quote not found.", HttpStatus.NO_CONTENT.value());
        }
        double grossBill = QuoteHelper.calculateGrossTotal(quote.getItems(), quote.getServiceCharge());
        double tax = (grossBill * quote.getTax().getTaxRate()) / 100;
        return QuoteDTO.builder()
                .withQuoteUniqueId(quote.getQuoteUniqueId())
                .withCreatedAt(quote.getCreatedAt())
                .withResidentialService(quote.getIsResidenceService())
                .withCategoryName(quote.getCategoryName())
                .withIsScheduled(Objects.nonNull(quote.getScheduledTime()))
                .withServiceDescription(quote.getServiceDescription())
                .withTimeslot(quote.getTimeSlot())
                .withServiceCharge(CommonUtils.formatDouble(quote.getServiceCharge()))
                .withGrossBill(CommonUtils.formatDouble(grossBill))
                .withTaxAmount(CommonUtils.formatDouble(tax))
                .withServiceDate(quote.getScheduledTime() != null
                        ? quote.getScheduledTime().toLocalDate() : null)
                .withQuoteStatus(quote.getStatus())
                .withQuoteAddress(quote.getQuoteCustomer().getQuoteAddress())
                .withCustomerName(quote.getQuoteCustomer().getCustomerName())
                .withCustomerPhone(quote.getQuoteCustomer().getPhone())
                .withProviderName(quote.getQuoteProvider() != null ? quote.getQuoteProvider().getProviderName() : "")
                .withTotalBill(CommonUtils.formatDouble(grossBill + tax))
                .withImagePath(quote.getImagePath())
                .withEta(quote.getEta() != null ? quote.getEta().toString() : "O0:00")
                .build();
    }

}
