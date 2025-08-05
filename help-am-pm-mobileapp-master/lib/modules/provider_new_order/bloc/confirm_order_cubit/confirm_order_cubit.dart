import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import 'confirm_order_state.dart';

class ConfirmOrderCubit extends Cubit<ConfirmOrderState> {
  ConfirmOrderCubit() : super(ConfirmOrderInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void orderConfirm(String quoteUniqueId, String selectedDelay) async {
    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    emit(ConfirmOrderLoadingState());
    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.orderConfirm(
      quoteUniqueId: quoteUniqueId,
      providerUniqueId: providerId,
      selectedDelay: selectedDelay,
    );
    if (response.status == ApiResponseStatus.completed) {
      emit(ConfirmOrderLoadedState(response.data));
    } else {
      emit(ConfirmOrderErrorState(response.messageKey));
    }
  }
}
