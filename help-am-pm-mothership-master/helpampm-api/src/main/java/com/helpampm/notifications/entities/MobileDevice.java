/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.notifications.entities;

import com.helpampm.notifications.push.DeviceType;
import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tb_mobile_devices")
@Data
/*
  @author kuldeep
 */ public class MobileDevice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Enumerated(EnumType.STRING)
    @Column(name = "device_type")
    private DeviceType deviceType;
    @Column(name = "device_id")
    private String deviceId;
    @Column(name = "username")
    private String username;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
