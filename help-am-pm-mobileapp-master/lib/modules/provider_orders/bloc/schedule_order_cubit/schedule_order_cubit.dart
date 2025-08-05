import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import 'schedule_order_state.dart';

class ScheduleOrderCubit extends Cubit<ScheduleOrderState> with ChangeNotifier {
  ScheduleOrderCubit() : super(ScheduleOrderInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchScheduleOrder() async {
    emit(ScheduleOrderLoadingState());

    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<List<Quotes>> response = AppUtils.getIsRoleCustomer()
        ? await appRepositoryValidation.getCustomerScheduleOrders(id: uniqueId)
        : await appRepositoryValidation.getScheduleOrders(id: uniqueId);

    if (response.status == ApiResponseStatus.completed) {
      List<Quotes>? list = response.data;
      if (list != null) {
        emit(ScheduleOrderLoadedState(list));
      } else {
        emit(ScheduleOrderErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
      notifyListeners();
    } else {
      emit(ScheduleOrderErrorState(response.messageKey));
    }
  }
}
