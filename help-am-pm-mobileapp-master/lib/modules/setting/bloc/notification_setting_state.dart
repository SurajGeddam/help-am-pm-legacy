import 'dart:ui';

import '../../../../utils/app_colors.dart';

abstract class NotificationSettingState {}

class NotificationSettingInitialState extends NotificationSettingState {}

class NotificationSettingLoadingState extends NotificationSettingState {}

class NotificationSettingLoadedState extends NotificationSettingState {
  final String message;
  final Color bgColor;
  final String key;

  NotificationSettingLoadedState(this.key, this.message,
      {this.bgColor = AppColors.green});
}

class NotificationSettingErrorState extends NotificationSettingState {
  final String errorMessage;
  final Color bgColor;

  NotificationSettingErrorState(this.errorMessage,
      {this.bgColor = AppColors.black});
}
