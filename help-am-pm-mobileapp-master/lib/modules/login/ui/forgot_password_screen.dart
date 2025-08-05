import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/login/bloc/forgot_password_block/forgot_password_bloc.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/bottom_container_widget.dart';
import '../../../core_components/common_widgets/text_field_with_bg_widget.dart';
import '../../../core_components/common_widgets/top_yellow_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../bloc/forgot_password_block/forgot_password_event.dart';
import '../bloc/forgot_password_block/forgot_password_state.dart';
import 'enter_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "/ForgotPasswordScreen";

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  late ForgotPasswordBloc forgotPasswordBloc;
  bool isLoading = false;

  @override
  initState() {
    forgotPasswordBloc = ForgotPasswordBloc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        scaffoldBgColor: AppColors.appYellow,
        appBarBgColor: AppColors.appYellow,
        isDividerShow: false,
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          bloc: forgotPasswordBloc,
          listener: (ctx, state) {
            if (state is ForgotPasswordLoadingState) {
              setState(() => isLoading = true);
            } else if (state is ForgotPasswordValidState) {
              forgotPasswordBloc.add(ForgotPasswordSubmittedEvent(
                emailValue: emailController.text,
              ));
            } else if (state is ForgotPasswordErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            } else if (state is ForgotPasswordCompleteState) {
              navigateTo(context, state.userId, state.systemOtp);
            }
          },
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              const TopYellowWidget(title: AppStrings.forgotPasswordWithSign),
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
                            textFieldIcon: AppAssets.emailSvgIcon,
                            hintText: AppStrings.emailId,
                            textController: emailController,
                            textFormFieldType: TextFormFieldType.email,
                          ),
                          SizedBox(height: 80.sh),
                          BottomButtonWidget(
                            buttonTitle: AppStrings.proceed,
                            buttonBGColor: AppColors.black,
                            onPressed: () {
                              forgotPasswordBloc
                                  .add(ForgotPasswordValidationEvent(
                                emailValue: emailController.text,
                              ));
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

  navigateTo(BuildContext context, String userId, String systemOtp) {
    return Navigator.pushNamed(context, EnterOTPScreen.routeName,
        arguments: {"userId": userId, "systemOtp": systemOtp});
  }
}
