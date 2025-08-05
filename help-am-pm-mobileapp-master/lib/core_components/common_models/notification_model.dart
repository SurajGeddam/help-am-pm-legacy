import 'package:json_annotation/json_annotation.dart';

import '../../utils/app_strings.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String header;
  final String? notificationPic;
  final String title;
  final String description;
  final String delayTime;
  final bool isRead;

  const NotificationModel({
    this.header = AppStrings.emptyString,
    this.notificationPic,
    this.title = AppStrings.emptyString,
    this.description = AppStrings.emptyString,
    this.delayTime = AppStrings.emptyString,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
