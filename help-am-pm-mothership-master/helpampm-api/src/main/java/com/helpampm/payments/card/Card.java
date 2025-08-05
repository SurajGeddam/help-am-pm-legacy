/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments.card;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDate;

/**
 * @author kuldeep
 */
@Data
@Entity
@Table(name = "tb_payment_cards")
public class Card {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "type")
    @Enumerated(EnumType.STRING)
    private CardType cardType;
    @Column(name = "customer_unique_id")
    private String customerUniqueId;
    @Column(name = "card_number")
    private String cardNumber;
    @Column(name = "cvv")
    private String cvv;
    @Column(name = "expiry_date")
    private LocalDate expiryDate;
    @Column(name = "name")
    private String name;

    public void validate() {
    }
}
