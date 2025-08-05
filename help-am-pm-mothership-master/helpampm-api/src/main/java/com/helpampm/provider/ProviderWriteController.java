/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import com.helpampm.address.Address;
import com.helpampm.common.GeneralResponse;
import com.helpampm.common.StringUtils;
import com.helpampm.metadata.category.Category;
import com.helpampm.metadata.category.CategoryService;
import com.helpampm.metadata.dto.CategoryDto;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.metadata.timeslot.TimeslotService;
import com.helpampm.provider.bankaccount.BankAccount;
import com.helpampm.provider.bankaccount.timeslots.ProviderTimeslot;
import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.provider.categories.ProviderCategoryRepository;
import com.helpampm.provider.dto.IndividualPayload;
import com.helpampm.provider.dto.ProfileDto;
import com.helpampm.provider.dto.ProviderDto;
import com.helpampm.provider.dto.ProviderTimeslotDto;
import com.helpampm.provider.insurance.Insurance;
import com.helpampm.provider.insurance.InsuranceService;
import com.helpampm.provider.license.License;
import com.helpampm.provider.license.LicenseService;
import com.helpampm.provider.vehicle.Vehicle;
import com.helpampm.provider.vehicle.VehicleService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("provider")
@Tag(name = "Provider Management: Write")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class ProviderWriteController {
    private final ProviderService service;
    private final ProviderUpdateService updateService;
    private final CategoryService categoryService;
    private final TimeslotService timeslotService;
    private final InsuranceService insuranceService;
    private final VehicleService vehicleService;
    private final LicenseService licenseService;
    private final ProviderCategoryRepository providerCategoryRepository;


    @PostMapping("signup")
    @Operation(summary = "Provider Signup as Company or Individual")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProviderDto.class)))})
    public ResponseEntity<GeneralResponse> signupProviderAsCompanyOrIndividual(@RequestBody Provider provider) {
        service.signupProviderAsCompanyOrIndividual(provider);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Provider signup success").build());
    }

    @PostMapping("signup/{companyUniqueId}")
    @Operation(summary = "Provider Signup as Company Employee")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<GeneralResponse> signupProviderAsEmployee(
            @PathVariable("companyUniqueId") String companyUniqueId,
            @RequestBody Provider provider) {
        service.signupProviderAsEmployee(companyUniqueId, provider);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Provider signup success").build());
    }

    @PostMapping("{providerUniqueId}/individual")
    @Operation(summary = "Provider Add Company individual details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<GeneralResponse> addIndividualDetails(@PathVariable("providerUniqueId") String providerUniqueId,
                                                                @RequestBody IndividualPayload individualPayload) {
        updateService.addProviderIndividualDetails(providerUniqueId, individualPayload);
        updateService.addAddress(providerUniqueId, individualPayload.getAddress());
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Individual details added successfully").build());
    }

    @PostMapping("{providerUniqueId}/address")
    @Operation(summary = "Add address to Provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Address.class)))})
    public ResponseEntity<GeneralResponse> addAddress(@PathVariable("providerUniqueId") String providerUniqueId,
                                                      @RequestBody Address address) {
        updateService.addAddress(providerUniqueId, address);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Address added successfully").build());
    }

    @PutMapping("{providerUniqueId}/address")
    @Operation(summary = "Update Provider address")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Address.class)))})
    public ResponseEntity<GeneralResponse> updateAddress(@PathVariable("providerUniqueId") String providerUniqueId,
                                                         @RequestBody Address address) {

        updateService.updateAddress(providerUniqueId, address);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Address updated successfully").build());
    }

    @PostMapping("{providerUniqueId}/bank-account")
    @Operation(summary = "Add Provider bank account")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = BankAccount.class)))})
    public ResponseEntity<GeneralResponse> addBankAccount(@PathVariable("providerUniqueId") String providerUniqueId,
                                                          @RequestBody BankAccount bankAccount) {
        updateService.addBankAccount(providerUniqueId, bankAccount);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Bank details added successfully").build());
    }

    @PutMapping("{providerUniqueId}/bank-account")
    @Operation(summary = "Update Provider bank account")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = BankAccount.class)))})
    public ResponseEntity<GeneralResponse> updateBankAccount(@PathVariable("providerUniqueId") String providerUniqueId,
                                                             @RequestBody BankAccount bankAccount) {
        updateService.updateBankAccount(providerUniqueId, bankAccount);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Bank details updated successfully").build());

    }

    @PostMapping("{providerUniqueId}/insurance")
    @Operation(summary = "Add Provider insurance")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Insurance.class)))})
    public ResponseEntity<GeneralResponse> addInsurance(@PathVariable("providerUniqueId") String providerUniqueId,
                                                        @RequestBody Insurance insurance) {
        updateService.addInsurance(providerUniqueId, insurance);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Insurance added successfully").build());
    }

    @PutMapping("{providerUniqueId}/insurance")
    @Operation(summary = "Update Provider insurance")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Insurance.class)))})
    public ResponseEntity<GeneralResponse> updateInsurance(@PathVariable("providerUniqueId") String providerUniqueId,
                                                           @RequestBody Insurance insurance) {
        updateService.updateInsurance(providerUniqueId, insurance);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Insurance updated successfully").build());
    }

    @DeleteMapping("{providerUniqueId}/insurance")
    @Operation(summary = "Remove Provider insurance")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Insurance.class)))})
    public ResponseEntity<GeneralResponse> removeInsurance(@PathVariable("providerUniqueId") String providerUniqueId,
                                                           @RequestBody List<Long> insuranceIds) {
        List<Insurance> insurances = insuranceService.findByIds(insuranceIds);
        updateService.removeInsurances(providerUniqueId, insurances);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Insurance removed successfully").build());
    }

    @PostMapping("{providerUniqueId}/license")
    @Operation(summary = "Add Provider license")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = License.class)))})
    public ResponseEntity<GeneralResponse> addLicense(@PathVariable("providerUniqueId") String providerUniqueId,
                                                      @RequestBody License license) {
        updateService.addLicense(providerUniqueId, license);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("License added successfully").build());
    }

    @PutMapping("{providerUniqueId}/license")
    @Operation(summary = "Update Provider license")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Insurance.class)))})
    public ResponseEntity<GeneralResponse> updateLicense(@PathVariable("providerUniqueId") String providerUniqueId,
                                                         @RequestBody License license) {
        updateService.updateLicense(providerUniqueId, license);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("License updated successfully").build());
    }

    @DeleteMapping("{providerUniqueId}/license")
    @Operation(summary = "Remove Provider license")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Insurance.class)))})
    public ResponseEntity<GeneralResponse> removeLicense(@PathVariable("providerUniqueId") String providerUniqueId,
                                                         @RequestBody List<Long> licenseIds) {
        List<License> licenses = licenseService.findAllByIds(licenseIds);
        updateService.removeLicenses(providerUniqueId, licenses);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("License removed successfully").build());
    }

    @PostMapping("{providerUniqueId}/vehicle")
    @Operation(summary = "Add Provider vehicle")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Vehicle.class)))})
    public ResponseEntity<GeneralResponse> addVehicles(@PathVariable("providerUniqueId") String providerUniqueId,
                                                       @RequestBody Vehicle vehicle) {
        updateService.addVehicle(providerUniqueId, vehicle);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Vehicle added successfully").build());
    }

    @PutMapping("{providerUniqueId}/vehicle")
    @Operation(summary = "Update Provider Vehicle")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Vehicle.class)))})
    public ResponseEntity<GeneralResponse> updateVehicle(@PathVariable("providerUniqueId") String providerUniqueId,
                                                         @RequestBody Vehicle vehicle) {
        updateService.updateVehicle(providerUniqueId, vehicle);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Vehicle updated successfully").build());
    }

    @DeleteMapping("{providerUniqueId}/vehicle")
    @Operation(summary = "Remove Provider Vehicle")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Vehicle.class)))})
    public ResponseEntity<GeneralResponse> removeVehicle(@PathVariable("vehicleId") String providerUniqueId,
                                                         @RequestBody List<Long> vehicleIds) {
        List<Vehicle> vehicles = vehicleService.findAllByIds(vehicleIds);
        updateService.removeVehicle(providerUniqueId, vehicles);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Vehicle removed successfully").build());

    }

    @Secured({"ROLE_PROVIDER_ADMIN"})
    @PostMapping("employee/{companyUniqueId}")
    @Operation(summary = "Add employee to provider (Will be added as a new provider)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Provider.class)))})
    public ResponseEntity<Provider> addProviderEmployee(@PathVariable("companyUniqueId") String companyUniqueId,
                                                        @RequestBody Provider provider) {
        return ResponseEntity.ok(service.signupProviderAsEmployee(companyUniqueId, provider));
    }

    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @PutMapping("employee/{companyUniqueId}/{providerUniqueId}")
    @Operation(summary = "Update employee to provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProviderDto.class)))})
    public ResponseEntity<ProviderDto> updateProviderEmployee(@PathVariable("companyUniqueId") String companyUniqueId,
                                                              @PathVariable("providerUniqueId") String providerUniqueId,
                                                              @RequestBody Provider provider) {
        return ResponseEntity.ok(ProviderDto.buildWithProvider(updateService.updateEmployee(companyUniqueId, providerUniqueId, provider)));
    }


    @PostMapping("{providerUniqueId}/category")
    @Operation(summary = "Add category to provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Category.class)))})
    public ResponseEntity<GeneralResponse> addCategory(@PathVariable("providerUniqueId") String providerUniqueId,
                                                       @RequestBody CategoryDto categoryDto) {

        Category category = categoryService.getById(categoryDto.getId());
        List<Integer> list = new ArrayList<>();
        for (ProviderTimeslotDto t : categoryDto.getTimeslots()) {
            int id = t.getId();
            list.add(id);
        }
        Set<ProviderTimeslot> timeslots = timeslotService.findByIds(list).stream().map(ProviderTimeslot::from).collect(Collectors.toSet());
        ProviderCategory providerCategory = ProviderCategory.from(category, timeslots);
        updateService.addCategory(providerUniqueId, providerCategory);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Category added successfully").build());
    }

    @DeleteMapping("{providerUniqueId}/category")
    @Operation(summary = "Remove Category from provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = String.class)))})
    public ResponseEntity<GeneralResponse> removeCategory(@PathVariable("providerUniqueId") String providerUniqueId,
                                                          @RequestBody CategoryDto categoryDto) {
        ProviderCategory providerCategory = providerCategoryRepository.getReferenceById(categoryDto.getId());

        updateService.removeCategory(providerUniqueId, providerCategory);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Category removed successfully").build());
    }


    @DeleteMapping("{providerUniqueId}/timeslot")
    @Operation(summary = "Remove Timeslots from provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = String.class)))})
    public ResponseEntity<GeneralResponse> removeTimeslots(@PathVariable("providerUniqueId") String providerUniqueId,
                                                           @RequestBody List<Integer> timeslotIds) {
        List<Timeslot> timeslots = timeslotService.findByIds(timeslotIds);
        updateService.removeTimeslots(providerUniqueId, timeslots);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Timeslot removed successfully").build());
    }


    @PutMapping("/{providerId}/isActive/{isActive}")
    @Operation(summary = "Update Provider address")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProviderDto.class)))})
    public ResponseEntity<ProviderDto> updateStatus(@PathVariable("providerId") Long providerId,
                                                    @PathVariable(name = "isActive") Boolean status) {
        return ResponseEntity.ok(ProviderDto.buildWithProvider(updateService.updateProviderStatus(providerId, status)));
    }

    @GetMapping("reminders/{providerUniqueId}")
    @Operation(summary = "Send account setup reminder ")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProviderDto.class)))})
    public ResponseEntity<GeneralResponse> sendAccountCompleteReminder(@PathVariable("providerUniqueId") String providerUniqueId) {
        updateService.sendAccountCompleteReminder(providerUniqueId);
        return ResponseEntity.ok(GeneralResponse.builder().withMessage("Reminder sent successfully").withStatus(HttpStatus.OK.value()).build());
    }

    @PutMapping("profile")
    @Operation(summary = "update provider profile")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = String.class)))})
    public ResponseEntity<GeneralResponse> updateProviderDetails(@RequestBody ProfileDto profileDto) {
        if (!StringUtils.isNullOrEmpty(profileDto.getProviderUniqueId())) {
            service.updateProviderProfile(profileDto);

        }
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Profile updated successfully").build());
    }

    @PostMapping("disable-payout/{providerUniqueId}/{isEnable}")
    @Operation(summary = "Disable payout for provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = BankAccount.class)))})
    public ResponseEntity<GeneralResponse> disablePayout(@PathVariable("providerUniqueId") String providerUniqueId,
                                                         @PathVariable("isEnable") boolean isEnable) {

        Provider provider = service.findByProviderUniqueId(providerUniqueId);
        service.disablePayouts(provider, isEnable);

        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value())
                .withMessage("Account Payout changed successfully").
                build());
    }

    @PostMapping("/{providerUniqueId}/onboard-provider-stripe")
    @Operation(summary = "Onboard provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = BankAccount.class)))})
    public ResponseEntity<GeneralResponse> onBoardProvider(@PathVariable("providerUniqueId") String providerUniqueId) {

        Provider provider = service.findByProviderUniqueId(providerUniqueId);
        updateService.onboardProviderOnStripe(provider);
            return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value())
                .withMessage("Account Payout changed successfully").
                build());
    }


}
