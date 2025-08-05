import 'package:json_annotation/json_annotation.dart';

import '../../../utils/app_strings.dart';

part 'payment_status_model.g.dart';

@JsonSerializable()
class PaymentStatusModel {
  int? status;
  String? message;
  String? transactionNumber;

  PaymentStatusModel(
      {this.status,
      this.message = AppStrings.emptyString,
      this.transactionNumber});

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusModelToJson(this);
}
