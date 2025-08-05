import 'dart:ui';

import '../../../../utils/app_colors.dart';

abstract class OrderEndState {}

class OrderEndInitialState extends OrderEndState {}

class OrderEndLoadingState extends OrderEndState {}

class OrderEndLoadedState extends OrderEndState {
  final String message;
  final Color bgColor;

  OrderEndLoadedState(this.message, {this.bgColor = AppColors.green});
}

class OrderEndErrorState extends OrderEndState {
  final String errorMessage;
  final Color bgColor;

  OrderEndErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
