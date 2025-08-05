import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_utils.dart';
import '../../model/login_model/auth_token_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AppRepository appRepository = getIt<AppRepository>();

  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();

  LoginBloc() : super(LoginInitialState()) {
    on<LoginValidationEvent>((event, emit) {
      if (event.emailValue.isEmpty) {
        emit(LoginErrorState("Please enter the email Id"));
      } else if (event.passwordValue.isEmpty) {
        emit(LoginErrorState("Please enter the password"));
      } else if (EmailValidator.validate(event.emailValue) == false) {
        emit(LoginErrorState("Please enter a valid email address",
            bgColor: AppColors.red));
      } else {
        emit(LoginValidState());
      }
    });

    on<LoginSubmittedEvent>((event, emit) async {
      emit(LoginLoadingState());
      ApiResponse<AuthTokenModel> response = await appRepository.authToken(
        userName: event.emailValue.trim(),
        password: event.passwordValue.trim(),
      );

      if (response.status == ApiResponseStatus.completed) {
        AuthTokenModel? authTokenModel = response.data;
        if (authTokenModel != null) {
          setDataInSharedPreference(authTokenModel);
          emit(LoginCompleteState());
        } else {
          emit(LoginErrorState(response.messageKey, bgColor: AppColors.red));
        }
      } else {
        emit(LoginErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }

  Future<bool> refreshToken() async {
    SharedPreferenceHelper preference = SharedPreferenceHelper();
    String? token;
    String? expiryDate;

    String str =
        preference.getStringValue(SharedPreferenceConstants.refreshTokenObj);

    if (!isEmpty(str)) {
      await preference.getRefreshTokenObj().then((value) {
        token = value?.token;
        expiryDate = value?.expiryDate;
      });
    } else {
      return false;
    }

    ApiResponse<AuthTokenModel> response = await appRepository.refreshToken(
      token: token ?? AppStrings.emptyString,
      expiryDate: expiryDate ?? AppStrings.emptyString,
      username: sharedPreferenceHelper
          .getStringValue(SharedPreferenceConstants.userName),
    );
    if (response.status == ApiResponseStatus.completed) {
      AuthTokenModel? authTokenModel = response.data;
      if (authTokenModel != null) {
        setDataInSharedPreference(authTokenModel);
        return true;
      }
    }
    return false;
  }

  void setDataInSharedPreference(AuthTokenModel authTokenModel) {
    sharedPreferenceHelper.setIsUserLogin(true);
    sharedPreferenceHelper.setStringValue(
        SharedPreferenceConstants.token, authTokenModel.token);
    sharedPreferenceHelper.setStringValue(
        SharedPreferenceConstants.expiryDate, authTokenModel.expiryDate);

    if (authTokenModel.role != null &&
        authTokenModel.role?.toUpperCase() ==
            AppConstants.customer.toUpperCase()) {
      sharedPreferenceHelper.setIsRoleCustomer(true);
    } else {
      sharedPreferenceHelper.setIsRoleCustomer(false);
      if (authTokenModel.categories != null) {
        sharedPreferenceHelper.setStringValue(
            SharedPreferenceConstants.providerCategory,
            authTokenModel.categories!.isNotEmpty
                ? authTokenModel.categories![0]
                : AppStrings.emptyString);
      }
    }

    sharedPreferenceHelper.setStringValue(
        SharedPreferenceConstants.role, authTokenModel.role);
    sharedPreferenceHelper.setStringValue(
        SharedPreferenceConstants.userName, authTokenModel.username);

    sharedPreferenceHelper.setStringValue(
        SharedPreferenceConstants.completedPage, authTokenModel.completedPage);
    sharedPreferenceHelper.setBoolValue(
        SharedPreferenceConstants.accountSetupCompleted,
        authTokenModel.accountSetupCompleted);

    if (authTokenModel.userDetailsDto != null) {
      sharedPreferenceHelper.setUserDetailsDto(authTokenModel.userDetailsDto);

      sharedPreferenceHelper.setStringValue(SharedPreferenceConstants.uniqueId,
          getUniqueId(authTokenModel.role, authTokenModel.userDetailsDto));
    }

    if (authTokenModel.refreshToken != null) {
      sharedPreferenceHelper.setRefreshTokenObj(authTokenModel.refreshToken);
    }

    final userDetailsDto = authTokenModel.userDetailsDto;
    if (userDetailsDto != null) {
      Image.memory(base64Decode(userDetailsDto.profileBytes));
    }

    /*Future<UserDetailsDto> usd = sharedPreferenceHelper.getRefreshTokenObj();
    usd.then((value) {
      AppUtils.debugPrint("username ==> ${value.username}");
    });*/
  }

  String getUniqueId(String? role, UserDetailsDto? userDetailsDto) {
    String uniqueId = AppStrings.emptyString;
    switch (role) {
      case AppConstants.provider:
        return userDetailsDto?.providerUniqueId ?? uniqueId;
      case AppConstants.customer:
        return userDetailsDto?.customerUniqueId ?? uniqueId;

      default:
        return uniqueId;
    }
  }
}
