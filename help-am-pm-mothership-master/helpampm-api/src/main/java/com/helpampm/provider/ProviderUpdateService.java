/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import com.helpampm.address.Address;
import com.helpampm.address.AddressService;
import com.helpampm.config.EmailTemplateConfig;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.notifications.email.EmailNotificationMessage;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.notifications.push.PushNotificationMessage;
import com.helpampm.notifications.push.PushNotificationService;
import com.helpampm.notifications.sms.SMSNotificationMessage;
import com.helpampm.notifications.sms.SMSNotificationService;
import com.helpampm.provider.bankaccount.BankAccount;
import com.helpampm.provider.bankaccount.BankAccountService;
import com.helpampm.provider.bankaccount.timeslots.ProviderTimeslot;
import com.helpampm.provider.bankaccount.timeslots.ProviderTimeslotRepository;
import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.provider.categories.ProviderCategoryRepository;
import com.helpampm.provider.dto.IndividualPayload;
import com.helpampm.provider.helper.ProviderHelper;
import com.helpampm.provider.insurance.Insurance;
import com.helpampm.provider.insurance.InsuranceService;
import com.helpampm.provider.license.License;
import com.helpampm.provider.license.LicenseService;
import com.helpampm.provider.vehicle.Vehicle;
import com.helpampm.provider.vehicle.VehicleException;
import com.helpampm.provider.vehicle.VehicleService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.*;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
@Transactional
public class ProviderUpdateService {
    private final ProviderService providerService;
    private final AddressService addressService;
    private final InsuranceService insuranceService;
    private final LicenseService licenseService;
    private final VehicleService vehicleService;
    private final BankAccountService bankAccountService;
    private final ProviderRepository repository;
    private final ProviderHelper providerHelper;
    private final EmailNotificationService emailNotificationService;
    private final PushNotificationService pushNotificationService;
    private final SMSNotificationService smsNotificationService;
    private final ProviderCategoryRepository providerCategoryRepository;
    private final ProviderTimeslotRepository providerTimeslotRepository;
    private final EmailTemplateConfig emailTemplateConfig;
    private final ProviderStripeAccountHelper providerStripeAccountHelper;

    @Value("${help.company.termAndConditionPageUrl}")
    private String termAndConditionPageUrl;
    @Value("${help.company.logo}")
    private String logo;

    @Transactional
    public Address addAddress(String providerUniqueId, Address address) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (Objects.nonNull(provider.getAddress())) {
            throw new ProviderException("Address is already added for provider. One address allowed per provider. " +
                    "If you want make changes, please update existing address.", HttpStatus.BAD_REQUEST);
        } else {
            address.setProviderUniqueId(provider.getProviderUniqueId());
            provider.setAddress(addressService.save(address));
            provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
            return repository.save(provider).getAddress();
        }
    }

    @Transactional
    public Address updateAddress(String providerUniqueId, Address address) {
        validateIfAddressAttachedToProvider(providerUniqueId, address);
        assert Objects.nonNull(address) && Objects.nonNull(address.getId());
        Address oldAddress = addressService.findById(address.getId());
        oldAddress.copyNonNullValues(address);
        return addressService.update(address);
    }

    private void validateIfAddressAttachedToProvider(String providerUniqueId, Address address) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (Objects.isNull(provider.getAddress()) || !provider.getAddress().equals(address)) {
            throw new ProviderException("Address does not belong to provider with unique id=" + providerUniqueId, HttpStatus.UNAUTHORIZED);
        }
    }

    @Transactional
    public Set<Insurance> addInsurance(String providerUniqueId, Insurance insurance) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        insurance.setProviderUniqueId(providerUniqueId);
        insurance = insuranceService.save(insurance);
        if (Objects.isNull(provider.getInsurances()) || provider.getInsurances().isEmpty()) {
            Set<Insurance> insurances = new HashSet<>();
            insurances.add(insurance);
            provider.setInsurances(insurances);
            provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
        } else {
            provider.getInsurances().add(insurance);
        }
        provider.setLastCompletedPage(CompletedPage.INSURANCE);
        provider = repository.save(provider);
        return provider.getInsurances();
    }

    @Transactional
    public Insurance updateInsurance(String providerUniqueId, Insurance insurance) {
        assert Objects.nonNull(insurance) && Objects.nonNull(insurance.getId());
        validateIfInsuranceAttachedToProvider(providerUniqueId, insurance);
        return insuranceService.update(insurance);
    }

    @Transactional
    public Set<Insurance> removeInsurances(String providerUniqueId, List<Insurance> insurances) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        insurances.forEach(insurance -> {
            provider.getInsurances().remove(insurance);
            insurance.setIsActive(false);
            insuranceService.save(insurance);
        });
        if (provider.getInsurances().isEmpty()) {
            provider.setAccountSetupCompleted(false);
        }
        return repository.save(provider).getInsurances();
    }

    private void validateIfInsuranceAttachedToProvider(String providerUniqueId, Insurance insurance) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (provider.getInsurances().isEmpty()
                || !provider.getInsurances().contains(insuranceService.findById(insurance.getId()))) {
            throw new ProviderException("Insurance does not belong to provider with unique id=" + providerUniqueId, HttpStatus.UNAUTHORIZED);
        }
    }

    @Transactional
    public Set<License> addLicense(String providerUniqueId, License license) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        license.setProviderUniqueId(providerUniqueId);
        license = licenseService.save(license);
        if (Objects.isNull(provider.getLicenses()) || provider.getLicenses().isEmpty()) {
            Set<License> licenses = new HashSet<>();
            licenses.add(license);
            provider.setLicenses(licenses);
            provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
        } else {
            provider.getLicenses().add(license);
        }

        if (Objects.equals(license.getLicenseType().getName().trim(),"Business License")) {
            provider.setLastCompletedPage(CompletedPage.BUSINESS_LICENSE);
        } else {
            provider.setLastCompletedPage(CompletedPage.TRADE_LICENSE);
        }
        return repository.save(provider).getLicenses();
    }

    @Transactional
    public License updateLicense(String providerUniqueId, License license) {
        assert Objects.nonNull(license) && Objects.nonNull(license.getId());
        validateIfLicenseAttachedToProvider(providerUniqueId, license);
        License oldLicenses = licenseService.findById(license.getId());
        oldLicenses.copyNonNullValues(license);
        return licenseService.update(license);
    }

    public Set<License> removeLicenses(String providerUniqueId, List<License> licenses) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        licenses.forEach(license -> {
            provider.getLicenses().remove(license);
            license.setIsActive(false);
            licenseService.save(license);
        });
        if (provider.getInsurances().isEmpty()) {
            provider.setAccountSetupCompleted(false);
        }
        return repository.save(provider).getLicenses();
    }

    private void validateIfLicenseAttachedToProvider(String providerUniqueId, License license) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (provider.getLicenses().isEmpty() || !provider.getLicenses()
                .contains(licenseService.findById(license.getId()))) {
            throw new ProviderException("License does not belong to provider with unique id=" + providerUniqueId, HttpStatus.UNAUTHORIZED);
        }
    }

    @Transactional
    public BankAccount addBankAccount(String providerUniqueId, BankAccount bankAccount) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (Objects.isNull(provider.getBankAccount())) {
            bankAccount.setProviderUniqueId(providerUniqueId);
            bankAccount.setCreatedAt(LocalDateTime.now());
            bankAccount.setLastUpdatedAt(LocalDateTime.now());
            provider.setBankAccount(bankAccountService.save(bankAccount));
            provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
            provider.setLastCompletedPage(CompletedPage.BANK);
            onboardProviderOnStripe(provider);
            return repository.save(provider).getBankAccount();
        } else {
            throw new ProviderException("Bank account already added to this account", HttpStatus.BAD_REQUEST);
        }
    }

    @Transactional
    public BankAccount updateBankAccount(String providerUniqueId, BankAccount bankAccount) {
        assert Objects.nonNull(bankAccount.getId());
        validateIfBankAccountAttachedToProvider(providerUniqueId, bankAccount);
        BankAccount oldBankAccount = bankAccountService
                .findById(bankAccount.getId());
        bankAccount.setLastUpdatedAt(LocalDateTime.now());
        oldBankAccount.copyNonNullValues(bankAccount);
        return bankAccountService.update(bankAccount);
    }

    private void validateIfBankAccountAttachedToProvider(String providerUniqueId, BankAccount bankAccount) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (Objects.isNull(provider.getBankAccount()) || !provider.getBankAccount()
                .equals(bankAccountService.findById(bankAccount.getId()))) {
            throw new ProviderException("Bank Account does not belong to provider with unique id=" + providerUniqueId, HttpStatus.UNAUTHORIZED);
        }
    }

    @Transactional
    public Set<Vehicle> addVehicle(String providerUniqueId, Vehicle vehicle) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        boolean vehicleNotAdded = provider.getVehicles().isEmpty();
        enrichVehicleData(providerUniqueId, vehicle, provider);
        vehicle.validate();
        vehicle = vehicleService.save(vehicle);
        if (Objects.isNull(provider.getVehicles()) || provider.getVehicles().isEmpty()) {
            Set<Vehicle> vehicles = new HashSet<>();
            vehicles.add(vehicle);
            provider.setVehicles(vehicles);
            provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
        } else {
            provider.getVehicles().add(vehicle);
        }
        if (vehicleNotAdded) {
            provider.setLastCompletedPage(CompletedPage.VEHICLE);
        }
        return repository.save(provider).getVehicles();
    }

    private void enrichVehicleData(String providerUniqueId, Vehicle vehicle, Provider provider) {
        checkDuplicateVehicle(vehicle, provider.getVehicles());
        vehicle.setProviderUniqueId(providerUniqueId);
        Optional<Insurance> existingInsurance =
                insuranceService.findByProviderUniqueIdAndPolicyTypeAndPolicyNumber(providerUniqueId,
                        vehicle.getInsurance().getPolicyType(),
                        vehicle.getInsurance().getPolicyNumber());
        if (existingInsurance.isPresent()) {
            vehicle.setInsurance(existingInsurance.get());
        } else {
            vehicle.setInsurance(saveVehicleInsurance(vehicle.getInsurance()));
        }
    }

    private void checkDuplicateVehicle(Vehicle vehicle, Set<Vehicle> vehicles) {
        vehicles.stream().filter(v -> v.equals(vehicle)).findFirst().ifPresent(v -> {
            throw new VehicleException("Vehicle is already exists.", HttpStatus.EXPECTATION_FAILED);
        });
    }

    @Transactional
    private Insurance saveVehicleInsurance(Insurance insurance) {
        if (Objects.isNull(insurance.getId())) {
            return insuranceService.save(insurance);
        }
        return insuranceService.findById(insurance.getId());
    }

    @Transactional
    public Vehicle updateVehicle(String providerUniqueId, Vehicle vehicle) {
        assert Objects.nonNull(vehicle) && Objects.nonNull(vehicle.getId());
        validateIfVehicleAttachedToProvider(providerUniqueId, vehicle);
        Vehicle oldVehicle = vehicleService.findById(vehicle.getId());
        oldVehicle.copyNonNullValues(vehicle);
        return vehicleService.update(vehicle);
    }

    @Transactional
    public Set<Vehicle> removeVehicle(String providerUniqueId, List<Vehicle> vehicles) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        vehicles.forEach(vehicle -> {
            provider.getVehicles().remove(vehicle);
            vehicle.setIsActive(false);
            vehicleService.update(vehicle);
        });
        if (provider.getVehicles().isEmpty()) {
            provider.setAccountSetupCompleted(false);
        }
        return repository.save(provider).getVehicles();
    }

    private void validateIfVehicleAttachedToProvider(String providerUniqueId, Vehicle vehicle) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        if (provider.getVehicles().isEmpty()
                || !provider.getVehicles().contains(vehicleService.findById(vehicle.getId()))) {
            throw new ProviderException("Vehicle does not belong to provider with unique id=" + providerUniqueId, HttpStatus.UNAUTHORIZED);
        }
    }

    @Transactional
    public Provider updateEmployee(String companyUniqueId, String providerUniqueId, Provider provider) {
        assert Objects.nonNull(companyUniqueId)
                && Objects.nonNull(providerUniqueId)
                && Objects.nonNull(provider)
                && Objects.nonNull(provider.getId());
        Provider oldProvider = providerService.findByProviderUniqueId(providerUniqueId);
        if (!companyUniqueId.equalsIgnoreCase(oldProvider.getParentCompanyUniqueId())) {
            throw new ProviderException("Provider unique id and company unique id does not match, please check again.", HttpStatus.UNAUTHORIZED);
        }
        oldProvider.copyNonNullValues(provider);
        return repository.save(provider);
    }

    @Transactional
    public Set<Timeslot> removeTimeslots(String providerUniqueId, List<Timeslot> timeslots) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        timeslots.forEach(provider.getTimeslots()::remove);
        if (provider.getTimeslots().isEmpty()) {
            provider.setAccountSetupCompleted(false);
        }
        repository.save(provider);
        return provider.getTimeslots();
    }

    @Transactional
    public Provider updateProviderStatus(Long providerId, Boolean status) {
        Provider provider = repository.findById(providerId).orElseThrow(() -> new ProviderException("Provider Not found", HttpStatus.NOT_FOUND));
        provider.setIsActive(status);
        provider.getUserLoginDetails().setEnabled(status);
        return repository.save(provider);
    }

    @Transactional
    public Provider updateProvider(Provider provider) {
        return repository.save(provider);
    }

    public void sendAccountCompleteReminder(String providerId) {
        Provider provider = repository.findByProviderUniqueId(providerId).orElseThrow(() -> new ProviderException("Provider Not Found", HttpStatus.NOT_FOUND));
        if (Boolean.TRUE.equals(provider.getAccountSetupCompleted())) {
            log.info("Account setup is already done.");
            return;
        }
        log.info("Sending account setup reminder to provider.");
        sendIncompleteAccountReminder(provider);

        sendIncompletePushReminder(provider);

        if (provider.isSmsNotificationEnabled()) {
            sendIncompleteAccountSMSReminder(provider);
        }
        provider.setAccountSetupRemindersCount(provider.getAccountSetupRemindersCount() + 1);
        repository.save(provider);
    }

    private void sendIncompleteAccountSMSReminder(Provider provider) {
        SMSNotificationMessage notificationMessage = SMSNotificationMessage.builder()
                .withMessage("HELP: Please complete your provider profile.\n Regards,\nHELP Team")
                .withIsTransactional(true)
                .withRecipientName(provider.getName())
                .withSubject("HELP: Incomplete Profile")
                .build();
        smsNotificationService.send(notificationMessage,
                provider.getPhone(),
                provider.getUserLoginDetails().getUsername());
    }

    private void sendIncompletePushReminder(Provider provider) {
        PushNotificationMessage pushNotificationMessage = PushNotificationMessage.builder()
                .build();
        String lastCompletedPage = provider.getLastCompletedPage().getName();
        Map<String, Object> modelData = new HashMap<>();
        modelData.put("name", provider.getName());
        modelData.put("lastCompletedPage", lastCompletedPage);
        pushNotificationMessage.setStatus("Incomplete");
        pushNotificationMessage.setTitle("Incomplete Account");
        pushNotificationMessage.setData(modelData);
        pushNotificationMessage.setBody("Kindly finalize your account to start earning with us.");
        pushNotificationService.send(pushNotificationMessage,
                provider.getUserLoginDetails().getUsername());
    }

    private void sendIncompleteAccountReminder(Provider provider) {
        String lastCompletedPage = provider.getLastCompletedPage().getName();
        Map<String, Object> modelData = new HashMap<>();
        modelData.put("name", provider.getName());
        modelData.put("companyUniqueId", provider.getCompanyUniqueId());
        modelData.put("termAndConditionPageUrl", termAndConditionPageUrl);
        modelData.put("logo", logo);
        modelData.put("lastCompletedPage", lastCompletedPage);

        String templateName = emailTemplateConfig.getProviderAccountSetupReminderTemplateName();

        // compelted till bank need to complete stripe payment
        if ("BANK".equalsIgnoreCase(lastCompletedPage)) {
            Map<String, String> accountLinkData = providerStripeAccountHelper.createAccountVerificationLink(provider);
            modelData.put("accountVerificationLink", accountLinkData.get("url"));
            templateName = emailTemplateConfig.getProviderAccountIncompleteTemplate();
        }

        EmailNotificationMessage emailNotificationMessage = EmailNotificationMessage.builder()
                .withSubject("HELP: Incomplete Profile Reminder")
                .withRecipientEmail(provider.getEmail())
                .withRecipientName(provider.getName())
                .withModelData(modelData)
                .withEmailTemplateName(templateName)
                .build();
        emailNotificationService.send(emailNotificationMessage, provider.getEmail());
    }


    public Provider updateRatings(Provider provider) {
        Provider oldProvider = providerService.findByProviderUniqueId(provider.getProviderUniqueId());
        oldProvider.copyNonNullValues(provider);
        provider.validate();
        return repository.save(provider);
    }

    public Set<ProviderCategory> addCategory(String providerUniqueId, ProviderCategory category) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        List<ProviderTimeslot> timeslots = providerTimeslotRepository.saveAll(category.getTimeslots());
        category.setTimeslots(new HashSet<>());
        for (ProviderTimeslot providerTimeslot : timeslots) {
            category.getTimeslots().add(providerTimeslot);
        }
        category.setProviderUniqueId(providerUniqueId);
        provider.getCategories().add(providerCategoryRepository.save(category));
        provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
        provider.setLastCompletedPage(CompletedPage.CATEGORY);
        return repository.save(provider).getCategories();
    }

    public Set<ProviderCategory> removeCategory(String providerUniqueId, ProviderCategory category) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        List.of(category).forEach(provider.getCategories()::remove);
        if (Objects.equals(provider.getCategories().size(), 0)) {
            provider.setAccountSetupCompleted(false);
        }
        return repository.save(provider).getCategories();
    }

    @Transactional
    public Provider addProviderIndividualDetails(String providerUniqueId, IndividualPayload individualPayload) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        provider.setName(individualPayload.getCompanyName());
        provider.setPhone(individualPayload.getCompanyPhone());
        provider.setEmail(individualPayload.getCompanyEmail());
        provider.setWebsite(individualPayload.getCompanyWebsite());
        provider.setLastCompletedPage(CompletedPage.INDIVIDUAL);
        provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
        return repository.save(provider);
    }

    public Map<String, String> onboardProviderOnStripe(Provider provider) {
        Map<String, String> stripeResponse = providerStripeAccountHelper.onBoardOnStripe(provider);
        provider.setStripAccountId(stripeResponse.get("accountId"));
        //Marking account setup as false as Provider need to verify account from the stripe
        providerHelper.checkIfAccountSetupDone(provider);
        log.info("Onboard response {}", stripeResponse);
        return stripeResponse;
    }
}
