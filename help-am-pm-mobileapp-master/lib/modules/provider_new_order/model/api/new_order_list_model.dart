import 'package:helpampm/modules/onboarding/model/category_model/api/category_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../utils/app_strings.dart';
import '../../../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../../payment/model/payment_details_model.dart';
import '../../../provider_orders/model/item_details_model.dart';

part 'new_order_list_model.g.dart';

@JsonSerializable()
class NewOrderListModel {
  int? count;
  List<Quotes>? quotes;

  NewOrderListModel({this.count, this.quotes});

  factory NewOrderListModel.fromJson(Map<String, dynamic> json) =>
      _$NewOrderListModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewOrderListModelToJson(this);
}

@JsonSerializable()
class Quotes {
  String textOnYellow;
  String categoryName;
  String customerName;
  String customerUniqueId;
  String customerProfilePic;
  String customerPhone;
  String customerEmail;
  SaveAddressReqBodyModel? customerAddress;
  String serviceCategory;
  double serviceCharge;
  double grossBill;
  double taxAmount;
  double totalBill;
  double distance;
  DateTime? serviceDate;
  DateTime? createdAt;
  String orderNumber;
  String serviceDescription;
  Timeslots? timeslot;
  double searchRadius;
  String providerName;
  String currency;
  String status;
  QuoteProvider? quoteProvider;
  PaymentDetails? payment;
  List<ItemDetails>? items;
  bool scheduled;
  bool orderLocked;
  DateTime? updatedAt;
  String? eta;
  String imagePath;

  Quotes({
    this.textOnYellow = AppStrings.emptyString,
    this.categoryName = AppStrings.emptyString,
    this.customerName = AppStrings.emptyString,
    this.customerProfilePic = AppStrings.emptyString,
    this.customerPhone = AppStrings.emptyString,
    this.customerEmail = AppStrings.emptyString,
    this.customerUniqueId = AppStrings.emptyString,
    this.customerAddress,
    this.serviceCategory = AppStrings.emptyString,
    this.serviceCharge = 0.0,
    this.grossBill = 0.0,
    this.taxAmount = 0.0,
    this.totalBill = 0.0,
    this.distance = 0.0,
    this.serviceDate,
    this.createdAt,
    this.orderNumber = AppStrings.emptyString,
    this.serviceDescription = AppStrings.emptyString,
    this.timeslot,
    this.searchRadius = 0.0,
    this.providerName = AppStrings.emptyString,
    this.currency = AppStrings.emptyString,
    this.status = AppStrings.emptyString,
    this.quoteProvider,
    this.payment,
    this.items,
    this.scheduled = false,
    this.orderLocked = false,
    this.updatedAt,
    this.eta,
    this.imagePath = AppStrings.emptyString,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) => _$QuotesFromJson(json);

  Map<String, dynamic> toJson() => _$QuotesToJson(this);
}

@JsonSerializable()
class QuoteProvider {
  int? id;
  String? uniqueId;
  String? providerName;
  String providerImage;

  QuoteProvider(
      {this.id,
      this.uniqueId,
      this.providerName,
      this.providerImage = AppStrings.emptyString});

  factory QuoteProvider.fromJson(Map<String, dynamic> json) =>
      _$QuoteProviderFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteProviderToJson(this);
}
