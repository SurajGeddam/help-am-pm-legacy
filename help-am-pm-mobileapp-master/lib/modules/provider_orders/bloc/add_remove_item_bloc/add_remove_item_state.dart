import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../model/item_details_model.dart';

abstract class AddRemoveItemState {}

class AddRemoveItemInitialState extends AddRemoveItemState {}

class AddRemoveItemLoadingState extends AddRemoveItemState {}

class AddRemoveItemValidState extends AddRemoveItemState {}

class AddRemoveItemCompleteState extends AddRemoveItemState {
  ItemDetails itemDetails;

  AddRemoveItemCompleteState(this.itemDetails);
}

class AddRemoveItemErrorState extends AddRemoveItemState {
  final String errorMessage;
  final Color bgColor;

  AddRemoveItemErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
