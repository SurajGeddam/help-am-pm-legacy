import 'package:json_annotation/json_annotation.dart';
import '../../../../../utils/app_strings.dart';

part 'provider_profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  String profilePicture;
  String name;
  String firstName;
  String lastName;
  String email;
  String mobileNumber;
  String dateOfBirth;
  String imageBytes;
  bool smsEnable;
  bool emailEnable;

  ProfileModel(
      {this.profilePicture = AppStrings.emptyString,
      this.name = AppStrings.emptyString,
      this.firstName = AppStrings.emptyString,
      this.lastName = AppStrings.emptyString,
      this.email = AppStrings.emptyString,
      this.mobileNumber = AppStrings.emptyString,
      this.dateOfBirth = AppStrings.emptyString,
      this.imageBytes = AppStrings.emptyString,
      this.smsEnable = false,
      this.emailEnable = false});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
