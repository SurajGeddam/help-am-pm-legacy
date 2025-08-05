package com.helpampm.provider;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.ToNumberPolicy;
import com.helpampm.common.HelpConstants;
import com.helpampm.common.StringUtils;
import com.helpampm.common.stripe.StripeService;
import com.helpampm.metadata.commission.Commission;
import com.helpampm.metadata.commission.CommissionService;
import com.helpampm.notifications.email.EmailNotificationMessage;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.quote.Quote;
import com.stripe.model.*;
import com.stripe.param.AccountCreateParams;
import com.stripe.param.AccountUpdateParams;
import com.stripe.param.PaymentIntentCreateParams;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class ProviderStripeAccountHelper {
    @Value("${help.company.logo}")
    protected String logo;
    @Value("${help.company.website}")
    protected String website;
    @Value("${notifications.email.provider-account-verification-template}")
    protected String accountVerificationTemplate;
    @Value("${notifications.email.provider-account-verification-refresh-template}")
    protected String accountVerificationRefreshTemplate;
    @Value("${notifications.email.provider-account-incomplete-template}")
    protected String accountIncompleteTemplate;
    private final EmailNotificationService emailNotificationService;
    private final StripeService stripeService;
    private final CommissionService commissionService;


    private static final Gson gson = new GsonBuilder()
            .setObjectToNumberStrategy(ToNumberPolicy.LONG_OR_DOUBLE)
            .create();

    /***
     * Create account of Provider on stripe and generate account verification link
     */
    public Map<String, String> onBoardOnStripe(Provider provider) {

        Map<String, Object> connectedAccountParams = createStripeAccountData(provider);
        Account acc = stripeService.createStripeAccount(connectedAccountParams);
        provider.setStripAccountId(acc.getId());
        log.debug("Stripe Account created successfully");
        //Generate Account verification link
        Map<String, String> accountLinkData = createAccountVerificationLink(provider);
        accountLinkData.put("accountId", acc.getId());
        log.debug("Account link created successfully");
        sendAccountVerificationLink(provider, accountLinkData, accountVerificationTemplate);
        log.debug("Account link verification sent");
        return accountLinkData;
    }

    public Map<String, String> createAccountVerificationLink(Provider provider) {
        Account stripeAccount = stripeService.retrieveAccount(provider.getStripAccountId());
        AccountLink accountLink = stripeService.createAccountVerificationLink(
                stripeAccount.getId(), provider.getProviderUniqueId(), provider.getStripeSecretHash());
        return gson.fromJson(gson.toJson(accountLink), Map.class);
    }

    public   Map<String, Object>  sendAccountLinkOnRefreshUrl(String accountId, Provider provider, String type) {
        Map<String, String> accountLinkData = createAccountVerificationLink(provider);
        String templateName;
        if ("refresh".equals(type)) {
            templateName = accountVerificationRefreshTemplate;
        } else {
            templateName = accountIncompleteTemplate;
        }

        return sendAccountVerificationLink(provider, accountLinkData, templateName);
    }

    public String createPaymentIntent(Long amount, Quote quote, Provider provider) {
        Commission commission = calculateProviderOrderAmount(quote.getQuoteCustomer().getQuoteAddress().getCounty());

        long stripeFees = calculateStripeFees(amount, commission);
        long comissionHelp = calculateHelpFees(amount, commission);


        //2.9% + $0.30.
        PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                //total order amount eg 100
                .setAmount(amount)
                // HELP fees eg 10
                .setApplicationFeeAmount(comissionHelp + stripeFees)
                // amount to transfer provider eg. 100-10 =90
                .setTransferData(PaymentIntentCreateParams.TransferData.builder()
                        //.setAmount(providerAmountAfterHelpCommision)
                        .setDestination(provider.getStripAccountId()).build())
                .setCurrency("usd")
                .putMetadata("orderId", quote.getQuoteUniqueId())
                .setReceiptEmail(quote.getQuoteCustomer().getEmail())
                .addAllPaymentMethodType(List.of("card"))
                .build();


        return stripeService.createPaymentIntent(params);
    }

    public static long calculateHelpFees(Long amount, Commission commission) {
        double commissionRate = commission.getRate();
        return Double.valueOf(amount * (commissionRate / 100)).longValue();
    }

    public static long calculateStripeFees(Long amount, Commission commission) {
        return Double.valueOf((amount * commission.getStripePercentAmount() / 100) + commission.getStripeFixedAmount() * 100).longValue();
    }


    private Map<String, Object> sendAccountVerificationLink(Provider provider, Map<String, String> accountLinkData, String templateName) {
        Map<String, Object> modelData = new HashMap<>();
        modelData.put("name", provider.getName());
        modelData.put("accountVerificationLink", accountLinkData.get("url"));
        EmailNotificationMessage emailNotificationMessage = EmailNotificationMessage.builder()
                .withSubject("HELP: Account Verification")
                .withRecipientEmail(provider.getEmail())
                .withRecipientName(provider.getName())
                .withModelData(modelData)
                .withEmailTemplateName(templateName)
                .build();

        emailNotificationService.send(emailNotificationMessage, provider.getEmail());
        return modelData;
    }

    public Map<String, Object> createStripeAccountData(Provider provider) {
        Map<String, Object> connectedAccountParams = new HashMap<>();
        AccountCreateParams.Capabilities capabilities = createCapabilities();
        Account.BusinessProfile businessProfile = createBusinessProfile(provider);
        AccountCreateParams.Individual individual = createIndividualDetail(provider);

        connectedAccountParams.put("settings", createPayoutSchedule());
        connectedAccountParams.put("type", AccountCreateParams.Type.EXPRESS);
        connectedAccountParams.put("business_type", HelpConstants.INDIVIDUAL);
        connectedAccountParams.put("capabilities", gson.fromJson(gson.toJson(capabilities), Map.class));
        connectedAccountParams.put("email", provider.getEmail());
        connectedAccountParams.put("business_profile", gson.fromJson(gson.toJson(businessProfile), Map.class));
        connectedAccountParams.put(HelpConstants.INDIVIDUAL, gson.fromJson(gson.toJson(individual), Map.class));

        //TODO: Replace with provider.getAddress().getCountry()
        // in case of country change this need to be taken care
        connectedAccountParams.put("country", "US");

        //metadata
        Map<String, Object> metadata = new HashMap<>();
        metadata.put("providerUniqueId", provider.getProviderUniqueId());
        metadata.put("companyUniqueId", provider.getCompanyUniqueId());
        connectedAccountParams.put("metadata", metadata);

        return connectedAccountParams;
    }

    private AccountCreateParams.Individual createIndividualDetail(Provider provider) {
//        AccountCreateParams.Individual.Dob dob = AccountCreateParams.Individual.Dob.builder().
//                setDay(Objects.nonNull(provider.getDob()) ? (long) provider.getDob().getDayOfMonth() : 1)
//                .setMonth(Objects.nonNull(provider.getDob()) ? (long) provider.getDob().getMonth().getValue() : 1)
//                .setYear(Objects.nonNull(provider.getDob()) ? (long) provider.getDob().getYear() : 1970).build();

        return AccountCreateParams.Individual.builder()
                .setEmail(provider.getEmail())
                .setFirstName(provider.getFirstName())
                .setLastName(provider.getLastName())
                .setPhone(provider.getPhone())
                .setSsnLast4(provider.getSsnLast4())
                //.setDob(dob)
                .build();
    }

    private static AccountCreateParams.Capabilities createCapabilities() {
        return AccountCreateParams.Capabilities
                .builder()
                .setCardPayments(
                        AccountCreateParams.Capabilities.CardPayments
                                .builder()
                                .setRequested(true)
                                .build()
                )
                .setTransfers(
                        AccountCreateParams.Capabilities.Transfers.builder().setRequested(true).build()
                )
                .build();
    }

    private Account.BusinessProfile createBusinessProfile(Provider provider) {
        // business Profile
        Account.BusinessProfile businessProfile = new Account.BusinessProfile();
        ProviderCategory category = provider.getCategories().stream().findFirst().orElseThrow();
        businessProfile.setName(provider.getName());
        businessProfile.setProductDescription(category.getDescription());
        businessProfile.setSupportUrl(provider.getWebsite());
        businessProfile.setMcc(findMccNumber(category.getName()));
        if (StringUtils.isNullOrEmpty(provider.getWebsite())) {
            businessProfile.setUrl(website);
        }
        com.helpampm.address.Address address = provider.getAddress();
        businessProfile.setSupportAddress(addressToStripeAddress(address));
        return businessProfile;
    }

    private static Address addressToStripeAddress(com.helpampm.address.Address address) {
        Address businessAddress = new Address();
        businessAddress.setState(address.getCounty());
        businessAddress.setCountry("US");//TODO: Replace with actual when available
        businessAddress.setCity(address.getDistrict());
        businessAddress.setLine1(address.getStreet());
        businessAddress.setPostalCode(address.getZipcode());
        return businessAddress;
    }

    private static String findMccNumber(String name) {
        return switch (name) {
            case "HVAC", "PLUMBING" -> "1711";
            case "ELECTRICAL" -> "1731";
            case "LOCKSMITH" -> "1520";
            default -> "0";
        };
    }

    public PaymentMethod retrievePaymentMethod(String id) {
        return stripeService.retrievePaymentMethod(id);
    }

    public Account retrieveAccount(String id) {
        return stripeService.retrieveAccount(id);
    }


    /**
     * Cut HELP commission and transfer rest amount into provider account
     */
    public Commission calculateProviderOrderAmount(String county) {
        Optional<Commission> commissionRate = commissionService.findByCountyAndIsActive(county, true);
        if (commissionRate.isEmpty()) {
            commissionRate = commissionService.findByCountyAndIsActive("DEFAULT", true);
        }
        return commissionRate.get();

    }

    private Map<String, String> createPayoutSchedule() {
        AccountUpdateParams.Settings settings = AccountUpdateParams.Settings.builder().setPayouts(
                AccountUpdateParams.Settings.Payouts.builder()
                        .setSchedule(AccountUpdateParams.Settings.Payouts.Schedule.builder()
                                .setInterval(AccountUpdateParams.Settings.Payouts.Schedule.Interval.WEEKLY)
                                .setWeeklyAnchor(AccountUpdateParams.Settings.Payouts.Schedule.WeeklyAnchor.MONDAY)
                                .build())
                        .setDebitNegativeBalances(false)
                        .build()).build();
        return gson.fromJson(gson.toJson(settings), Map.class);

    }

    public Account payoutEnableDisableForProvider(Account account, boolean isEnable) {
        Map<String, Object> accountUpdateParam = new HashMap<>();
        return stripeService.updateAccount(account, accountUpdateParam);
    }

    public List<Transfer> fetchAllTransfers() {
        Map<String, Object> params = new HashMap<>();
        TransferCollection transferCollection = stripeService.fetchAllTransfers(params);
        return transferCollection != null ? transferCollection.getData() : new ArrayList<>();
    }

    public Transfer fetchTransfer(String id) {
        return stripeService.fetchTransferById(id);
    }

/*

   public String transferAmountToProvider(long amount, String destinationAccountId, String orderUniqueId) {
        Transfer accountLink = stripeService.transferToProvider(amount, destinationAccountId, orderUniqueId);
        return accountLink.getId();
    }

    public Map<String, String> createCustomer(Quote quote, PaymentIntent customerPayment) {
        QuoteCustomer customer = quote.getQuoteCustomer();
        Map<String, String> metadata = new HashMap<>();
        metadata.put("quote_unique_id", quote.getQuoteUniqueId());
        CustomerCreateParams stripeCustomerParams = CustomerCreateParams.builder().setEmail(customer.getEmail())
                .setName(customer.getCustomerName())
                .setPhone(customer.getPhone())
                .setMetadata(metadata)
                .setPaymentMethod(customerPayment.getPaymentMethod())
                .setAddress(CustomerCreateParams.Address.builder()
                        .setCity(customer.getQuoteAddress().getDistrict())
                        .setCountry(customer.getQuoteAddress().getCountry())
                        .setState(customer.getQuoteAddress().getCounty())
                        .setLine1(customer.getQuoteAddress().getStreet())
                        .setPostalCode(customer.getQuoteAddress().getZipcode())
                        .build())
                //.setPaymentMethod()
                .build();
        com.stripe.model.Customer stripeCustomer = stripeService.createCustomer(stripeCustomerParams);
        return gson.fromJson(gson.toJson(stripeCustomer), Map.class);
    }


    private static AccountUpdateParams.Capabilities updateCapabilities(boolean isEnable) {
        return AccountUpdateParams.Capabilities
                .builder()
                .setCardPayments(
                        AccountUpdateParams.Capabilities.CardPayments
                                .builder()
                                .setRequested(isEnable)
                                .build()
                )
                .setTransfers(
                        AccountUpdateParams.Capabilities.Transfers.builder().setRequested(isEnable).build()
                )
                .build();
    }
    public String updatePayoutSchedule(String id) {
        Account resource = retrieveAccount(id);
        AccountUpdateParams params =
                AccountUpdateParams.builder().setSettings(AccountUpdateParams.Settings.builder().setPayouts(
                                AccountUpdateParams.Settings.Payouts.builder()
                                        .setSchedule(AccountUpdateParams.Settings.Payouts.Schedule.builder()
                                                .setInterval(AccountUpdateParams.Settings.Payouts.Schedule.Interval.WEEKLY)
                                                .build()).build()).build())
                        .build();

        Account account = resource.update(params);
    }


    //------------------------Need to use for creating external account on its own-----------

   public Map<String, Object> createExternalAccount(Provider provider, String accountId) {
        Account account = stripeService.retriveAccount(accountId);
        BankAccount bankAccount = new BankAccount();
        bankAccount.setObject("bank_account");
        bankAccount.setRoutingNumber(provider.getBankAccount().getRoutingNumber());
        bankAccount.setAccountHolderName(provider.getBankAccount().getAccountHolderName());
        bankAccount.setBankName(provider.getBankAccount().getBankName());
        bankAccount.setCountry("US");
        Currency currency = provider.getCategories().stream().findFirst().get()
                .getTimeslots().stream().findFirst().get().getPricing().getCurrency();

        if (Currency.DOLLAR.equals(currency)) {
            bankAccount.setCurrency("usd");
        }
        bankAccount.setLast4(org.apache.commons.lang3.StringUtils.right(provider.getBankAccount().getAccountNumber(), 4));
        Map<String, String> bankData = gson.fromJson(gson.toJson(bankAccount), Map.class);

        Map<String, Object> externalAccount = new HashMap<>();
        Map<String, Object> metadata = new HashMap<>();

        metadata.put("providerUniqueId", provider.getProviderUniqueId());
        externalAccount.put("metadata", metadata);
        externalAccount.put("external_account", bankData);
        stripeService.createBankAccount(account, externalAccount);
        return new HashMap<>();
    }*/

}
