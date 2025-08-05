// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryCodeModel _$CountryCodeModelFromJson(Map<String, dynamic> json) =>
    CountryCodeModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      dialCode: json['dialCode'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$CountryCodeModelToJson(CountryCodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dialCode': instance.dialCode,
      'code': instance.code,
    };
