package com.helpampm.metadata.country;

import java.io.Serializable;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
/*
 * @author ajay
 */
public class CountryDto implements Serializable {
	private Long id;
	private String name;
	private String dialCode;
	private String code;

	public static CountryDto buildWithContry(Country country) {
		return CountryDto.builder().id(country.getId()).name(country.getName()).dialCode(country.getDialCode())
				.code(country.getCode()).build();
	}
}
