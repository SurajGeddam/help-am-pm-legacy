/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.entities.Role;
import com.helpampm.auth.exceptions.RoleException;
import com.helpampm.auth.repositories.RoleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class RoleServiceImpl implements RoleService {
    private final RoleRepository repository;

    @Override
    @Transactional
    public Role create(Role role) {
        assert Objects.nonNull(role);
        role.validate();
        return repository.saveAndFlush(role);
    }

    @Override
    public Role findByName(String roleName) {
        return repository.findByName(roleName).orElseThrow(() -> new RoleException("Unable to find role by name=" + roleName, HttpStatus.NOT_FOUND));
    }
}
