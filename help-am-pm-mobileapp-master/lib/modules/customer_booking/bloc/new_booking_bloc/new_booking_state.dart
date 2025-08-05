import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class NewBookingState {}

class NewBookingInitialState extends NewBookingState {}

class NewBookingLoadingState extends NewBookingState {}

class NewBookingValidState extends NewBookingState {}

class NewBookingCompleteState extends NewBookingState {
  final String message;
  final Color bgColor;

  NewBookingCompleteState(this.message, {this.bgColor = AppColors.green});
}

class NewBookingErrorState extends NewBookingState {
  final String errorMessage;
  final Color bgColor;

  NewBookingErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
