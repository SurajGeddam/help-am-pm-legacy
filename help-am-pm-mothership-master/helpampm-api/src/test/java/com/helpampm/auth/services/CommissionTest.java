package com.helpampm.auth.services;

import com.helpampm.common.stripe.StripeService;
import com.helpampm.metadata.commission.Commission;
import com.helpampm.provider.ProviderStripeAccountHelper;
import com.stripe.model.PaymentIntent;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class CommissionTest {

    @Autowired
    StripeService stripeService;

    @Test
    void testHELPCommission() {
        long amount = 21450;
        Commission commission = new Commission();
        commission.setRate(10.0);
        commission.setStripeFixedAmount(0.30);
        commission.setStripePercentAmount(2.9);

        long strip = ProviderStripeAccountHelper.calculateStripeFees(amount, commission);
        long help = ProviderStripeAccountHelper.calculateHelpFees(amount, commission);

        Assertions.assertEquals(652, strip);
        Assertions.assertEquals(2145, help);
    }

    @Test
    void testPaymentIntent() {
        PaymentIntent intent = stripeService.retrivePayment("pi_3NArB9ADXlW5EUPp08zLXWCt");
        System.out.println(intent);
    }


}