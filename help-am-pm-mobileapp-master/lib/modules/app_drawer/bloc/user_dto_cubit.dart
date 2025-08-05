import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_strings.dart';

import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../utils/app_utils.dart';
import '../../login/model/login_model/auth_token_model.dart';
import 'user_dto_state.dart';

class UserDtoCubit extends Cubit<UserDtoState> {
  UserDtoCubit() : super(UserDtoInitialState());

  SharedPreferenceHelper preference = SharedPreferenceHelper();

  Future<void> getUserData() async {
    emit(UserDtoLoadingState());
    String str =
        preference.getStringValue(SharedPreferenceConstants.userDetailsDto);

    if (!isEmpty(str)) {
      UserDetailsDto? updatedUserDetailsDto = await getRecord();
      if (updatedUserDetailsDto != null) {
        emit(UserDtoLoadedState(updatedUserDetailsDto));
      } else {
        emit(UserDtoErrorState(AppStrings.somethingWentWrong,
            bgColor: AppColors.red));
      }
    } else {
      emit(UserDtoErrorState(AppStrings.somethingWentWrong,
          bgColor: AppColors.red));
    }
  }

  Future<void> setUserData(UserDetailsDto updatedUserDetailsDto) async {
    await preference.setUserDetailsDto(updatedUserDetailsDto);

    UserDetailsDto? userDetailsDto = await getRecord();
    if (userDetailsDto != null) {
      emit(UserDtoLoadedState(updatedUserDetailsDto));
    } else {
      emit(UserDtoErrorState(AppStrings.somethingWentWrong,
          bgColor: AppColors.red));
    }
  }

  Future<UserDetailsDto?> getRecord() async {
    UserDetailsDto? updatedUserDetailsDto =
        await preference.getUserDetailsDto();
    return updatedUserDetailsDto;
  }
}
