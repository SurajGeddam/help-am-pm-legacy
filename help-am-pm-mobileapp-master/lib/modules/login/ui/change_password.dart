import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core_components/common_widgets/app_scaffold_widget.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/bottom_container_widget.dart';
import '../../../core_components/common_widgets/text_field_with_bg_widget.dart';
import '../../../core_components/common_widgets/top_yellow_widget.dart';
import '../../../core_components/i18n/app_localisation_strings.dart';
import '../../../core_components/i18n/localization_facade.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../bloc/change_password/change_password_bloc.dart';
import '../bloc/change_password/change_password_event.dart';
import '../bloc/change_password/change_password_state.dart';
import '../model/login_model/auth_token_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = "/ChangePasswordScreen";

  const ChangePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  late String userId;
  late ChangePasswordBloc changePasswordBloc;
  SharedPreferenceHelper preference = SharedPreferenceHelper();
  UserDetailsDto? userDetailsDto;
  bool isLoading = false;

  @override
  initState() {
    changePasswordBloc = ChangePasswordBloc();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationFacade localization =
        BlocProvider.of<LocalizationFacade>(context, listen: false);

    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController reEnterPasswordController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        scaffoldBgColor: AppColors.appYellow,
        appBarBgColor: AppColors.appYellow,
        isDividerShow: false,
        child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
          bloc: changePasswordBloc,
          listener: (ctx, state) {
            if (state is ChangePasswordLoadingState) {
              setState(() => isLoading = true);
            } else if (state is ChangePasswordValidState) {
              changePasswordBloc.add(ChangePasswordSubmittedEvent(
                userId: userId,
                oldPassword: oldPasswordController.text,
                password: newPasswordController.text,
              ));
            } else if (state is ChangePasswordErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            } else if (state is ChangePasswordCompleteState) {
              navigateTo(context);
            }
          },
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              TopYellowWidget(
                  title: localization.safeTranslate(
                      context, AppLocalisationStrings.createNewPassword)),
              BottomContainerWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 46.sh),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.sw),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldWithBgWidget(
                            textFieldIcon: AppAssets.passwordSvgIcon,
                            hintText: AppStrings.currentPassword,
                            textController: oldPasswordController,
                            isObscureText: true,
                          ),
                          SizedBox(height: 17.sh),
                          TextFieldWithBgWidget(
                            textFieldIcon: AppAssets.passwordSvgIcon,
                            hintText: AppStrings.enterPassword,
                            textController: newPasswordController,
                            isObscureText: true,
                          ),
                          SizedBox(height: 17.sh),
                          TextFieldWithBgWidget(
                            textFieldIcon: AppAssets.passwordSvgIcon,
                            hintText: AppStrings.reEnterPassword,
                            textController: reEnterPasswordController,
                            isObscureText: true,
                          ),
                          SizedBox(height: 66.sh),
                          BottomButtonWidget(
                            buttonTitle: localization.safeTranslate(
                                context, AppLocalisationStrings.submit),
                            buttonBGColor: AppColors.black,
                            onPressed: () {
                              changePasswordBloc.add(
                                  ChangePasswordValidationEvent(
                                      oldPassword: oldPasswordController.text,
                                      password: newPasswordController.text,
                                      reEnterpassword:
                                          reEnterPasswordController.text));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateTo(BuildContext context) {
    return Navigator.of(context).pop();
  }

  Future<void> getData() async {
    String str =
        preference.getStringValue(SharedPreferenceConstants.userDetailsDto);

    if (!isEmpty(str)) {
      userDetailsDto = await preference.getUserDetailsDto();
      userId = userDetailsDto!.email;
    }
  }
}
