package com.helpampm.metadata.staticContent;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
public class StaticContentServiceImpl implements StaticContentService {

    private final StaticContentRepository repository;

    @Override
    public StaticContent create(StaticContent content) {
        assert Objects.nonNull(content);
        content.validate();
        checkDuplicates(content);
       content.setCreatedAt(LocalDateTime.now());
        content.setLastUpdatedAt(LocalDateTime.now());
        content.setIsActive(true);
        return repository.save(content);
    }

    @Override
    public StaticContent update(StaticContent content) {
        assert Objects.nonNull(content);
        assert Objects.nonNull(content.getId());
        content.setLastUpdatedAt(LocalDateTime.now());
        content.validate();
        return repository.save(content);
    }

    @Override
    public List<StaticContent> getAll() {
        return repository.findAll();
    }

    @Override
    public StaticContent getById(Integer id) {
        return repository.findById(id).orElseThrow(() -> new StaticContentException(("No Content is present.")));
    }

    private void checkDuplicates(StaticContent content) {
        if (repository.findByContentKey(content.getContentKey()).isPresent()) {
            throw new StaticContentException("Content key already exists.");
        }
    }
}
