// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyTypeModel _$PolicyTypeModelFromJson(Map<String, dynamic> json) =>
    PolicyTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? AppStrings.emptyString,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$PolicyTypeModelToJson(PolicyTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
    };
