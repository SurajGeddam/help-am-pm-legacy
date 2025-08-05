import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

abstract class ScheduleOrderState {}

class ScheduleOrderInitialState extends ScheduleOrderState {}

class ScheduleOrderLoadingState extends ScheduleOrderState {}

class ScheduleOrderLoadedState extends ScheduleOrderState {
  final List<Quotes> list;
  ScheduleOrderLoadedState(this.list);
}

class ScheduleOrderErrorState extends ScheduleOrderState {
  final String errorMessage;
  final Color bgColor;

  ScheduleOrderErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
