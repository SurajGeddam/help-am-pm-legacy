import 'package:json_annotation/json_annotation.dart';

import '../../../../../utils/app_strings.dart';

part 'save_address_req_body_model.g.dart';

@JsonSerializable()
class SaveAddressReqBodyModel {
  int? id;
  String name;
  String phone;
  String house;
  String building;
  String street;
  String district;
  String county;
  String country;
  String zipcode;
  double latitude;
  double longitude;
  double altitude;
  String customerUniqueId;
  String providerUniqueId;
  String createdAt;
  String lastUpdatedAt;
  String uniqueIds;
  String coordinates;
  String buildingDetails;
  String addressType;
  bool isDefault;

  SaveAddressReqBodyModel(
      {this.id,
      this.name = AppStrings.emptyString,
      this.phone = AppStrings.emptyString,
      this.house = AppStrings.emptyString,
      this.building = AppStrings.emptyString,
      this.street = AppStrings.emptyString,
      this.district = AppStrings.emptyString,
      this.county = AppStrings.emptyString,
      this.country = AppStrings.emptyString,
      this.zipcode = AppStrings.emptyString,
      this.latitude = 0.0,
      this.longitude = 0.0,
      this.altitude = 0.0,
      this.customerUniqueId = AppStrings.emptyString,
      this.providerUniqueId = AppStrings.emptyString,
      this.createdAt = AppStrings.emptyString,
      this.lastUpdatedAt = AppStrings.emptyString,
      this.uniqueIds = AppStrings.emptyString,
      this.coordinates = AppStrings.emptyString,
      this.buildingDetails = AppStrings.emptyString,
      this.addressType = AppStrings.emptyString,
      this.isDefault = false});

  factory SaveAddressReqBodyModel.fromJson(Map<String, dynamic> json) =>
      _$SaveAddressReqBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaveAddressReqBodyModelToJson(this);
}
