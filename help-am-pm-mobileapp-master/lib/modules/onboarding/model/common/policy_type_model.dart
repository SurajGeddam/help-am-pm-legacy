import 'package:json_annotation/json_annotation.dart';
import '../../../../utils/app_strings.dart';

part 'policy_type_model.g.dart';

@JsonSerializable()
class PolicyTypeModel {
  int id;
  String name;
  bool isActive;

  PolicyTypeModel({
    this.id = 0,
    this.name = AppStrings.emptyString,
    this.isActive = false,
  });

  factory PolicyTypeModel.fromJson(Map<String, dynamic> json) =>
      _$PolicyTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyTypeModelToJson(this);
}
