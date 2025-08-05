import 'dart:ui';

import '../../../../utils/app_colors.dart';

abstract class OrderStartState {}

class OrderStartInitialState extends OrderStartState {}

class OrderStartLoadingState extends OrderStartState {}

class OrderStartLoadedState extends OrderStartState {
  final String message;
  final Color bgColor;

  OrderStartLoadedState(this.message, {this.bgColor = AppColors.green});
}

class OrderStartErrorState extends OrderStartState {
  final String errorMessage;
  final Color bgColor;

  OrderStartErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
