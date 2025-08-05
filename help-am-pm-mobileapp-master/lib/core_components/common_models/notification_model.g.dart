// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      header: json['header'] as String? ?? AppStrings.emptyString,
      notificationPic: json['notificationPic'] as String?,
      title: json['title'] as String? ?? AppStrings.emptyString,
      description: json['description'] as String? ?? AppStrings.emptyString,
      delayTime: json['delayTime'] as String? ?? AppStrings.emptyString,
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'header': instance.header,
      'notificationPic': instance.notificationPic,
      'title': instance.title,
      'description': instance.description,
      'delayTime': instance.delayTime,
      'isRead': instance.isRead,
    };
