package com.helpampm.metadata.country;

import com.helpampm.common.GeneralResponse;
import com.helpampm.metadata.commission.Commission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("country")
@Slf4j
@RequiredArgsConstructor
public class CountryController {

    private final CountryService service;

    @GetMapping("public")
    @Operation(summary = "List all country")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation", content = @Content(array = @ArraySchema(schema = @Schema(implementation = CountryDto.class))))})
    public ResponseEntity<List<CountryDto>> getAllMobile() {
        log.info("Retrieve all Country");
        List<CountryDto> countryDtos = service.getAll().stream().map(CountryDto::buildWithContry)
                .collect(Collectors.toList());
        return ResponseEntity.ok(countryDtos);
    }

    @GetMapping("/all")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "List all country")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation", content = @Content(array = @ArraySchema(schema = @Schema(implementation = CountryDto.class))))})
    public ResponseEntity<List<Country>> getAll() {
        log.info("Retrieve all Country");
        return ResponseEntity.ok(service.getAll());
    }

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Add Country")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation", content = @Content(schema = @Schema(implementation = Country.class)))})
    public ResponseEntity<GeneralResponse> addCountry(@RequestBody Country country) {
        service.create(country);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value())
                .withMessage("Country added successfully").build());
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Update a country")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Commission.class)))})
    public ResponseEntity<GeneralResponse> update(@RequestBody Country country) {
        service.update(country);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value())
                .withMessage("Country updated successfully").build());
    }

}
