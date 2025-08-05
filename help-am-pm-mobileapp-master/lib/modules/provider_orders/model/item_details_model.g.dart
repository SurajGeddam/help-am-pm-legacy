// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemDetails _$ItemDetailsFromJson(Map<String, dynamic> json) => ItemDetails(
      quoteItemId: json['quoteItemId'] as int,
      description: json['description'] as String,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      taxAmount: json['taxAmount'] as String? ?? "0.00",
      totalQuotePrice: json['totalQuotePrice'] as String? ?? "0.00",
      isFromDelete: json['isFromDelete'] as bool? ?? false,
    );

Map<String, dynamic> _$ItemDetailsToJson(ItemDetails instance) =>
    <String, dynamic>{
      'quoteItemId': instance.quoteItemId,
      'description': instance.description,
      'itemPrice': instance.itemPrice,
      'taxAmount': instance.taxAmount,
      'totalQuotePrice': instance.totalQuotePrice,
      'isFromDelete': instance.isFromDelete,
    };
