/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("pricing")
@Tag(name = "Pricing Management")
/*
  @author kuldeep
 */
public class PricingController {
    private final PricingService service;

    @PutMapping("{timeslotId}")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<Pricing> update(@PathVariable("timeslotId") Integer timeslotId, @RequestBody Pricing pricing) {
        return ResponseEntity.ok(service.update(timeslotId, pricing));
    }

}
