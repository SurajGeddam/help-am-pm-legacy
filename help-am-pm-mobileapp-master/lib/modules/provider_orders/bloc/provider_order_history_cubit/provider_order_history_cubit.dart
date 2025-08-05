import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/provider_new_order/model/api/new_order_list_model.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import 'provider_order_history_state.dart';

class ProviderOrderHistoryCubit extends Cubit<ProviderOrderHistoryState> {
  ProviderOrderHistoryCubit() : super(ProviderOrderHistoryInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchProviderOrderHistory() async {
    emit(ProviderOrderHistoryLoadingState());

    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<List<Quotes>> response = AppUtils.getIsRoleCustomer()
        ? await appRepositoryValidation.getCustomerOrderHistory(id: uniqueId)
        : await appRepositoryValidation.getProviderOrderHistory(id: uniqueId);
    if (response.status == ApiResponseStatus.completed) {
      List<Quotes>? list = response.data;
      if (list != null) {
        emit(ProviderOrderHistoryLoadedState(list));
      } else {
        emit(ProviderOrderHistoryErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
    } else {
      emit(ProviderOrderHistoryErrorState(response.messageKey));
    }
  }
}
