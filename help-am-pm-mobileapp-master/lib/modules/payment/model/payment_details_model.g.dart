// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      id: json['id'] as int?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentId: json['paymentId'] as String?,
      confirmationMethod: json['confirmationMethod'] as String?,
      currency: json['currency'] as String?,
      amount: json['amount'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentStatus': instance.paymentStatus,
      'paymentId': instance.paymentId,
      'confirmationMethod': instance.confirmationMethod,
      'currency': instance.currency,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
    };
