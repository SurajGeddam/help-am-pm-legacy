/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.services;

import com.helpampm.metadata.info.entities.HelpAndSupport;
import com.helpampm.metadata.info.repository.HelpAndSupportRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class HelpAndSupportServiceImpl implements HelpAndSupportService {
    private final HelpAndSupportRepository repository;

    @Override
    @Transactional
    public HelpAndSupport create(HelpAndSupport helpAndSupport) {
        assert Objects.nonNull(helpAndSupport);
        helpAndSupport.setIsActive(true);
        helpAndSupport.validate();
        return repository.save(helpAndSupport);
    }

    @Override
    public HelpAndSupport update(HelpAndSupport helpAndSupport) {
        assert Objects.nonNull(helpAndSupport);
        helpAndSupport.validate();
        return repository.save(helpAndSupport);
    }

    @Override
    public List<HelpAndSupport> getByActive(boolean isActive) {
        return repository.findByIsActive(isActive);
    }

    @Override
    public List<HelpAndSupport> getAll() {
        return repository.findAll();
    }

    public HelpAndSupport findByHelpEmailAndHelpPhone(String email, String phone) {
        return repository.findByHelpEmailAndHelpPhone(email, phone);
    }

}
