import 'dart:ui';

import '../../../../../core_components/common_models/notification_model.dart';
import '../../../../../utils/app_colors.dart';

abstract class NotificationState {}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final List<NotificationModel> list;
  NotificationLoadedState(this.list);
}

class NotificationErrorState extends NotificationState {
  final String errorMessage;
  final Color bgColor;

  NotificationErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
