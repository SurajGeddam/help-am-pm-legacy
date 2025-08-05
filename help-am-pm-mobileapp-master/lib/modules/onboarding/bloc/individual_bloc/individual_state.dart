import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class IndividualState {}

class IndividualInitialState extends IndividualState {}

class IndividualLoadingState extends IndividualState {}

class IndividualValidState extends IndividualState {}

class IndividualCompleteState extends IndividualState {
  final String message;
  final Color bgColor;

  IndividualCompleteState(this.message, {this.bgColor = AppColors.green});
}

class IndividualErrorState extends IndividualState {
  final String errorMessage;
  final Color bgColor;

  IndividualErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
