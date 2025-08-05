// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderLogModel _$ProviderLogModelFromJson(Map<String, dynamic> json) =>
    ProviderLogModel(
      countModel: (json['countModel'] as List<dynamic>?)
          ?.map((e) => CountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      accountCompleted: json['accountCompleted'] as bool?,
      stripeAccountCompleted: json['stripeAccountCompleted'] as bool?,
    );

Map<String, dynamic> _$ProviderLogModelToJson(ProviderLogModel instance) =>
    <String, dynamic>{
      'countModel': instance.countModel,
      'accountCompleted': instance.accountCompleted,
      'stripeAccountCompleted': instance.stripeAccountCompleted,
    };

CountModel _$CountModelFromJson(Map<String, dynamic> json) => CountModel(
      value: json['value'] as String?,
      text: json['text'] as String?,
      bgColor: json['bgColor'] as String?,
      amount: json['amount'] as bool?,
    );

Map<String, dynamic> _$CountModelToJson(CountModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'bgColor': instance.bgColor,
      'amount': instance.amount,
    };
