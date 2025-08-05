import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core/services/network/api_response.dart';
import '../../../core_components/common_models/key_value_model.dart';
import '../../../core_components/common_models/message_status_model.dart';
import '../../../utils/app_strings.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void submitFeedback({
    required double rating,
    required String feedback,
    required String givenBy,
    KeyValueModel? selectedComment,
  }) async {
    emit(FeedbackLoadingState());
    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.submitFeedback(
            givenTo: providerId,
            rating: rating.toInt(),
            feedback: feedback,
            givenBy: givenBy,
            selectedComment: selectedComment);

    if (response.status == ApiResponseStatus.completed) {
      emit(FeedbackLoadedState(
          response.data?.message ?? AppStrings.savedSuccessfully));
    } else {
      emit(FeedbackErrorState(response.messageKey));
    }
  }
}
