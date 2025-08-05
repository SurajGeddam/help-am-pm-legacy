import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import 'ongoing_order_state.dart';

class OngoingOrderCubit extends Cubit<OngoingOrderState> with ChangeNotifier {
  OngoingOrderCubit() : super(OngoingOrderInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchOngoingOrder() async {
    emit(OngoingOrderLoadingState());

    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<List<Quotes>> response = AppUtils.getIsRoleCustomer()
        ? await appRepositoryValidation.getCustomerOngoingOrder(id: uniqueId)
        : await appRepositoryValidation.getProviderOngoingOrder(id: uniqueId);
    if (response.status == ApiResponseStatus.completed) {
      List<Quotes>? list = response.data;
      if (list != null) {
        emit(OngoingOrderLoadedState(list));
      } else {
        emit(OngoingOrderErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
      notifyListeners();
    } else {
      emit(OngoingOrderErrorState(response.messageKey));
    }
  }
}
