import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/help/bloc/faq_cubit/faq_state.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../utils/app_colors.dart';
import '../../model/faq_model.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchFaqResponse() async {
    emit(FaqLoadingState());
    ApiResponse<List<FaqModel>> response =
        await appRepositoryValidation.getFaqResponse();
    if (response.status == ApiResponseStatus.completed) {
      List<FaqModel>? faqModelList = response.data;
      if (faqModelList != null) {
        emit(FaqLoadedState(faqModelList));
      } else {
        emit(FaqErrorState(response.messageKey, bgColor: AppColors.red));
      }
    } else {
      emit(FaqErrorState(response.messageKey));
    }
  }
}
