import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core_components/common_widgets/app_scaffold_widget.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/bottom_container_widget.dart';
import '../../../core_components/common_widgets/text_field_with_bg_widget.dart';
import '../../../core_components/common_widgets/top_yellow_widget.dart';
import '../../../core_components/i18n/app_localisation_strings.dart';
import '../../../core_components/i18n/localization_facade.dart';
import '../../../utils/app_colors.dart';
import '../bloc/create_password/create_password_bloc.dart';
import '../bloc/create_password/create_password_event.dart';
import '../bloc/create_password/create_password_state.dart';
import 'login_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  static const String routeName = "/CreateNewPasswordScreen";

  final String userId;
  final String otp;

  const CreateNewPasswordScreen({
    Key? key,
    required this.userId,
    required this.otp,
  }) : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPasswordScreen> {
  late CreatePasswordBloc createPasswordBloc;
  bool isLoading = false;

  @override
  initState() {
    createPasswordBloc = CreatePasswordBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationFacade localization =
        BlocProvider.of<LocalizationFacade>(context, listen: false);

    TextEditingController passwordController = TextEditingController();
    TextEditingController reEnterPasswordController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        scaffoldBgColor: AppColors.appYellow,
        appBarBgColor: AppColors.appYellow,
        isDividerShow: false,
        child: BlocListener<CreatePasswordBloc, CreatePasswordState>(
          bloc: createPasswordBloc,
          listener: (ctx, state) {
            if (state is CreatePasswordLoadingState) {
              setState(() => isLoading = true);
            } else if (state is CreatePasswordValidState) {
              createPasswordBloc.add(CreatePasswordSubmittedEvent(
                userId: widget.userId,
                otp: widget.otp,
                password: passwordController.text,
              ));
            } else if (state is CreatePasswordErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            } else if (state is CreatePasswordCompleteState) {
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
                            hintText: localization.safeTranslate(
                                context, AppLocalisationStrings.enterPassword),
                            textController: passwordController,
                            isObscureText: true,
                          ),
                          SizedBox(height: 17.sh),
                          TextFieldWithBgWidget(
                            textFieldIcon: AppAssets.passwordSvgIcon,
                            hintText: localization.safeTranslate(context,
                                AppLocalisationStrings.reEnterPassword),
                            textController: reEnterPasswordController,
                            isObscureText: true,
                          ),
                          SizedBox(height: 66.sh),
                          BottomButtonWidget(
                            buttonTitle: localization.safeTranslate(
                                context, AppLocalisationStrings.submit),
                            buttonBGColor: AppColors.black,
                            onPressed: () {
                              createPasswordBloc.add(
                                  CreatePasswordValidationEvent(
                                      userId: widget.userId,
                                      otp: widget.otp,
                                      password: passwordController.text,
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
    return Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName, (Route<dynamic> route) => false);
  }
}
