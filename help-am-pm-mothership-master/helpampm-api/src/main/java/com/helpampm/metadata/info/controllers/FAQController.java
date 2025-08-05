/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.controllers;

import com.helpampm.common.GeneralResponse;
import com.helpampm.metadata.info.entities.FAQ;
import com.helpampm.metadata.info.services.FAQService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("help/faq")
@Tag(name = "Frequently Asked Questions")
/*
  @author kuldeep
 */
public class FAQController {
    private final FAQService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<FAQ> create(@RequestBody FAQ faq) {
        return ResponseEntity.ok(service.create(faq));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<FAQ> update(@RequestBody FAQ faq) {
        return ResponseEntity.ok(service.update(faq));
    }

    @DeleteMapping("{id}")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<GeneralResponse> delete(@PathVariable("id") Integer id) {
        service.delete(id);
        return ResponseEntity.ok(GeneralResponse.builder()
                .withStatus(HttpStatus.OK.value())
                .withMessage("Question deleted").build());
    }

    @GetMapping("")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    public ResponseEntity<List<FAQ>> getActive(@RequestHeader(value = "lang_code", required = false) String langCode) {
        return ResponseEntity.ok(service.getByActive(true, langCode));
    }

    @GetMapping("all")
    public ResponseEntity<List<FAQ>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }
}
