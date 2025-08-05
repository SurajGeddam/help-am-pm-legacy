/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.livelocation;

import com.helpampm.provider.ProviderException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.queue.CircularFifoQueue;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Component
@Slf4j
/*
  @author kuldeep
 */
public class ProviderLocationLookup {
    private static final Map<String, CircularFifoQueue<Location>>
            providerLocationCache = new HashMap<>();

    public void update(String provideId, Location location) {
        CircularFifoQueue<Location> locationQueue = providerLocationCache.get(provideId);
        if (Objects.isNull(locationQueue)) {
            locationQueue = new CircularFifoQueue<>(5); //Keep last 5 locations
        }
        locationQueue.add(location);
        providerLocationCache.put(provideId, locationQueue);
    }

    public Location get(String providerId) {
        if (providerLocationCache.containsKey(providerId)) {
            return providerLocationCache.get(providerId).peek();
        }
        throw new ProviderException("Unable to locate provider", HttpStatus.NOT_FOUND);
    }
}

