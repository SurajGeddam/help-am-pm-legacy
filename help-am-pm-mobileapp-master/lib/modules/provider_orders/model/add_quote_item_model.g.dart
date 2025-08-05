// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_quote_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddQuoteItemModel _$AddQuoteItemModelFromJson(Map<String, dynamic> json) =>
    AddQuoteItemModel(
      quoteItemId: json['quoteItemId'] as int?,
      description: json['description'] as String?,
      itemPrice: (json['itemPrice'] as num?)?.toDouble(),
      taxAmount: (json['taxAmount'] as num?)?.toDouble(),
      totalQuotePrice: (json['totalQuotePrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddQuoteItemModelToJson(AddQuoteItemModel instance) =>
    <String, dynamic>{
      'quoteItemId': instance.quoteItemId,
      'description': instance.description,
      'itemPrice': instance.itemPrice,
      'taxAmount': instance.taxAmount,
      'totalQuotePrice': instance.totalQuotePrice,
    };
