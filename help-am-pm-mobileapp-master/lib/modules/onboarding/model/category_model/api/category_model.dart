import 'package:helpampm/utils/app_constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? icon;
  bool? residentialService;
  bool? commercialService;
  List<Timeslots>? timeslots;
  bool? isActive;
  String? createdAt;
  String? lastUpdatedAt;

  CategoryModel(
      {this.id,
      this.name,
      this.description,
      this.icon,
      this.residentialService,
      this.commercialService,
      this.timeslots,
      this.isActive,
      this.createdAt,
      this.lastUpdatedAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class Timeslots {
  int? id;
  String? name;
  String? startTime;
  String? endTime;
  bool? isActive;
  Pricing? pricing;
  int? categoryId;
  String? createdAt;
  String? lastUpdatedAt;
  bool isSelected;

  Timeslots(
      {this.id,
      this.name,
      this.startTime,
      this.endTime,
      this.isActive,
      this.pricing,
      this.categoryId,
      this.createdAt,
      this.lastUpdatedAt,
      this.isSelected = false});

  factory Timeslots.fromJson(Map<String, dynamic> json) =>
      _$TimeslotsFromJson(json);
  Map<String, dynamic> toJson() => _$TimeslotsToJson(this);
}

@JsonSerializable()
class Pricing {
  int? id;
  String? type;
  double residentialPrice;
  double commercialPrice;
  bool? isActive;
  String currency;
  String? createdAt;
  String? lastUpdatedAt;

  Pricing(
      {this.id,
      this.type,
      this.residentialPrice = 0.0,
      this.commercialPrice = 0.0,
      this.isActive,
      this.currency = AppConstants.dollor,
      this.createdAt,
      this.lastUpdatedAt});

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);
  Map<String, dynamic> toJson() => _$PricingToJson(this);
}
