import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_strings.dart';
import 'order_end_state.dart';

class OrderEndCubit extends Cubit<OrderEndState> {
  OrderEndCubit() : super(OrderEndInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void orderEnd(String quoteUniqueId) async {
    emit(OrderEndLoadingState());

    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.orderEnd(
      quoteUniqueId: quoteUniqueId,
      providerUniqueId: providerId,
    );
    if (response.status == ApiResponseStatus.completed) {
      emit(OrderEndLoadedState(
          response.data?.message ?? AppStrings.savedSuccessfully));
    } else {
      emit(OrderEndErrorState(response.messageKey));
    }
  }
}
