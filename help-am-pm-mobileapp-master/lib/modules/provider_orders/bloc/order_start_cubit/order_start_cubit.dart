import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_strings.dart';
import 'order_start_state.dart';

class OrderStartCubit extends Cubit<OrderStartState> {
  OrderStartCubit() : super(OrderStartInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void orderStart(String quoteUniqueId) async {
    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    emit(OrderStartLoadingState());
    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.orderStart(
      providerUniqueId: uniqueId,
      quoteUniqueId: quoteUniqueId,
    );
    if (response.status == ApiResponseStatus.completed) {
      emit(OrderStartLoadedState(
          response.data?.message ?? AppStrings.savedSuccessfully));
    } else {
      emit(OrderStartErrorState(response.messageKey));
    }
  }
}
