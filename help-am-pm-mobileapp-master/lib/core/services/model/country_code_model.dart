import 'package:json_annotation/json_annotation.dart';
part 'country_code_model.g.dart';

@JsonSerializable()
class CountryCodeModel {
  int? id;
  String? name;
  String? dialCode;
  String? code;

  CountryCodeModel({this.id, this.name, this.dialCode, this.code});

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) =>
      _$CountryCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountryCodeModelToJson(this);
}
