import 'package:json_annotation/json_annotation.dart';

part 'search_provider_response_model.g.dart';

@JsonSerializable()
class SearchProviderModel {
  String? providerUniqueId;
  String? name;
  String? username;
  String? email;
  double? latitude;
  double? longitude;
  double? altitude;
  String? phone;
  double? customerAverageRating;
  int? totalCustomerRatings;
  String? companyUniqueId;
  String? parentCompanyUniqueId;
  bool? smsNotification;
  bool? emailNotification;
  bool? pushNotification;

  SearchProviderModel(
      {this.providerUniqueId,
      this.name,
      this.username,
      this.email,
      this.latitude,
      this.longitude,
      this.altitude,
      this.phone,
      this.customerAverageRating,
      this.totalCustomerRatings,
      this.companyUniqueId,
      this.parentCompanyUniqueId,
      this.smsNotification,
      this.emailNotification,
      this.pushNotification});

  factory SearchProviderModel.fromJson(Map<String, dynamic> json) =>
      _$SearchProviderModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchProviderModelToJson(this);
}
