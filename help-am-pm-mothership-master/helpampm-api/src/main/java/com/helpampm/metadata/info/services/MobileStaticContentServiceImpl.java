/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.services;

import com.helpampm.metadata.info.MetadataException;
import com.helpampm.metadata.info.entities.MobileStaticContent;
import com.helpampm.metadata.info.repository.MobileStaticContentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class MobileStaticContentServiceImpl implements MobileStaticContentService {

    private final MobileStaticContentRepository repository;

    @Override
    public MobileStaticContent create(MobileStaticContent mobileStaticContent) {
        assert Objects.nonNull(mobileStaticContent);
        mobileStaticContent.setCreatedAt(LocalDateTime.now());
        mobileStaticContent.setLastUpdatedAt(LocalDateTime.now());
        mobileStaticContent.validate();
        checkDuplicates(mobileStaticContent);
        return repository.save(mobileStaticContent);
    }

    private void checkDuplicates(MobileStaticContent mobileStaticContent) {
        if (Objects.nonNull(repository.findByKeyAndLangCode(mobileStaticContent.getKey(), mobileStaticContent.getLangCode()))) {
            throw new MetadataException("Mobile Static Content key is already exists.");
        }
    }

    @Override
    public MobileStaticContent update(MobileStaticContent mobileStaticContent) {
        assert Objects.nonNull(mobileStaticContent) && Objects.nonNull(mobileStaticContent.getId());
        mobileStaticContent.setLastUpdatedAt(LocalDateTime.now());
        MobileStaticContent oldMobileStaticContent = repository.findById(mobileStaticContent.getId())
                .orElseThrow(() -> new MetadataException("Update Failed: Unable to find entity to update."));
        oldMobileStaticContent.copyNonNullValues(mobileStaticContent);
        mobileStaticContent.validate();
        return repository.save(mobileStaticContent);
    }

    @Override
    public List<MobileStaticContent> listAll() {
        return repository.findAll();
    }

    @Override
    public MobileStaticContent findByIs(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new MetadataException(String.format("Unable to find entity by id={%s}.", id)));
    }

    @Override
    public MobileStaticContent findByKey(String key, String langCode) {
        return repository.findByKeyAndLangCode(key, langCode);
    }
}
