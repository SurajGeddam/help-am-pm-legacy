/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.provider;

import com.helpampm.common.StringUtils;
import com.helpampm.common.services.FileService;
import com.helpampm.customer.dto.PageableCustomerResponse;
import com.helpampm.provider.dto.*;
import com.helpampm.provider.helper.PageableProviderFilterRequestHelper;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("provider")
@Tag(name = "Provider Management")
@SuppressFBWarnings("EI_EXPOSE_REP")

/*
  @author kuldeep
 */
public class ProviderReadController {

    private final ProviderService service;

    private final PageableProviderFilterRequestHelper providerFilterRequestHelper;
    private final FileService fileService;
    @Value("${aws.s3.profile-photos}")
    private String uploadBucket;

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "List all Provider: Superadmin only")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = ProviderDto.class))))})
    public ResponseEntity<List<ProviderDto>> listAll() {

        List<ProviderDto> providerDtos = service.findAll().stream()
                .map(ProviderDto::buildWithProvider).collect(Collectors.toList());
        return ResponseEntity.ok(providerDtos);
    }


    @PostMapping("/pageableProviders")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Load providers list as page")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = PageableCustomerResponse.class)))})
    public ResponseEntity<PageableProviderResponse> findPageableAll(@RequestBody ProviderFilterRequestPayload filterRequestPayload) {
        PageableProviderResponse pageableLeadsResponse = service
                .findPageableAll(providerFilterRequestHelper.buildPageableFilterRequest(filterRequestPayload));

        return ResponseEntity.ok(pageableLeadsResponse);
    }


    @GetMapping("{providerUniqueId}")
    @Operation(summary = "Get Provider by providerUniqueId")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProviderDto.class)))})
    public ResponseEntity<ProviderDto> findByProviderUniqueId(@PathVariable("providerUniqueId") String providerUniqueId) {
        Provider provider = service.findByProviderUniqueId(providerUniqueId);
        ProviderDto providerDto = ProviderDto.buildWithProvider(provider);
        for (LicenseDto licenseDto : providerDto.getLicenses()) {
            if (licenseDto.getImagePath() != null && !licenseDto.getImagePath().isBlank()) {
                licenseDto.setImage(fileService.downloadAsBytes(licenseDto.getImagePath(), uploadBucket));
            }
        }
        for (InsuranceDto insuranceDto : providerDto.getInsurances()) {
            if (insuranceDto.getImagePath() != null && !insuranceDto.getImagePath().isBlank()) {
                insuranceDto.setImage(fileService.downloadAsBytes(insuranceDto.getImagePath(), uploadBucket));
            }
        }
        return ResponseEntity.ok(providerDto);
    }

    @GetMapping("employees/{parentCompanyUniqueId}")
    @Operation(summary = "Get all Providers by parentCompanyUniqueId")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProviderDto.class)))})
    public ResponseEntity<List<ProviderDto>> getByParentCompanyUniqueId(@PathVariable("parentCompanyUniqueId") String parentCompanyUniqueId) {
        return ResponseEntity.ok(service.findByParentCompanyUniqueId(parentCompanyUniqueId).stream().map(ProviderDto::buildWithProvider).collect(Collectors.toList()));
    }

    @PostMapping("mobile/search")
    @Operation(summary = "Search nearby providers")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = ProviderSearchResponseDto.class))))})
    public ResponseEntity<List<ProviderSearchResponseDto>> search(@RequestBody ProviderSearchDto payload) {
        return ResponseEntity.ok(service.search(payload));
    }

    @GetMapping("profile/{providerUniqueId}")
    @Operation(summary = "Get provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProfileDto.class)))})
    public ResponseEntity<ProfileDto> getProviderDetails(@PathVariable("providerUniqueId") String providerUniqueId) {
        ProfileDto providerDetails = null;
        if (!StringUtils.isNullOrEmpty(providerUniqueId)) {
            Provider provider = service.findByProviderUniqueId(providerUniqueId);
            providerDetails = ProfileDto.buildWithProviderDto(provider);
        }
        return ResponseEntity.ok(providerDetails);
    }


}
