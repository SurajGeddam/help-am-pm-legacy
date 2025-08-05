package com.helpampm.notifications.services;


import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.exceptions.UserException;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.notifications.entities.MobileDevice;
import com.helpampm.notifications.repositories.MobileDeviceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class MobileDeviceServiceImpl implements MobileDeviceService {
    private final MobileDeviceRepository mobileDeviceRepository;
    private final AuthenticationService authenticationService;

    @Override
    public void deleteByDeviceIdAndUserName(String deviceId, String username) {
        validateUser(username);
        Optional<MobileDevice> mobileDevice = mobileDeviceRepository.findByDeviceIdAndUsername(deviceId, username);
        mobileDevice.ifPresent(mobileDeviceRepository::delete);
        log.info(username + " user logged out.");
    }

    private void validateUser(String username) {
        UserLoginDetails userDetails = authenticationService.findLoggedInUser();
        if (!Objects.equals(userDetails.getUsername(), username)) {
            throw new UserException("Invalid Credentials, Unauthorized user!");
        }
    }
}
