import 'package:json_annotation/json_annotation.dart';
part 'get_token_model.g.dart';

@JsonSerializable()
class GetTokenModel {
  RefreshToken? refreshToken;
  String? username;
  String? password;

  GetTokenModel({this.refreshToken, this.username, this.password});

  factory GetTokenModel.fromJson(Map<String, dynamic> json) =>
      _$GetTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetTokenModelToJson(this);
}

@JsonSerializable()
class RefreshToken {
  int? id;
  String? token;
  bool? isUsed;
  String? usedAt;
  String? expiryDate;
  String? createdAt;
  String? lastUpdatedAt;

  RefreshToken(
      {this.id,
      this.token,
      this.isUsed,
      this.usedAt,
      this.expiryDate,
      this.createdAt,
      this.lastUpdatedAt});

  factory RefreshToken.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);
}
