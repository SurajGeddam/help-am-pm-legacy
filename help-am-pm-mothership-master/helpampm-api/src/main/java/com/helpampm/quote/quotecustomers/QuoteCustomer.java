/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quotecustomers;

import com.helpampm.address.Address;
import com.helpampm.quote.quoteaddress.QuoteAddress;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Entity
@Table(name = "tb_quote_customer_info")
@Data
@NoArgsConstructor
/*
  @author kuldeep
 */
public class QuoteCustomer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "customer_unique_id")
    private String uniqueId;

    @Column(name = "customer_name")
    private String customerName;
    @Column(name = "phone")
    private String email;
    @Column(name = "email")
    private String phone;
    @Column(name = "profile_image_path")
    private String profileImagePath;
    @OneToOne
    private QuoteAddress quoteAddress;

    public void validate() {
    }

    public static QuoteAddress fromAddress(Address address) {
        QuoteAddress quoteAddress = new QuoteAddress();
        quoteAddress.setAltitude(address.getAltitude());
        quoteAddress.setLongitude(address.getLongitude());
        quoteAddress.setLatitude(address.getLatitude());
        quoteAddress.setHouse(address.getHouse());
        quoteAddress.setBuilding(address.getBuilding());
        quoteAddress.setCounty(address.getCounty());
        quoteAddress.setCountry(address.getCountry());
        quoteAddress.setDistrict(address.getDistrict());
        quoteAddress.setStreet(address.getStreet());
        quoteAddress.setZipcode(address.getZipcode());
        return quoteAddress;
    }
}
