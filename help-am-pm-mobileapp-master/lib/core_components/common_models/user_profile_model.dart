import 'package:helpampm/utils/app_strings.dart';

class UserProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String mobileNumber;
  final String dob;
  final String password;

  UserProfileModel({
    this.userId = AppStrings.emptyString,
    this.firstName = AppStrings.emptyString,
    this.lastName = AppStrings.emptyString,
    this.emailAddress = AppStrings.emptyString,
    this.mobileNumber = AppStrings.emptyString,
    this.dob = AppStrings.emptyString,
    this.password = AppStrings.emptyString,
  });
}
