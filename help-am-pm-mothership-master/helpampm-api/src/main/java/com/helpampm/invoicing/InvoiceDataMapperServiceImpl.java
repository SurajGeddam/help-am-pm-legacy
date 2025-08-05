/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import com.helpampm.invoicing.dto.InvoiceDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class InvoiceDataMapperServiceImpl implements InvoiceDataMapperService {

    @Value("${help.company.logo}")
    private String companyLogo;
    @Value("${help.company.email}")
    private String email;
    @Value("${help.company.website}")
    private String website;
    @Value("${help.company.addressLine1}")
    private String companyAddressLine1;
    @Value("${help.company.addressLine2}")
    private String companyAddressLine2;
    @Value("${help.company.county}")
    private String companyCounty;
    @Value("${help.company.country}")
    private String companyCountry;
    @Value("${help.company.zipcode}")
    private String companyZipcode;


    @Override
    public Map<String, Object> invoiceMapper(Invoice invoice) {
        Map<String, Object> fileArgs = new HashMap<>(Collections
                .singletonMap("invoice", InvoiceDto.buildWithInvoice(invoice)));
        fileArgs.put("helpCompanyDetails", createCompanyInfoData());
        fileArgs.put("helpAddress", createCompanyAddress());
        return fileArgs;
    }

    public Map<String, String> createCompanyInfoData() {
        return Map.of(
                "name", "HELP Corp",
                "logoFile", companyLogo,
                "website", website,
                "email", email
        );
    }

    public Map<String, String> createCompanyAddress() {
        return Map.of(
                "line1", companyAddressLine1,
                "line2", companyAddressLine2,
                "county", companyCounty,
                "country", companyCountry,
                "zipcode", companyZipcode
        );
    }

}
