/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.entities.Role;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.exceptions.UserException;
import com.helpampm.auth.repositories.LoginDetailsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class UserServiceImpl implements UserService {
    private final BCryptPasswordEncoder encoder;
    private final LoginDetailsRepository repository;
    private final RoleService roleService;
    @Value("${help.user.default.role-name}")
    private String defaultRoleName;

    @Override
    public Optional<UserLoginDetails> findByUsername(String username) {
        return repository.findByUsername(username);
    }

    @Override
    @Transactional
    public UserLoginDetails create(UserLoginDetails userLoginDetails) {
        assert Objects.nonNull(userLoginDetails);
        checkDuplicates(userLoginDetails);
        userLoginDetails.setCreatedAt(LocalDateTime.now());
        userLoginDetails.setLastUpdatedAt(LocalDateTime.now());
        userLoginDetails.setPassword(encoder.encode(userLoginDetails.getPassword()));
        if (Objects.isNull(userLoginDetails.getRoles()) || userLoginDetails.getRoles().isEmpty()) {
            updateDefaultRole(userLoginDetails);
        }
        userLoginDetails.setEnabled(true);
        userLoginDetails.setAccountNonLocked(true);
        userLoginDetails.setCredentialsNonExpired(true);
        userLoginDetails.setAccountNonLocked(true);
        userLoginDetails.setAccountNonExpired(true);
        userLoginDetails.validate();
        return repository.saveAndFlush(userLoginDetails);
    }

    private void updateDefaultRole(UserLoginDetails userLoginDetails) {
        Role role = roleService.findByName(defaultRoleName);
        userLoginDetails.setRoles(Set.of(role));
    }

    @Override
    @Transactional
    public UserLoginDetails update(UserLoginDetails userLoginDetails) {
        assert Objects.nonNull(userLoginDetails);
        assert Objects.nonNull(userLoginDetails.getId());
        userLoginDetails.setLastUpdatedAt(LocalDateTime.now());
        populateNullValuesFromPreviousValues(userLoginDetails);
        userLoginDetails.validate();
        checkUpdateDuplicates(userLoginDetails);
        return repository.saveAndFlush(userLoginDetails);
    }

    private void checkUpdateDuplicates(UserLoginDetails userLoginDetails) {
        Optional<UserLoginDetails> oldUser = repository.findByUsername(userLoginDetails.getUsername());
        if (oldUser.isPresent() && !oldUser.get().getId().equals(userLoginDetails.getId())) {
            throw new UserException("Username already exist, please try with some other username.");
        }
    }

    private void checkDuplicates(UserLoginDetails userLoginDetails) {
        Optional<UserLoginDetails> oldUser = repository.findByUsername(userLoginDetails.getUsername());
        if (oldUser.isPresent()) {
            throw new UserException("Username already exist, please try with some other username.");
        }
    }

    private void populateNullValuesFromPreviousValues(UserLoginDetails userLoginDetails) {
        Optional<UserLoginDetails> oldUserLoginDetails = repository.findById(userLoginDetails.getId());
        oldUserLoginDetails.ifPresent(loginDetails -> loginDetails.copyNonNullValues(userLoginDetails));
    }

    @Override
    public List<UserLoginDetails> findAll() {
        return repository.findAll();
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return findByUsername(username).orElseThrow(() -> new UsernameNotFoundException("Unable to find user."));
    }
}
