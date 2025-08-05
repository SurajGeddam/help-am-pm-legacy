import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

abstract class OngoingOrderState {}

class OngoingOrderInitialState extends OngoingOrderState {}

class OngoingOrderLoadingState extends OngoingOrderState {}

class OngoingOrderLoadedState extends OngoingOrderState {
  final List<Quotes> list;
  OngoingOrderLoadedState(this.list);
}

class OngoingOrderErrorState extends OngoingOrderState {
  final String errorMessage;
  final Color bgColor;

  OngoingOrderErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
