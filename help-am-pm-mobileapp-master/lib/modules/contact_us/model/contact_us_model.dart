import 'package:json_annotation/json_annotation.dart';
import '../../../../../utils/app_strings.dart';

part 'contact_us_model.g.dart';

@JsonSerializable()
class ContactUsModel {
  String helpPhone;
  String helpEmail;

  ContactUsModel({
    this.helpPhone = AppStrings.emptyString,
    this.helpEmail = AppStrings.emptyString,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactUsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactUsModelToJson(this);
}
