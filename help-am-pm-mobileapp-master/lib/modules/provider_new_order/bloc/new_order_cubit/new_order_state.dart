import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../model/api/new_order_list_model.dart';

abstract class NewOrderState {}

class NewOrderInitialState extends NewOrderState {}

class NewOrderLoadingState extends NewOrderState {}

class NewOrderLoadedState extends NewOrderState {
  final List<Quotes> list;
  NewOrderLoadedState(this.list);
}

class NewOrderErrorState extends NewOrderState {
  final String errorMessage;
  final Color bgColor;

  NewOrderErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
