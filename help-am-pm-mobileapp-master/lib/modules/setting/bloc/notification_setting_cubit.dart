import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network/api_response.dart';
import '../../../core/services/repositories/app_repository_validation.dart';
import '../../../core/services/service_locator.dart';
import '../../../core_components/common_models/message_status_model.dart';
import 'notification_setting_state.dart';

class NotificationSettingBloc extends Cubit<NotificationSettingState> {
  NotificationSettingBloc() : super(NotificationSettingInitialState());
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void notificationSetting({
    required String type,
    required bool enabled,
  }) async {
    emit(NotificationSettingLoadingState());

    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.notificationSetting(
      type: type,
      enabled: enabled,
    );
    if (response.status == ApiResponseStatus.completed) {
      emit(NotificationSettingLoadedState(type, response.data?.message ?? ""));
    } else {
      emit(NotificationSettingErrorState(response.messageKey));
    }
  }
}
