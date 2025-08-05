/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.services;

import com.helpampm.metadata.info.MetadataException;
import com.helpampm.metadata.info.entities.FAQ;
import com.helpampm.metadata.info.repository.FaqRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class FAQServiceImpl implements FAQService {
    private final FaqRepository repository;

    @Override
    @Transactional
    public FAQ create(FAQ faq) {
        assert Objects.nonNull(faq);
        faq.validate();
        faq.setCreatedAt(LocalDateTime.now());
        faq.setLastUpdatedAt(LocalDateTime.now());
        checkDuplicates(faq);
        faq.validate();
        return repository.save(faq);
    }

    private void checkDuplicates(FAQ faq) {
        if (repository.findByQuestion(faq.getQuestion()).isPresent()) {
            throw new MetadataException("Question already exists.");
        }
    }

    @Override
    public FAQ update(FAQ faq) {
        assert Objects.nonNull(faq);
        assert Objects.nonNull(faq.getId());
        checkDuplicates(faq);
        faq.setLastUpdatedAt(LocalDateTime.now());
        populateNullValuesFromPreviousValues(faq);
        faq.validate();
        return repository.save(faq);
    }

    private void populateNullValuesFromPreviousValues(FAQ faq) {
        Optional<FAQ> oldFaq = repository.findById(faq.getId());
        oldFaq.ifPresent(value -> value.copyNonNullValues(faq));
    }

    @Override
    public List<FAQ> getByActive(boolean isActive, String langCode) {
        return repository.findByIsActiveAndLangCode(isActive, langCode);
    }

    @Override
    public List<FAQ> getAll() {
        return repository.findAll();
    }

    @Override
    public void delete(Integer id) {
        repository.deleteById(id);
    }
}
