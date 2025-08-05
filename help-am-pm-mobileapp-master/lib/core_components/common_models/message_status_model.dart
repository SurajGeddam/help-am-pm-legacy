import 'package:json_annotation/json_annotation.dart';

import '../../utils/app_strings.dart';

part 'message_status_model.g.dart';

@JsonSerializable()
class MessageStatusModel {
  int? status;
  String? message;

  MessageStatusModel({this.status, this.message = AppStrings.emptyString});

  factory MessageStatusModel.fromJson(Map<String, dynamic> json) =>
      _$MessageStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageStatusModelToJson(this);
}
