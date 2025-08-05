import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_utils.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AppRepository appRepository = getIt<AppRepository>();

  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterValidationEvent>((event, emit) {
      if (event.selectUserIsCustomer && event.firstName.isEmpty) {
        emit(RegisterErrorState("Please enter the first name"));
      } else if (event.selectUserIsCustomer && event.lastName.isEmpty) {
        emit(RegisterErrorState("Please enter the last name"));
      } else if (event.selectUserIsCustomer && event.phoneNumber.isEmpty) {
        emit(RegisterErrorState("Please enter the phone number"));
      } else if (event.emailValue.isEmpty) {
        emit(RegisterErrorState("Please enter the email Id"));
      } else if (event.passwordValue.isEmpty) {
        emit(RegisterErrorState("Please enter the password"));
      } else if (!AppUtils.validateStructure(event.passwordValue.trim())) {
        emit(RegisterErrorState(
            "Password should contain at least one upper case, one lower case, one digit, one special character and must be at least 8 characters in length"));
      } else if (event.confirmPasswordValue.isEmpty) {
        emit(RegisterErrorState("Please enter the confirm password"));
      } else if (event.passwordValue != event.confirmPasswordValue) {
        emit(
          RegisterErrorState("Password does not match", bgColor: AppColors.red),
        );
      } else if (event.isMandatoryProviderEmployee &&
          event.employerCode.isEmpty) {
        emit(RegisterErrorState("Please enter the employer code"));
      } else if (EmailValidator.validate(event.emailValue) == false) {
        emit(RegisterErrorState("Please enter a valid email address",
            bgColor: AppColors.red));
      } else {
        emit(RegisterValidState());
      }
    });

    on<RegisterSubmittedEvent>((event, emit) async {
      emit(RegisterLoadingState());
      ApiResponse<MessageStatusModel> response;

      if (event.selectUserIsCustomer) {
        response = await appRepository.addNewCustomer(
          firstName: event.firstName,
          lastName: event.lastName,
          phoneNumber: event.phoneNumber,
          emailId: event.emailValue,
          password: event.passwordValue,
          isActive: true,
        );
      } else {
        response = await appRepository.addNewProvider(
          emailId: event.emailValue,
          password: event.passwordValue,
          isIndividual: false,
        );
      }

      if (response.status == ApiResponseStatus.completed) {
        emit(RegisterCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(RegisterErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
