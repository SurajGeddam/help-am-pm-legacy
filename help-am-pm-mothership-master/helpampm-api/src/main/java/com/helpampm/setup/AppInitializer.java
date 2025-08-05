/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.setup;

import com.helpampm.auth.entities.Role;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.exceptions.RoleException;
import com.helpampm.auth.services.RoleService;
import com.helpampm.auth.services.UserService;
import com.helpampm.livelocation.Location;
import com.helpampm.livelocation.LocationService;
import com.helpampm.livelocation.ProviderLocationLookup;
import com.helpampm.metadata.category.Category;
import com.helpampm.metadata.category.CategoryService;
import com.helpampm.metadata.commission.Commission;
import com.helpampm.metadata.commission.CommissionService;
import com.helpampm.metadata.country.Country;
import com.helpampm.metadata.country.CountryService;
import com.helpampm.metadata.info.entities.HelpAndSupport;
import com.helpampm.metadata.info.entities.MobileStaticContent;
import com.helpampm.metadata.info.services.HelpAndSupportService;
import com.helpampm.metadata.info.services.MobileStaticContentService;
import com.helpampm.metadata.insurance.InsuranceType;
import com.helpampm.metadata.insurance.InsuranceTypeService;
import com.helpampm.metadata.license.LicenseType;
import com.helpampm.metadata.license.LicenseTypeService;
import com.helpampm.metadata.pricing.Currency;
import com.helpampm.metadata.pricing.Pricing;
import com.helpampm.metadata.pricing.PricingService;
import com.helpampm.metadata.pricing.PricingType;
import com.helpampm.metadata.tax.Tax;
import com.helpampm.metadata.tax.TaxService;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.metadata.timeslot.TimeslotService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.ResourceUtils;

import javax.transaction.Transactional;
import java.io.FileInputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Transactional
@Configuration
@Slf4j
/*
  @author kuldeep
 */
public class AppInitializer {
    private static final String SUPER_ADMIN_ROLE = "ROLE_SUPERADMIN";
    private static final String HVAC_DESCRIPTION = " Heating, Ventilation & Air Conditioning). Using various technologies we assure you that the temperature, humidity, and purity of the surroundings are well-maintained.";
    private static final String ELECTRICAL_DESCRIPTION = "We deliver complete electrical maintenance service for business needs and cover factors like wiring, power installations, lighting, testing, and other essential maintenance.";
    private static final String LOCKSMITHING_DESCRIPTION = "A trade where professionals provide you lock making & defeating services at your doorstep with ZERO hassles.";
    private static final String PLUMBING_DESCRIPTION = "We provide manpower for all plumbing-related services. Be it potable water or waste removal we have solutions for all applications.";

    private static final Map<String, String> TAX = Map.of(
            "DEFAULT", "Service Tax-10",
            "California", "Service Tax-5",
            "Florida", "Service Tax-4",
            "Georgia", "Service Tax-4");

    private static final Map<String, String> COMMISSION = Map.of(
            "DEFAULT-10", "2.9-0.30"
    );

    private static final Map<String, String> COUNTRY = Map.of(
            "US-United States", "+1"
    );

    private final UserService userService;
    private final RoleService roleService;
    private final CategoryService categoryService;
    private final TimeslotService timeslotService;
    private final PricingService pricingService;
    private final TaxService taxService;
    private final CommissionService commissionService;

    private final HelpAndSupportService helpAndSupportService;
    private final MobileStaticContentService mobileStaticContentService;
    private final CountryService countryService;

    public AppInitializer(final UserService userService,
                          final RoleService roleService,
                          final CategoryService categoryService,
                          final TimeslotService timeslotService,
                          final PricingService pricingService,
                          final TaxService taxService,
                          final HelpAndSupportService helpAndSupportService,
                          final LocationService locationService,
                          final ProviderLocationLookup locationLookup,
                          final MobileStaticContentService mobileStaticContentService,
                          final InsuranceTypeService insuranceTypeService,
                          final LicenseTypeService licenseTypeService,
                          final CommissionService commissionService,
                          final CountryService countryService,
                          @Value("${help.superadmin.username}") String username,
                          @Value("${help.superadmin.password}") String password,
                          @Value("#{'${startup.roles}'.split(',')}") Set<String> roles,
                          @Value("#{'${startup.service-categories}'.split(',')}") Set<String> categories,
                          @Value("#{'${startup.insurance-types}'.split(',')}") Set<String> insuranceTypes,
                          @Value("#{'${startup.license-types}'.split(',')}") Set<String> licenseTypes) {
        this.roleService = roleService;
        this.userService = userService;
        this.categoryService = categoryService;
        this.timeslotService = timeslotService;
        this.pricingService = pricingService;
        this.taxService = taxService;
        this.helpAndSupportService = helpAndSupportService;
        this.mobileStaticContentService = mobileStaticContentService;
        this.commissionService = commissionService;
        this.countryService = countryService;

        initializeRoles(roles);
        initializeUsers(username, password, SUPER_ADMIN_ROLE);
        initializeCategories(categories);
        initializeTax();
        initializeCommission();
        initializeHelpSupport();
        inializeMobileStaticContent();
        initializeCountry();
        autoLoadExistingLocations(locationService, locationLookup);
        createLicenseTypes(licenseTypeService, licenseTypes);
        createInsuranceTypes(insuranceTypeService, insuranceTypes);
    }

    private void createInsuranceTypes(InsuranceTypeService insuranceTypeService, Set<String> insuranceTypes) {
        insuranceTypes.forEach(name -> {
            if (insuranceTypeService.findByName(name).isEmpty()) {
                InsuranceType insuranceType = new InsuranceType();
                insuranceType.setName(name);
                insuranceType.setIsActive(true);
                insuranceTypeService.save(insuranceType);
            }
        });
    }

    private void createLicenseTypes(LicenseTypeService licenseTypeService, Set<String> licenseTypes) {
        licenseTypes.forEach(name -> {
            if (licenseTypeService.findByName(name).isEmpty()) {
                LicenseType licenseType = new LicenseType();
                licenseType.setName(name);
                licenseType.setIsActive(true);
                licenseTypeService.save(licenseType);
            }
        });
    }

    private void autoLoadExistingLocations(final LocationService locationService,
                                           final ProviderLocationLookup locationLookup) {
        List<Location> locations = locationService.findAll();
        locations.forEach(location -> locationLookup.update(location.getProviderUniqueId(), location));
    }

    private Pricing initializePricing(String name) {

        Pricing pricing = new Pricing();
        if (Objects.equals("Morning Hours".toUpperCase(), name.toUpperCase())) {
            pricing.setCommercialPrice(200.00);
            pricing.setResidentialPrice(175.00);
        } else if (Objects.equals("Regular Hours".toUpperCase(), name.toUpperCase())) {
            pricing.setCommercialPrice(150.00);
            pricing.setResidentialPrice(125.00);
        } else if (Objects.equals("Afternoon Hours".toUpperCase(), name.toUpperCase())) {
            pricing.setCommercialPrice(150.00);
            pricing.setResidentialPrice(125.00);
        } else if (Objects.equals("Late Hours".toUpperCase(), name.toUpperCase())) {
            pricing.setCommercialPrice(200.00);
            pricing.setResidentialPrice(175.00);
        } else if (Objects.equals("Night Hours".toUpperCase(), name.toUpperCase())) {
            pricing.setCommercialPrice(270.00);
            pricing.setResidentialPrice(255.00);
        }

        pricing.setIsActive(true);
        pricing.setType(PricingType.FIXED);
        pricing.setCurrency(Currency.DOLLAR);
        pricing.setCreatedAt(LocalDateTime.now());
        //No check required, it's directly related to category and there will not be any existence without category
        return pricingService.create(pricing);

    }

    private void initializeTax() {
        TAX.forEach((location, taxDetail) -> {
            String taxName = taxDetail.split("-")[0];
            String taxPrice = taxDetail.split("-")[1];
            Tax tax = new Tax();
            tax.setTaxCounty(location);
            tax.setTaxName(taxName);
            tax.setTaxRate(Double.parseDouble(taxPrice));
            tax.setIsActive(true);
            tax.setTaxPeriod("2023-2024");
            tax.setCreatedAt(LocalDateTime.now());
            if (taxService.findByTaxLocationAndTaxNameAndTaxPeriod(location, taxName, tax.getTaxPeriod()).isEmpty()) {
                taxService.create(tax);
            }
        });
    }

    private void initializeCommission() {
        COMMISSION.forEach((location, rate) -> {
            String[] county = location.split("-");
            String[] rates = rate.split("-");
            Commission commission = new Commission();
            commission.setCounty(county[0]);
            commission.setRate(Double.parseDouble(county[1]));
            commission.setStripePercentAmount(Double.parseDouble(rates[0]));
            commission.setStripeFixedAmount(Double.parseDouble(rates[1]));
            commission.setIsActive(true);
            commission.setCreatedAt(LocalDateTime.now());
            if (commissionService.findByCountyAndRateAndIsActive(county[0], Double.valueOf(county[1]), commission.getIsActive()) == null) {
                commissionService.create(commission);
            }
        });
    }

    private void initializeHelpSupport() {
        if (helpAndSupportService.getAll().isEmpty()) {
            HelpAndSupport helpAndSupport = new HelpAndSupport();
            helpAndSupport.setHelpEmail("help@help.com");
            helpAndSupport.setHelpPhone("+91989898989");
            helpAndSupport.setHelpAlternatePhone("+919999990");
            helpAndSupport.setCreatedAt(LocalDateTime.now());
            helpAndSupport.setIsActive(true);
            if (helpAndSupportService.findByHelpEmailAndHelpPhone(helpAndSupport.getHelpEmail(), helpAndSupport.getHelpPhone()) == null) {
                helpAndSupportService.update(helpAndSupport);
            }
        }
    }


    private void initializeCategories(Set<String> categories) {
        categories.forEach(categoryName -> {
            if (categoryService.findByName(categoryName).isEmpty()) {
                log.info("Loading initial categories");
                Category category = new Category();
                category.setCommercialService(true);
                category.setResidentialService(true);
                category.setName(categoryName);
                category.setIsActive(true);
                category.setDescription(setDescription(categoryName));

                category.setTimeslots(
                        Set.of(initializeTimeSlot("Morning Hours", "7-9"),
                                initializeTimeSlot("Regular Hours", "9-13"),
                                initializeTimeSlot("Afternoon Hours", "13-17"),
                                initializeTimeSlot("Late Hours", "17-21"),
                                initializeTimeSlot("Night Hours", "21-9")
                        ));

                category.setCreatedAt(LocalDateTime.now());
                category.setLastUpdatedAt(LocalDateTime.now());
                category = categoryService.create(category);
                for (Timeslot timeslot : category.getTimeslots()) {
                    timeslot.setCategoryId(category.getId());
                    timeslotService.update(timeslot);
                }
                log.info("category created: " + category);
            } else {
                log.info("Skip Loading " + categoryName + " categories, already exists");
            }
        });
    }

    private Timeslot initializeTimeSlot(String name, String time) {
        LocalTime startTime = LocalTime.now()
                .withHour(Integer.parseInt(time.split("-")[0]))
                .withMinute(0)
                .withSecond(0)
                .withNano(0);
        LocalTime endTime = LocalTime.now()
                .withHour(Integer.parseInt(time.split("-")[1]))
                .withMinute(0)
                .withSecond(0)
                .withNano(0);
        Timeslot timeslot = new Timeslot();
        timeslot.setName(name);
        timeslot.setStartTime(startTime);
        timeslot.setEndTime(endTime);
        timeslot.setIsActive(true);
        timeslot.setCreatedAt(LocalDateTime.now());
        //No check required, its directly related to category and there will not be any existence without category
        timeslot.setPricing(initializePricing(name));
        return timeslotService.create(timeslot);
    }

    private void initializeUsers(String username, String password, String roleName) {
        if (userService.findByUsername(username).isEmpty()) {
            log.info("Loading initial users.");
            UserLoginDetails userLoginDetails = new UserLoginDetails();
            userLoginDetails.setUsername(username);
            userLoginDetails.setPassword(password);
            userLoginDetails.setRoles(Set.of(roleService.findByName(roleName)));
            userLoginDetails.setEnabled(true);
            userLoginDetails.setAccountNonExpired(true);
            userLoginDetails.setAccountNonLocked(true);
            userLoginDetails.setCredentialsNonExpired(true);
            userLoginDetails.setSuperAdmin(true);
            userService.create(userLoginDetails);
        } else {
            log.info("Skip Loading initial user. User already exists.");
        }
    }

    private void initializeRoles(Set<String> roles) {
        roles.forEach(roleName -> {
            try {
                roleService.findByName(roleName);
                log.info("Skip loading " + roleName + " role, already exists.");
            } catch (RoleException e) {
                log.info("Loading initial user roles");
                Role role = new Role();
                role.setName(roleName);
                roleService.create(role);
            }
        });
    }

    private void initializeCountry() {
        COUNTRY.forEach((name, dialCode) -> {
            Country country = new Country();
            String[] countryNameAndCode = name.split("-");
            country.setDialCode(dialCode);
            country.setCode(countryNameAndCode[0]);
            country.setName(countryNameAndCode[1]);
            countryService.create(country);

        });
    }


    private void inializeMobileStaticContent() {
        Properties mobileProperties = new Properties();
        try (FileInputStream fileInputStream = new FileInputStream(
                ResourceUtils.getFile("classpath:mobile_static_content_en.properties"))) {
            mobileProperties.load(fileInputStream);
            for (Map.Entry<Object, Object> e : mobileProperties.entrySet()) {

                if (mobileStaticContentService.findByKey((String) e.getKey(), "en") == null) {
                    MobileStaticContent mobileStaticContent = new MobileStaticContent();
                    mobileStaticContent.setKey((String) e.getKey());
                    mobileStaticContent.setValue((String) e.getValue());
                    mobileStaticContent.setLangCode("en");
                    mobileStaticContentService.create(mobileStaticContent);
                }
            }
        } catch (IOException e) {
            log.error("Mobile Static properties file not found");
        }
    }

    private String setDescription(String type) {
        String description = null;
        switch (type) {
            case "HVAC":
                description = HVAC_DESCRIPTION;
                break;
            case "ELECTRICAL":
                description = ELECTRICAL_DESCRIPTION;
                break;
            case "LOCKSMITH":
                description = LOCKSMITHING_DESCRIPTION;
                break;
            case "PLUMBING":
                description = PLUMBING_DESCRIPTION;
                break;
            default:
                log.error("Not supported");
        }
        return description;
    }
}
