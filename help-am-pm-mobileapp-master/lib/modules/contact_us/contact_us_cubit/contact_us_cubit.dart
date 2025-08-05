import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../utils/app_colors.dart';
import '../model/contact_us_model.dart';
import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsLoadingState()) {
    fetchContactUsResponse();
  }

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchContactUsResponse() async {
    emit(ContactUsLoadingState());
    ApiResponse<List<ContactUsModel>> response =
        await appRepositoryValidation.getContactUsResponse();
    if (response.status == ApiResponseStatus.completed) {
      List<ContactUsModel>? contactUsModel = response.data;
      if (contactUsModel != null) {
        emit(ContactUsLoadedState(contactUsModel));
      } else {
        emit(ContactUsErrorState(response.messageKey, bgColor: AppColors.red));
      }
    } else {
      emit(ContactUsErrorState(response.messageKey));
    }
  }
}
