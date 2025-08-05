package com.helpampm.quote;

import com.helpampm.invoicing.InvoiceTax;
import com.helpampm.metadata.tax.Tax;
import com.helpampm.quote.quoteitems.QuoteItem;

import java.util.Objects;
import java.util.Set;

public class QuoteHelper {
    public static Double calculateGrossTotal(Set<QuoteItem> items, Double serviceCharge) {
        return (Objects.nonNull(items) ? items
                .stream()
                .mapToDouble(QuoteItem::getPrice)
                .sum() : 0.0) + serviceCharge;
    }

    private double calculateTotalBill(Quote quote, Tax tax) {
        return calculateGrossTotal(quote.getItems(), quote.getServiceCharge())
                + calculateTax(tax, quote).getAmount();
    }

    private InvoiceTax calculateTax(Tax tax, Quote quote) {
        Double totalBill = calculateGrossTotal(quote.getItems(), quote.getServiceCharge());
        Double taxAmount = (totalBill * tax.getTaxRate()) / 100;
        InvoiceTax invoiceTax = new InvoiceTax();
        invoiceTax.setAmount(taxAmount);
        invoiceTax.setName(tax.getTaxName());
        return invoiceTax;
    }


    public static String createStatusInClause(String status) {
        if (Objects.equals("history", status)) {
            return "('" +
                    QuoteStatus.PAYMENT_DONE + "','" +
                    QuoteStatus.ORDER_CANCELLED + "')";
        } else if (Objects.equals("started", status)) {
            return "('" + QuoteStatus.STARTED + "','" +
                    QuoteStatus.PAYMENT_PENDING + "')";
        } else if (Objects.equals("scheduled", status)) {
            return "('" + QuoteStatus.SCHEDULED + "','" + QuoteStatus.ACCEPTED_BY_PROVIDER + "')";
        } else if (Objects.equals("neworder", status)) {
            return "('" + QuoteStatus.SCHEDULED + "')";
        }
        return "()";
    }
}
