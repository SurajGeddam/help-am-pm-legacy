// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      profilePicture:
          json['profilePicture'] as String? ?? AppStrings.emptyString,
      name: json['name'] as String? ?? AppStrings.emptyString,
      firstName: json['firstName'] as String? ?? AppStrings.emptyString,
      lastName: json['lastName'] as String? ?? AppStrings.emptyString,
      email: json['email'] as String? ?? AppStrings.emptyString,
      mobileNumber: json['mobileNumber'] as String? ?? AppStrings.emptyString,
      dateOfBirth: json['dateOfBirth'] as String? ?? AppStrings.emptyString,
      imageBytes: json['imageBytes'] as String? ?? AppStrings.emptyString,
      smsEnable: json['smsEnable'] as bool? ?? false,
      emailEnable: json['emailEnable'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'profilePicture': instance.profilePicture,
      'name': instance.name,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'dateOfBirth': instance.dateOfBirth,
      'imageBytes': instance.imageBytes,
      'smsEnable': instance.smsEnable,
      'emailEnable': instance.emailEnable,
    };
