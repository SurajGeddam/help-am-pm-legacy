import 'package:json_annotation/json_annotation.dart';

import '../../../../utils/app_strings.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel {
  String? token;
  RefreshToken? refreshToken;
  String? username;
  String? completedPage;
  String? role;
  String? expiryDate;
  bool? accountSetupCompleted;
  bool? stripeSetupDone;
  UserDetailsDto? userDetailsDto;
  List<String>? categories;

  AuthTokenModel({
    this.token,
    this.refreshToken,
    this.username,
    this.completedPage,
    this.role,
    this.expiryDate,
    this.accountSetupCompleted,
    this.stripeSetupDone,
    this.userDetailsDto,
    this.categories,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);
}

@JsonSerializable()
class RefreshToken {
  int? id;
  String? token;
  String? expiryDate;
  bool? used;

  RefreshToken({this.id, this.token, this.expiryDate, this.used});

  factory RefreshToken.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);
}

@JsonSerializable()
class UserDetailsDto {
  String username;
  bool? enabled;
  String? authority;
  String? customerUniqueId;
  String? companyUniqueId;
  String? providerUniqueId;
  String? parentCompanyUniqueId;
  String phone;
  String email;
  String name;
  bool? superAdmin;
  String profilePicture;
  String dateOfBirth;
  String profileBytes;

  UserDetailsDto(
      {this.username = AppStrings.emptyString,
      this.enabled,
      this.authority,
      this.customerUniqueId,
      this.companyUniqueId,
      this.providerUniqueId,
      this.parentCompanyUniqueId,
      this.superAdmin,
      this.phone = AppStrings.emptyString,
      this.email = AppStrings.emptyString,
      this.name = AppStrings.emptyString,
      this.profilePicture = AppStrings.emptyString,
      this.dateOfBirth = AppStrings.emptyString,
      this.profileBytes = AppStrings.emptyString});

  factory UserDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailsDtoToJson(this);
}
