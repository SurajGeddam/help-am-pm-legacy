import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/shared_preferences/shared_preference_helper.dart';
import 'package:helpampm/modules/login/ui/forgot_password_screen.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/bottom_container_widget.dart';
import '../../../core_components/common_widgets/text_field_with_bg_widget.dart';
import '../../../core_components/common_widgets/top_yellow_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_text_styles.dart';
import '../../splash/ui/app_navigation.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';
import 'widgets/dont_have_an_ac_text_widget.dart';
import 'widgets/tnc_message_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SharedPreferenceHelper preference = SharedPreferenceHelper();

  late LoginBloc loginBloc;
  bool isLoading = false;

  getFCMDeviceToken() async {
    /// Get device token and check if updated to server earlier
    await FirebaseMessaging.instance.getToken().then((value) {
      AppUtils.debugPrint("Firebase messaging device token generated: $value");
      if (value != null && value.isNotEmpty) {
        AppUtils.saveDeviceToken(value);
      } else {
        AppUtils.saveDeviceToken(AppStrings.emptyString);
      }
    });
  }

  @override
  initState() {
    loginBloc = LoginBloc();
    getFCMDeviceToken();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return exit(0); // Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppScaffoldWidget(
          scaffoldBgColor: AppColors.appYellow,
          appBarBgColor: AppColors.appYellow,
          isDividerShow: false,
          isBackShow: false,
          child: BlocListener<LoginBloc, LoginState>(
            bloc: loginBloc,
            listener: (ctx, state) {
              if (state is LoginLoadingState) {
                setState(() => isLoading = true);
              } else if (state is LoginValidState) {
                loginBloc.add(LoginSubmittedEvent(
                  emailValue: emailController.text,
                  passwordValue: passwordController.text,
                ));
              } else if (state is LoginErrorState) {
                setState(() => isLoading = false);
                AppUtils.showSnackBar(state.errorMessage,
                    bgColor: state.bgColor);
              } else if (state is LoginCompleteState) {
                navigateTo(context);
              }
            },
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                const TopYellowWidget(title: AppStrings.logIn),
                BottomContainerWidget(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 46.sh),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.sw),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            TextFieldWithBgWidget(
                              textFieldIcon: AppAssets.emailSvgIcon,
                              hintText: AppStrings.emailId,
                              textController: emailController,
                              textFormFieldType: TextFormFieldType.email,
                            ),
                            SizedBox(height: 16.sh),
                            TextFieldWithBgWidget(
                              textFieldIcon: AppAssets.passwordSvgIcon,
                              hintText: AppStrings.password,
                              textController: passwordController,
                              isObscureText: true,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, ForgotPasswordScreen.routeName),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 6.sh, bottom: 36.sh),
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    textAlign: TextAlign.right,
                                    style:
                                        AppTextStyles.defaultTextStyle.copyWith(
                                      fontSize: 10.fs,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const TnCMessageWidget(),
                            SizedBox(height: 55.sh),
                            isLoading
                                ? const AppLoadingWidget()
                                : BottomButtonWidget(
                                    buttonTitle: AppStrings.logIn,
                                    buttonBGColor: AppColors.black,
                                    onPressed: () {
                                      loginBloc.add(LoginValidationEvent(
                                        emailValue: emailController.text,
                                        passwordValue: passwordController.text,
                                      ));
                                    },
                                  ),
                          ],
                        ),
                      ),
                      /*Padding(
                        padding: EdgeInsets.symmetric(vertical: 38.sh),
                        child: Divider(
                          height: 1.sh,
                          thickness: 1.sh,
                          color: AppColors.dividerColor,
                        ),
                      ),
                      const LoginBySocialWidget(),*/
                      const DoNotHaveAnAccountTextWidget(),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          "${AppStrings.version}: ${AppConstants.appVersion}",
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 12.fs,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  navigateTo(BuildContext context) {
    Future.delayed(const Duration(seconds: 1),
        () => AppNavigation.getPath(context, isFromLogin: true));
    return;
  }
}
