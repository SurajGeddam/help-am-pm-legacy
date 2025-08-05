// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatusModel _$PaymentStatusModelFromJson(Map<String, dynamic> json) =>
    PaymentStatusModel(
      status: json['status'] as int?,
      message: json['message'] as String? ?? AppStrings.emptyString,
      transactionNumber: json['transactionNumber'] as String?,
    );

Map<String, dynamic> _$PaymentStatusModelToJson(PaymentStatusModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'transactionNumber': instance.transactionNumber,
    };
