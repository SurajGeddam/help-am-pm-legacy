import 'dart:ui';

import '../../../../utils/app_colors.dart';

abstract class FeedbackState {}

class FeedbackInitialState extends FeedbackState {}

class FeedbackLoadingState extends FeedbackState {}

class FeedbackLoadedState extends FeedbackState {
  final String message;
  final Color bgColor;

  FeedbackLoadedState(this.message, {this.bgColor = AppColors.green});
}

class FeedbackErrorState extends FeedbackState {
  final String errorMessage;
  final Color bgColor;

  FeedbackErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
