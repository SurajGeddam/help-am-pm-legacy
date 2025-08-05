import '../../../../utils/app_strings.dart';

class SaveCompanyDetailReqBodyModel {
  String companyName;
  String companyPhone;
  String companyEmail;
  String companyWebsite;
  Address? address;

  SaveCompanyDetailReqBodyModel(
      {this.companyName = AppStrings.emptyString,
      this.companyPhone = AppStrings.emptyString,
      this.companyEmail = AppStrings.emptyString,
      this.companyWebsite = AppStrings.emptyString,
      required this.address});
}

class Address {
  String house;
  String building;
  String street;
  String district;
  String county;
  String country;
  String zipcode;
  double latitude;
  double longitude;
  int altitude;

  Address({
    this.house = AppStrings.emptyString,
    this.building = AppStrings.emptyString,
    this.street = AppStrings.emptyString,
    this.district = AppStrings.emptyString,
    this.county = AppStrings.emptyString,
    this.country = AppStrings.emptyString,
    this.zipcode = AppStrings.emptyString,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.altitude = 0,
  });
}
