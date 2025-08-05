import 'package:json_annotation/json_annotation.dart';

part 'payment_details_model.g.dart';

@JsonSerializable()
class PaymentDetails {
  int? id;
  String? paymentStatus;
  String? paymentId;
  String? confirmationMethod;
  String? currency;
  int? amount;
  String? paymentMethod;

  PaymentDetails(
      {this.id,
      this.paymentStatus,
      this.paymentId,
      this.confirmationMethod,
      this.currency,
      this.amount,
      this.paymentMethod});

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);
}
