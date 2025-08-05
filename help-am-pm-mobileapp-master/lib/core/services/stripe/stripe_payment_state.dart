import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../../modules/payment/model/payment_status_model.dart';

abstract class StripePaymentState {}

class StripeInitialState extends StripePaymentState {}

class StripeLoadingState extends StripePaymentState {}

class StripeLoadedState extends StripePaymentState {
  final PaymentStatusModel? paymentStatusModel;
  final Color bgColor;

  StripeLoadedState(this.paymentStatusModel, {this.bgColor = AppColors.green});
}

class StripeErrorState extends StripePaymentState {
  final String errorMessage;
  final Color bgColor;

  StripeErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
