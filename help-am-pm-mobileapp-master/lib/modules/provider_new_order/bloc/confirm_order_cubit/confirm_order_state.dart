import 'dart:ui';

import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';

abstract class ConfirmOrderState {}

class ConfirmOrderInitialState extends ConfirmOrderState {}

class ConfirmOrderLoadingState extends ConfirmOrderState {}

class ConfirmOrderLoadedState extends ConfirmOrderState {
  final MessageStatusModel? messageStatusModel;
  final Color bgColor;

  ConfirmOrderLoadedState(this.messageStatusModel,
      {this.bgColor = AppColors.green});
}

class ConfirmOrderErrorState extends ConfirmOrderState {
  final String errorMessage;
  final Color bgColor;

  ConfirmOrderErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
