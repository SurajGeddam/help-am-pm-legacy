/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.helpampm.common.CommonUtils;
import com.helpampm.common.StringUtils;
import com.helpampm.common.services.FileService;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteException;
import com.helpampm.quote.QuoteHelper;
import com.helpampm.payments.Payment;
import com.helpampm.quote.quoteaddress.dto.QuoteAddressDto;
import com.helpampm.quote.quoteitems.QuoteItemDto;
import com.helpampm.quote.quoteproviders.QuoteProviderAddress;
import com.helpampm.quote.quoteproviders.QuoteProviderDto;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;
import org.springframework.http.HttpStatus;

import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import static com.helpampm.quote.dto.TimeslotDto.buildFromTimeslot;

@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class QuoteMobileResponseDTO implements Serializable {

    private String textOnYellow;
    private String categoryName;
    private String customerName;
    private String customerProfilePic;
    private String customerPhone;
    private String customerEmail;
    private QuoteAddressDto customerAddress;
    private String serviceCategory;
    private double serviceCharge;
    private double grossBill;
    private double taxAmount;
    private double totalBill;
    private String distance;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate serviceDate;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime createdAt;
    private String orderNumber;
    private boolean isScheduled;
    private String serviceDescription;
    private TimeslotDto timeslot; // only 2 fields
    private double searchRadius;
    private String providerName;
    private String currency;
    private String status;
    private boolean isOrderLocked;
    private QuoteProviderDto quoteProvider;
    private Payment payment;
    private Set<QuoteItemDto> items;
    private String customerUniqueId;
    private QuoteProviderAddress providerAddress;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime updatedAt;
    private String eta;
    private byte[] imagePath;

    public static QuoteMobileResponseDTO buildFromQuote(Quote quote) {

        if (Objects.isNull(quote)) {
            throw new QuoteException("Quote not found.", HttpStatus.NO_CONTENT.value());
        }
        double grossBill = QuoteHelper.calculateGrossTotal(quote.getItems(), quote.getServiceCharge());
        double tax = (grossBill * quote.getTax().getTaxRate()) / 100;
        return QuoteMobileResponseDTO.builder()
                .withTextOnYellow(quote.getCategoryName().substring(0, 1).toUpperCase())
                .withOrderNumber(quote.getQuoteUniqueId())
                .withCreatedAt(quote.getCreatedAt())
                .withUpdatedAt(quote.getLastUpdatedAt())
                .withServiceCategory(setServiceCategory(quote))
                .withCategoryName(quote.getCategoryName())
                .withIsScheduled(Objects.nonNull(quote.getScheduledTime()))
                .withServiceDescription(quote.getServiceDescription())
                .withTimeslot(buildFromTimeslot(quote.getTimeSlot()))
                .withCustomerAddress(QuoteAddressDto.buildWithAddress(quote.getQuoteCustomer().getQuoteAddress()))
                .withCustomerName(quote.getQuoteCustomer().getCustomerName())
                .withCustomerPhone(quote.getQuoteCustomer().getPhone())
                .withCustomerEmail(quote.getQuoteCustomer().getEmail())
                .withCustomerProfilePic(quote.getQuoteCustomer().getProfileImagePath())
                .withCustomerUniqueId(quote.getQuoteCustomer().getUniqueId())
                .withServiceDate(quote.getScheduledTime() != null ? quote.getScheduledTime().toLocalDate() : null)
                .withProviderName(quote.getQuoteProvider() != null ? quote.getQuoteProvider().getProviderName() : "")
                .withCurrency(quote.getTimeSlot().getPricing().getCurrency().getName().toUpperCase())
                .withStatus(quote.getStatus().name())
                // If you want image on specific quote or response set from that controller itself
                // don't add here as this get called for all response and latency to system.
                .withQuoteProvider(QuoteProviderDto.buildWithQuoteProvider(quote.getQuoteProvider(), "".getBytes(StandardCharsets.UTF_8)))
                .withServiceCharge(CommonUtils.formatDouble(quote.getServiceCharge()))
                .withGrossBill(CommonUtils.formatDouble(grossBill))
                .withTaxAmount(CommonUtils.formatDouble(tax))
                .withTotalBill(CommonUtils.formatDouble(grossBill + tax))
                .withPayment(quote.getPayment())
                .withItems(quote.getItems().stream().map(QuoteItemDto::buildFromQuoteItem).collect(Collectors.toSet()))
                .withEta(quote.getEta() != null ? quote.getEta().toString() : "00:00")
                .build();
    }


    private static String setServiceCategory(Quote quote) {
        if (Boolean.TRUE.equals(quote.getIsResidenceService())) {
            return "Residential";
        } else if (Boolean.TRUE.equals(quote.getIsCommercialService())) {
            return "Commercial";
        } else {
            return "";
        }
    }

    public void updateQuoteImage(FileService fileService, String imagePath, String awsBucket) {
        if (!StringUtils.isNullOrEmpty(imagePath)) {
            setImagePath(fileService.downloadAsBytes(imagePath, awsBucket));
        }
    }
}

@Data
@Builder(setterPrefix = "with")
class TimeslotDto implements Serializable {
    LocalTime startTime;
    LocalTime endTime;

    public static TimeslotDto buildFromTimeslot(Timeslot timeslot) {
        return TimeslotDto.builder().withStartTime(timeslot.getStartTime())
                .withEndTime(timeslot.getEndTime()).build();
    }
}
