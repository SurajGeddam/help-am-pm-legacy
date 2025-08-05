import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../model/category_model/api/category_model.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> list;
  CategoryLoadedState(this.list);
}

class CategoryErrorState extends CategoryState {
  final String errorMessage;
  final Color bgColor;

  CategoryErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
