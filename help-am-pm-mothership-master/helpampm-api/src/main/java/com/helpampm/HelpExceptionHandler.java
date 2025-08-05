/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.helpampm.address.AddressException;
import com.helpampm.auth.exceptions.InvalidCredentialsException;
import com.helpampm.common.ExceptionDto;
import com.helpampm.common.UnauthorizedException;
import com.helpampm.common.services.FileException;
import com.helpampm.customer.CustomerException;
import com.helpampm.livelocation.LocationException;
import com.helpampm.metadata.category.CategoryException;
import com.helpampm.metadata.info.MetadataException;
import com.helpampm.metadata.pricing.PricingException;
import com.helpampm.metadata.tax.TaxException;
import com.helpampm.metadata.timeslot.TimeslotException;
import com.helpampm.notifications.NotificationException;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.insurance.InsuranceException;
import com.helpampm.provider.license.LicenseException;
import com.helpampm.provider.vehicle.VehicleException;
import com.helpampm.quote.QuoteException;
import com.helpampm.reviews.ReviewException;
import io.jsonwebtoken.ExpiredJwtException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.sql.SQLException;

@ControllerAdvice
@Slf4j
/*
  @author kuldeep
 */
public class HelpExceptionHandler {
    @ExceptionHandler(AddressException.class)
    public ResponseEntity<ExceptionDto> handleException(AddressException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).status(400).build());
    }

    @ExceptionHandler(TimeslotException.class)
    public ResponseEntity<ExceptionDto> handleException(TimeslotException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());

    }

    @ExceptionHandler(TaxException.class)
    public ResponseEntity<ExceptionDto> handleException(TaxException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(PricingException.class)
    public ResponseEntity<ExceptionDto> handleException(PricingException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(CategoryException.class)
    public ResponseEntity<ExceptionDto> handleException(CategoryException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).status(400).build());
    }

    @ExceptionHandler(CustomerException.class)
    public ResponseEntity<ExceptionDto> handleException(CustomerException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(ExpiredJwtException.class)
    public ResponseEntity<ExceptionDto> handleException(ExpiredJwtException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(ProviderException.class)
    public ResponseEntity<ExceptionDto> handleException(ProviderException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(InsuranceException.class)
    public ResponseEntity<ExceptionDto> handleException(InsuranceException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(LicenseException.class)
    public ResponseEntity<ExceptionDto> handleException(LicenseException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(MetadataException.class)
    public ResponseEntity<ExceptionDto> handleException(MetadataException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(NotificationException.class)
    public ResponseEntity<ExceptionDto> handleException(NotificationException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.ok(ExceptionDto.builder().message(exception.getMessage()).status(500).build());
    }

    @ExceptionHandler(QuoteException.class)
    public ResponseEntity<ExceptionDto> handleException(QuoteException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.ok(ExceptionDto.builder()
                .message(exception.getMessage())
                .status(exception.getStatus()).build());
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ExceptionDto> handleException(HttpMessageNotReadableException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.ok(ExceptionDto.builder().message(exception.getMessage()).status(500).build());
    }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<ExceptionDto> handleException(UnauthorizedException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.ok(ExceptionDto.builder().message(exception.getMessage()).status(500).build());
    }

    @ExceptionHandler(ReviewException.class)
    public ResponseEntity<ExceptionDto> handleException(ReviewException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.ok(ExceptionDto.builder().message(exception.getMessage()).status(500).build());
    }

    @ExceptionHandler(IncorrectResultSizeDataAccessException.class)
    public ResponseEntity<ExceptionDto> handleException(IncorrectResultSizeDataAccessException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.ok(ExceptionDto.builder().message(exception.getMessage()).status(500).build());
    }

    @ExceptionHandler(FileException.class)
    public ResponseEntity<ExceptionDto> handleException(FileException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public ResponseEntity<ExceptionDto> handleException(InvalidCredentialsException exception) {
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(LocationException.class)
    public ResponseEntity<ExceptionDto> handleException(LocationException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ExceptionDto> handleException(Exception exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(JsonProcessingException.class)
    public ResponseEntity<ExceptionDto> handleException(JsonProcessingException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ExceptionDto> handleException(IllegalStateException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.internalServerError().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(SQLException.class)
    public ResponseEntity<ExceptionDto> handleException(SQLException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.internalServerError().body(ExceptionDto.builder().message(exception.getMessage()).build());
    }

    @ExceptionHandler(VehicleException.class)
    public ResponseEntity<ExceptionDto> handleException(VehicleException exception) {
        if(log.isDebugEnabled()) {
            exception.printStackTrace();
        } else {
            log.error(exception.getClass().getName() + ": " + exception.getMessage());
        }
        return ResponseEntity.status(exception.getStatus().value())
                .body(ExceptionDto.builder().message(exception.getMessage())
                        .status(exception.getStatus().value()).build());
    }
}
