// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageStatusModel _$MessageStatusModelFromJson(Map<String, dynamic> json) =>
    MessageStatusModel(
      status: json['status'] as int?,
      message: json['message'] as String? ?? AppStrings.emptyString,
    );

Map<String, dynamic> _$MessageStatusModelToJson(MessageStatusModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
