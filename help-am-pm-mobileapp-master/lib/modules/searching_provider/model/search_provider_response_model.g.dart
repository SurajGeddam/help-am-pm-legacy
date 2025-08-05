// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchProviderModel _$SearchProviderModelFromJson(Map<String, dynamic> json) =>
    SearchProviderModel(
      providerUniqueId: json['providerUniqueId'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      customerAverageRating:
          (json['customerAverageRating'] as num?)?.toDouble(),
      totalCustomerRatings: json['totalCustomerRatings'] as int?,
      companyUniqueId: json['companyUniqueId'] as String?,
      parentCompanyUniqueId: json['parentCompanyUniqueId'] as String?,
      smsNotification: json['smsNotification'] as bool?,
      emailNotification: json['emailNotification'] as bool?,
      pushNotification: json['pushNotification'] as bool?,
    );

Map<String, dynamic> _$SearchProviderModelToJson(
        SearchProviderModel instance) =>
    <String, dynamic>{
      'providerUniqueId': instance.providerUniqueId,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'phone': instance.phone,
      'customerAverageRating': instance.customerAverageRating,
      'totalCustomerRatings': instance.totalCustomerRatings,
      'companyUniqueId': instance.companyUniqueId,
      'parentCompanyUniqueId': instance.parentCompanyUniqueId,
      'smsNotification': instance.smsNotification,
      'emailNotification': instance.emailNotification,
      'pushNotification': instance.pushNotification,
    };
