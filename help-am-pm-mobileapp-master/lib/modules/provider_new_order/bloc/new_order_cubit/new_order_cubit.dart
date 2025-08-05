import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../model/api/new_order_list_model.dart';
import 'new_order_state.dart';

class NewOrderCubit extends Cubit<NewOrderState> with ChangeNotifier {
  NewOrderCubit() : super(NewOrderInitialState()) {
    fetchNewOrder();
  }

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchNewOrder() async {
    emit(NewOrderLoadingState());
    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<NewOrderListModel> response =
        await appRepositoryValidation.getNewOrder(id: providerId);
    if (response.status == ApiResponseStatus.completed) {
      NewOrderListModel? data = response.data;
      List<Quotes>? list = data?.quotes;
      if (list != null) {
        emit(NewOrderLoadedState(list));
      } else {
        emit(NewOrderErrorState(response.messageKey, bgColor: AppColors.red));
      }
      notifyListeners();
    } else {
      emit(NewOrderErrorState(response.messageKey));
    }
  }
}
