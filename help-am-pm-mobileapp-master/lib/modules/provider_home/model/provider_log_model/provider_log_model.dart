import 'package:json_annotation/json_annotation.dart';
part 'provider_log_model.g.dart';

@JsonSerializable()
class ProviderLogModel {
  List<CountModel>? countModel;
  bool? accountCompleted;
  bool? stripeAccountCompleted;

  ProviderLogModel(
      {this.countModel, this.accountCompleted, this.stripeAccountCompleted});

  factory ProviderLogModel.fromJson(Map<String, dynamic> json) =>
      _$ProviderLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderLogModelToJson(this);
}

@JsonSerializable()
class CountModel {
  String? value;
  String? text;
  String? bgColor;
  bool? amount;

  CountModel({this.value, this.text, this.bgColor, this.amount});

  factory CountModel.fromJson(Map<String, dynamic> json) =>
      _$CountModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountModelToJson(this);
}
