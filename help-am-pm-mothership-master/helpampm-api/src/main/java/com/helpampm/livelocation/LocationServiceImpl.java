/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.livelocation;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
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
public class LocationServiceImpl implements LocationService {
    private final LocationRepository repository;
    private final ProviderLocationLookup locationLookup;
    private final AuthenticationService authenticationService;

    @Override
    //Maintain only one copy per providerId in database
    public Location save(Location location) {
        authorizeUser(location.getProviderUniqueId(),authenticationService.findLoggedInUser());
        Location oldLocation = repository.findByProviderUniqueId(location.getProviderUniqueId());
        if (Objects.nonNull(oldLocation)) {
            oldLocation.copy(location);
            oldLocation.setCreatedAt(LocalDateTime.now());
            oldLocation.validate();
            location = repository.save(oldLocation);
        } else {
            location.setCreatedAt(LocalDateTime.now());
            location.validate();
            location = repository.save(location);
        }
        locationLookup.update(location.getProviderUniqueId(), location);
        return location;
    }

    private void authorizeUser(String providerUniqueId, UserLoginDetails loggedInUser) {
        if(!Objects.equals(loggedInUser.getProviderUniqueId(), providerUniqueId)) {
            throw new LocationException("User not authorized to update location.", HttpStatus.UNAUTHORIZED);
        }
    }

    @Override
    public List<Location> findAll() {
        return repository.findAll();
    }
}
