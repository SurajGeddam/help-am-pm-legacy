import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../model/contact_us_model.dart';

abstract class ContactUsState {}

class ContactUsLoadingState extends ContactUsState {}

class ContactUsLoadedState extends ContactUsState {
  final List<ContactUsModel> contactUsModelList;

  ContactUsLoadedState(this.contactUsModelList);
}

class ContactUsErrorState extends ContactUsState {
  final String errorMessage;
  final Color bgColor;

  ContactUsErrorState(this.errorMessage, {this.bgColor = AppColors.red});
}
