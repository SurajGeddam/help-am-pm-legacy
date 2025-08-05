import 'package:json_annotation/json_annotation.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotificationDataModel {
  String? subject;
  String? body;
  String? status;

  NotificationDataModel({this.subject, this.body, this.status});

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataModelToJson(this);
}
