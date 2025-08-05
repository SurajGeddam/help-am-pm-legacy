// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewOrderListModel _$NewOrderListModelFromJson(Map<String, dynamic> json) =>
    NewOrderListModel(
      count: json['count'] as int?,
      quotes: (json['quotes'] as List<dynamic>?)
          ?.map((e) => Quotes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewOrderListModelToJson(NewOrderListModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'quotes': instance.quotes,
    };

Quotes _$QuotesFromJson(Map<String, dynamic> json) => Quotes(
      textOnYellow: json['textOnYellow'] as String? ?? AppStrings.emptyString,
      categoryName: json['categoryName'] as String? ?? AppStrings.emptyString,
      customerName: json['customerName'] as String? ?? AppStrings.emptyString,
      customerProfilePic:
          json['customerProfilePic'] as String? ?? AppStrings.emptyString,
      customerPhone: json['customerPhone'] as String? ?? AppStrings.emptyString,
      customerEmail: json['customerEmail'] as String? ?? AppStrings.emptyString,
      customerUniqueId:
          json['customerUniqueId'] as String? ?? AppStrings.emptyString,
      customerAddress: json['customerAddress'] == null
          ? null
          : SaveAddressReqBodyModel.fromJson(
              json['customerAddress'] as Map<String, dynamic>),
      serviceCategory:
          json['serviceCategory'] as String? ?? AppStrings.emptyString,
      serviceCharge: (json['serviceCharge'] as num?)?.toDouble() ?? 0.0,
      grossBill: (json['grossBill'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalBill: (json['totalBill'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      serviceDate: json['serviceDate'] == null
          ? null
          : DateTime.parse(json['serviceDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      orderNumber: json['orderNumber'] as String? ?? AppStrings.emptyString,
      serviceDescription:
          json['serviceDescription'] as String? ?? AppStrings.emptyString,
      timeslot: json['timeslot'] == null
          ? null
          : Timeslots.fromJson(json['timeslot'] as Map<String, dynamic>),
      searchRadius: (json['searchRadius'] as num?)?.toDouble() ?? 0.0,
      providerName: json['providerName'] as String? ?? AppStrings.emptyString,
      currency: json['currency'] as String? ?? AppStrings.emptyString,
      status: json['status'] as String? ?? AppStrings.emptyString,
      quoteProvider: json['quoteProvider'] == null
          ? null
          : QuoteProvider.fromJson(
              json['quoteProvider'] as Map<String, dynamic>),
      payment: json['payment'] == null
          ? null
          : PaymentDetails.fromJson(json['payment'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ItemDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduled: json['scheduled'] as bool? ?? false,
      orderLocked: json['orderLocked'] as bool? ?? false,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      eta: json['eta'] as String?,
      imagePath: json['imagePath'] as String? ?? AppStrings.emptyString,
    );

Map<String, dynamic> _$QuotesToJson(Quotes instance) => <String, dynamic>{
      'textOnYellow': instance.textOnYellow,
      'categoryName': instance.categoryName,
      'customerName': instance.customerName,
      'customerUniqueId': instance.customerUniqueId,
      'customerProfilePic': instance.customerProfilePic,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'customerAddress': instance.customerAddress,
      'serviceCategory': instance.serviceCategory,
      'serviceCharge': instance.serviceCharge,
      'grossBill': instance.grossBill,
      'taxAmount': instance.taxAmount,
      'totalBill': instance.totalBill,
      'distance': instance.distance,
      'serviceDate': instance.serviceDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'orderNumber': instance.orderNumber,
      'serviceDescription': instance.serviceDescription,
      'timeslot': instance.timeslot,
      'searchRadius': instance.searchRadius,
      'providerName': instance.providerName,
      'currency': instance.currency,
      'status': instance.status,
      'quoteProvider': instance.quoteProvider,
      'payment': instance.payment,
      'items': instance.items,
      'scheduled': instance.scheduled,
      'orderLocked': instance.orderLocked,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'eta': instance.eta,
      'imagePath': instance.imagePath,
    };

QuoteProvider _$QuoteProviderFromJson(Map<String, dynamic> json) =>
    QuoteProvider(
      id: json['id'] as int?,
      uniqueId: json['uniqueId'] as String?,
      providerName: json['providerName'] as String?,
      providerImage: json['providerImage'] as String? ?? AppStrings.emptyString,
    );

Map<String, dynamic> _$QuoteProviderToJson(QuoteProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uniqueId': instance.uniqueId,
      'providerName': instance.providerName,
      'providerImage': instance.providerImage,
    };
