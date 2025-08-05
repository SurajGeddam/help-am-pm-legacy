import '../../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class QuotesState {}

class QuotesInitialState extends QuotesState {}

class QuotesLoadingState extends QuotesState {}

class QuotesLoadedState extends QuotesState {
  final Quotes quotes;

  QuotesLoadedState({required this.quotes});
}

class QuotesErrorState extends QuotesState {
  final String errorMessage;
  final Color bgColor;

  QuotesErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
