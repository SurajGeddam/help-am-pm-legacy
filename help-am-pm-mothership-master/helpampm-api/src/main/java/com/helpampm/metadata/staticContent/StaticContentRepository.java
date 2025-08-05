package com.helpampm.metadata.staticContent;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StaticContentRepository extends JpaRepository<StaticContent, Integer> {

    Optional<StaticContent> findByContentKey(String key);
}
