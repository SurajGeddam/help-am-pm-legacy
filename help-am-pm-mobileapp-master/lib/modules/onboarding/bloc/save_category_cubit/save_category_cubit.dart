import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';
import 'package:helpampm/core/services/shared_preferences/shared_preference_helper.dart';
import 'package:helpampm/core_components/common_models/message_status_model.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../utils/app_strings.dart';
import '../../model/category_model/api/category_model.dart';
import 'save_category_state.dart';

class SaveCategoryCubit extends Cubit<SaveCategoryState> {
  SaveCategoryCubit() : super(SaveCategoryLoadingState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void saveSelectedCategory(CategoryModel obj) async {
    emit(SaveCategoryLoadingState());
    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    if (obj.timeslots!.isEmpty) {
      emit(SaveCategoryErrorState(AppStrings.pleaseSelectAtLeastOneTimeSlot));
      return;
    }

    ApiResponse<MessageStatusModel> response = await appRepositoryValidation
        .saveSelectedCategory(obj: obj, id: providerId);
    if (response.status == ApiResponseStatus.completed) {
      String categoryLetter = obj.name ?? AppStrings.emptyString;
      SharedPreferenceHelper().setStringValue(
          SharedPreferenceConstants.providerCategory,
          categoryLetter.split('').first);
      emit(SaveCategoryLoadedState(
          response.data?.message ?? AppStrings.savedSuccessfully));
    } else {
      emit(SaveCategoryErrorState(response.messageKey));
    }
  }
}
