import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';
import 'package:helpampm/core_components/common_models/notification_model.dart';

import '../../../../../core/services/network/api_response.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../../utils/app_colors.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> with ChangeNotifier {
  NotificationCubit() : super(NotificationInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchNotifications() async {
    emit(NotificationLoadingState());
    String username = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.userName);

    ApiResponse<List<NotificationModel>> response =
        await appRepositoryValidation.getNotifications(username: username);

    if (response.status == ApiResponseStatus.completed) {
      List<NotificationModel>? list = response.data;
      if (list != null) {
        emit(NotificationLoadedState(list));
      } else {
        emit(NotificationErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
      notifyListeners();
    } else {
      emit(NotificationErrorState(response.messageKey));
    }
  }
}
