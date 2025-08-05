import 'package:json_annotation/json_annotation.dart';

part 'item_details_model.g.dart';

@JsonSerializable()
class ItemDetails {
  int quoteItemId;
  String description;
  double itemPrice;
  String taxAmount;
  String totalQuotePrice;
  bool isFromDelete;

  ItemDetails({
    required this.quoteItemId,
    required this.description,
    required this.itemPrice,
    this.taxAmount = "0.00",
    this.totalQuotePrice = "0.00",
    this.isFromDelete = false,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemDetailsToJson(this);
}
