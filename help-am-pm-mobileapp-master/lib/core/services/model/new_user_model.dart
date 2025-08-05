import 'package:json_annotation/json_annotation.dart';

part 'new_user_model.g.dart';

@JsonSerializable()
class NewUser {
  String? name;
  String? job;
  String? id;
  String? createdAt;
  String? updatedAt;

  NewUser({this.name, this.job, this.id, this.createdAt, this.updatedAt});

  factory NewUser.fromJson(Map<String, dynamic> json) =>
      _$NewUserFromJson(json);
  Map<String, dynamic> toJson() => _$NewUserToJson(this);
}
