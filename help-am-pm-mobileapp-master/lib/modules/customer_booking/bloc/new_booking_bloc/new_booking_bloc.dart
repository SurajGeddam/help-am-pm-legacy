import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import 'new_booking_event.dart';
import 'new_booking_state.dart';

class NewBookingBloc extends Bloc<NewBookingEvent, NewBookingState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  NewBookingBloc() : super(NewBookingInitialState()) {
    on<NewBookingValidationEvent>((event, emit) {
      if (event.textController.isEmpty) {
        emit(NewBookingErrorState(AppStrings.pleaseEnterTheJobDescription));
      } else if (event.timeslots == null) {
        emit(NewBookingErrorState(AppStrings.pleaseSelectASlot));
      } else {
        emit(NewBookingValidState());
      }
    });

    on<NewBookingSubmittedEvent>((event, emit) async {
      emit(NewBookingLoadingState());

      ApiResponse<MessageStatusModel> response = await appRepositoryValidation
          .newBookingRequest(reqBody: event.sendObj);
      if (response.status == ApiResponseStatus.completed) {
        emit(NewBookingCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(NewBookingErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
