import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/login/ui/create_new_password_screen.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/bottom_container_widget.dart';
import '../../../core_components/common_widgets/text_field_with_bg_widget.dart';
import '../../../core_components/common_widgets/top_yellow_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_styles.dart';
import '../bloc/enter_otp_bloc/enter_otp_bloc.dart';
import '../bloc/enter_otp_bloc/enter_otp_event.dart';
import '../bloc/enter_otp_bloc/enter_otp_state.dart';

class EnterOTPScreen extends StatefulWidget {
  static const String routeName = "/EnterOTPScreen";

  final String userId;
  final String systemOtp;

  const EnterOTPScreen({
    Key? key,
    required this.userId,
    required this.systemOtp,
  }) : super(key: key);

  @override
  State<EnterOTPScreen> createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTPScreen> {
  late EnterOtpBloc enterOtpBloc;
  bool isLoading = false;
  String systemOtp = AppStrings.emptyString;

  @override
  initState() {
    systemOtp = widget.systemOtp;
    enterOtpBloc = EnterOtpBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        scaffoldBgColor: AppColors.appYellow,
        appBarBgColor: AppColors.appYellow,
        isDividerShow: false,
        child: BlocListener<EnterOtpBloc, EnterOtpState>(
          bloc: enterOtpBloc,
          listener: (ctx, state) {
            if (state is EnterOtpLoadingState) {
              setState(() => isLoading = true);
            } else if (state is ResendOtpCompleteState) {
              systemOtp = state.systemOtp;
            } else if (state is EnterOtpValidState) {
              enterOtpBloc.add(EnterOtpSubmittedEvent());
            } else if (state is EnterOtpErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            } else if (state is EnterOtpCompleteState) {
              navigateTo(context, widget.userId, systemOtp);
            }
          },
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              const TopYellowWidget(title: AppStrings.enterOTP),
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
                            hintText: AppStrings.otp,
                            textController: otpController,
                          ),
                          SizedBox(height: 6.sh),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                AppStrings.haveNotReceivedAnOTP,
                                textAlign: TextAlign.left,
                                style: AppTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 10.fs,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.appDarkGrey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => enterOtpBloc
                                    .add(ReSendOtpEvent(userId: widget.userId)),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  height: 25.sh,
                                  padding: EdgeInsets.only(top: 12.sh),
                                  child: Text(
                                    AppStrings.resend,
                                    textAlign: TextAlign.right,
                                    style:
                                        AppTextStyles.defaultTextStyle.copyWith(
                                      fontSize: 10.fs,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.hyperLinkBlue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 61.sh),
                          BottomButtonWidget(
                            buttonTitle: AppStrings.verify,
                            buttonBGColor: AppColors.black,
                            onPressed: () {
                              enterOtpBloc.add(EnterOtpValidationEvent(
                                  userId: widget.userId,
                                  otp: otpController.text,
                                  systemOtp: systemOtp));
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
    return Navigator.pushNamed(context, CreateNewPasswordScreen.routeName,
        arguments: {"userId": userId, "otp": systemOtp});
  }
}
