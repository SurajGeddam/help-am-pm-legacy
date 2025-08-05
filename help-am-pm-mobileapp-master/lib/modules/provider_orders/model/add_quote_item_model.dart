import 'package:json_annotation/json_annotation.dart';

part 'add_quote_item_model.g.dart';

@JsonSerializable()
class AddQuoteItemModel {
  int? quoteItemId;
  String? description;
  double? itemPrice;
  double? taxAmount;
  double? totalQuotePrice;

  AddQuoteItemModel(
      {this.quoteItemId,
      this.description,
      this.itemPrice,
      this.taxAmount,
      this.totalQuotePrice});

  factory AddQuoteItemModel.fromJson(Map<String, dynamic> json) =>
      _$AddQuoteItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddQuoteItemModelToJson(this);
}
