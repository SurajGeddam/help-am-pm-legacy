// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_address_req_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveAddressReqBodyModel _$SaveAddressReqBodyModelFromJson(
        Map<String, dynamic> json) =>
    SaveAddressReqBodyModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? AppStrings.emptyString,
      phone: json['phone'] as String? ?? AppStrings.emptyString,
      house: json['house'] as String? ?? AppStrings.emptyString,
      building: json['building'] as String? ?? AppStrings.emptyString,
      street: json['street'] as String? ?? AppStrings.emptyString,
      district: json['district'] as String? ?? AppStrings.emptyString,
      county: json['county'] as String? ?? AppStrings.emptyString,
      country: json['country'] as String? ?? AppStrings.emptyString,
      zipcode: json['zipcode'] as String? ?? AppStrings.emptyString,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      altitude: (json['altitude'] as num?)?.toDouble() ?? 0.0,
      customerUniqueId:
          json['customerUniqueId'] as String? ?? AppStrings.emptyString,
      providerUniqueId:
          json['providerUniqueId'] as String? ?? AppStrings.emptyString,
      createdAt: json['createdAt'] as String? ?? AppStrings.emptyString,
      lastUpdatedAt: json['lastUpdatedAt'] as String? ?? AppStrings.emptyString,
      uniqueIds: json['uniqueIds'] as String? ?? AppStrings.emptyString,
      coordinates: json['coordinates'] as String? ?? AppStrings.emptyString,
      buildingDetails:
          json['buildingDetails'] as String? ?? AppStrings.emptyString,
      addressType: json['addressType'] as String? ?? AppStrings.emptyString,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$SaveAddressReqBodyModelToJson(
        SaveAddressReqBodyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'house': instance.house,
      'building': instance.building,
      'street': instance.street,
      'district': instance.district,
      'county': instance.county,
      'country': instance.country,
      'zipcode': instance.zipcode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'customerUniqueId': instance.customerUniqueId,
      'providerUniqueId': instance.providerUniqueId,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'uniqueIds': instance.uniqueIds,
      'coordinates': instance.coordinates,
      'buildingDetails': instance.buildingDetails,
      'addressType': instance.addressType,
      'isDefault': instance.isDefault,
    };
