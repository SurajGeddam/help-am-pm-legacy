// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    AuthTokenModel(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] == null
          ? null
          : RefreshToken.fromJson(json['refreshToken'] as Map<String, dynamic>),
      username: json['username'] as String?,
      completedPage: json['completedPage'] as String?,
      role: json['role'] as String?,
      expiryDate: json['expiryDate'] as String?,
      accountSetupCompleted: json['accountSetupCompleted'] as bool?,
      stripeSetupDone: json['stripeSetupDone'] as bool?,
      userDetailsDto: json['userDetailsDto'] == null
          ? null
          : UserDetailsDto.fromJson(
              json['userDetailsDto'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'username': instance.username,
      'completedPage': instance.completedPage,
      'role': instance.role,
      'expiryDate': instance.expiryDate,
      'accountSetupCompleted': instance.accountSetupCompleted,
      'stripeSetupDone': instance.stripeSetupDone,
      'userDetailsDto': instance.userDetailsDto,
      'categories': instance.categories,
    };

RefreshToken _$RefreshTokenFromJson(Map<String, dynamic> json) => RefreshToken(
      id: json['id'] as int?,
      token: json['token'] as String?,
      expiryDate: json['expiryDate'] as String?,
      used: json['used'] as bool?,
    );

Map<String, dynamic> _$RefreshTokenToJson(RefreshToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'expiryDate': instance.expiryDate,
      'used': instance.used,
    };

UserDetailsDto _$UserDetailsDtoFromJson(Map<String, dynamic> json) =>
    UserDetailsDto(
      username: json['username'] as String? ?? AppStrings.emptyString,
      enabled: json['enabled'] as bool?,
      authority: json['authority'] as String?,
      customerUniqueId: json['customerUniqueId'] as String?,
      companyUniqueId: json['companyUniqueId'] as String?,
      providerUniqueId: json['providerUniqueId'] as String?,
      parentCompanyUniqueId: json['parentCompanyUniqueId'] as String?,
      superAdmin: json['superAdmin'] as bool?,
      phone: json['phone'] as String? ?? AppStrings.emptyString,
      email: json['email'] as String? ?? AppStrings.emptyString,
      name: json['name'] as String? ?? AppStrings.emptyString,
      profilePicture:
          json['profilePicture'] as String? ?? AppStrings.emptyString,
      dateOfBirth: json['dateOfBirth'] as String? ?? AppStrings.emptyString,
      profileBytes: json['profileBytes'] as String? ?? AppStrings.emptyString,
    );

Map<String, dynamic> _$UserDetailsDtoToJson(UserDetailsDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'enabled': instance.enabled,
      'authority': instance.authority,
      'customerUniqueId': instance.customerUniqueId,
      'companyUniqueId': instance.companyUniqueId,
      'providerUniqueId': instance.providerUniqueId,
      'parentCompanyUniqueId': instance.parentCompanyUniqueId,
      'phone': instance.phone,
      'email': instance.email,
      'name': instance.name,
      'superAdmin': instance.superAdmin,
      'profilePicture': instance.profilePicture,
      'dateOfBirth': instance.dateOfBirth,
      'profileBytes': instance.profileBytes,
    };
