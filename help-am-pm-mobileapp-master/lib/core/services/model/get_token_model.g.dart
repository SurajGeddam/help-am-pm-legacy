// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTokenModel _$GetTokenModelFromJson(Map<String, dynamic> json) =>
    GetTokenModel(
      refreshToken: json['refreshToken'] == null
          ? null
          : RefreshToken.fromJson(json['refreshToken'] as Map<String, dynamic>),
      username: json['username'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$GetTokenModelToJson(GetTokenModel instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'username': instance.username,
      'password': instance.password,
    };

RefreshToken _$RefreshTokenFromJson(Map<String, dynamic> json) => RefreshToken(
      id: json['id'] as int?,
      token: json['token'] as String?,
      isUsed: json['isUsed'] as bool?,
      usedAt: json['usedAt'] as String?,
      expiryDate: json['expiryDate'] as String?,
      createdAt: json['createdAt'] as String?,
      lastUpdatedAt: json['lastUpdatedAt'] as String?,
    );

Map<String, dynamic> _$RefreshTokenToJson(RefreshToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'isUsed': instance.isUsed,
      'usedAt': instance.usedAt,
      'expiryDate': instance.expiryDate,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
    };
