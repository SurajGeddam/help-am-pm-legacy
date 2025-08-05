package com.helpampm.auth.services;

import com.helpampm.provider.ProviderService;
import com.helpampm.provider.dto.ProviderSearchDto;
import com.helpampm.provider.dto.ProviderSearchResponseDto;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
class ProviderSearchTest {

    @Autowired
    ProviderService providerService;

    @Test
    void testQuoteTimeslot() {

        ProviderSearchDto providerSearchDto = new ProviderSearchDto();
        providerSearchDto.setCategory("LOCKSMITH");
        providerSearchDto.setIsResidential(true);
        providerSearchDto.setRadius(5000000000.0);
        providerSearchDto.setLatitude(28.628151);
        providerSearchDto.setLongitude(77.367783);
        List<ProviderSearchResponseDto> result = providerService.search(providerSearchDto);
        System.out.println(result);

    }


}