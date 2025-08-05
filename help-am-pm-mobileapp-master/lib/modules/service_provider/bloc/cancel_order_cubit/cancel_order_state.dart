import 'dart:ui';

import '../../../../utils/app_colors.dart';

abstract class CancelOrderState {}

class CancelOrderInitialState extends CancelOrderState {}

class CancelOrderLoadingState extends CancelOrderState {}

class CancelOrderLoadedState extends CancelOrderState {
  final String message;
  final Color bgColor;

  CancelOrderLoadedState(this.message, {this.bgColor = AppColors.green});
}

class CancelOrderErrorState extends CancelOrderState {
  final String errorMessage;
  final Color bgColor;

  CancelOrderErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
