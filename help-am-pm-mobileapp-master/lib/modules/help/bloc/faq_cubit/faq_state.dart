import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../model/faq_model.dart';

abstract class FaqState {}

class FaqInitialState extends FaqState {}

class FaqLoadingState extends FaqState {}

class FaqLoadedState extends FaqState {
  final List<FaqModel> faqModelList;
  FaqLoadedState(this.faqModelList);
}

class FaqErrorState extends FaqState {
  final String errorMessage;
  final Color bgColor;

  FaqErrorState(this.errorMessage, {this.bgColor = AppColors.red});
}
