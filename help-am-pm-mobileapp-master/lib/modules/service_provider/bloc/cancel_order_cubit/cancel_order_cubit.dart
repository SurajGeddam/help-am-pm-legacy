import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';
import 'package:helpampm/utils/app_colors.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_strings.dart';
import 'cancel_order_state.dart';

class CancelOrderCubit extends Cubit<CancelOrderState> {
  CancelOrderCubit() : super(CancelOrderInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void cancelOrder({required String quoteUniqueId}) async {
    emit(CancelOrderLoadingState());

    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.cancelQuote(quoteUniqueId: quoteUniqueId);
    if (response.status == ApiResponseStatus.completed) {
      MessageStatusModel? messageStatusModel = response.data;
      if (messageStatusModel != null) {
        emit(CancelOrderLoadedState(
            messageStatusModel.message ?? AppStrings.orderCancelled));
        return;
      } else {
        emit(
            CancelOrderErrorState(response.messageKey, bgColor: AppColors.red));
        return;
      }
    } else {
      emit(CancelOrderErrorState(response.messageKey));
    }
  }
}
