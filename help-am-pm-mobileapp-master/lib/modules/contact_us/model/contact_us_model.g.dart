// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_us_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactUsModel _$ContactUsModelFromJson(Map<String, dynamic> json) =>
    ContactUsModel(
      helpPhone: json['helpPhone'] as String? ?? AppStrings.emptyString,
      helpEmail: json['helpEmail'] as String? ?? AppStrings.emptyString,
    );

Map<String, dynamic> _$ContactUsModelToJson(ContactUsModel instance) =>
    <String, dynamic>{
      'helpPhone': instance.helpPhone,
      'helpEmail': instance.helpEmail,
    };
