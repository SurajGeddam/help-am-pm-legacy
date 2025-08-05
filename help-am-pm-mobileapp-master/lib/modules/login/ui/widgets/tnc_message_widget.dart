import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class TnCMessageWidget extends StatelessWidget {
  const TnCMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: AppStrings.tncMsgLoginScreen,
        style: AppTextStyles.defaultTextStyle.copyWith(
          color: AppColors.appLightGrey,
          fontSize: 12.fs,
          fontWeight: FontWeight.w400,
        ),
        children: <TextSpan>[
          TextSpan(
            text: AppStrings.termsAndConditions,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.appOrange,
              fontSize: 12.fs,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => AppUtils.launchDeepLinkURL(),
          ),
          TextSpan(
            text: AppStrings.and,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.appLightGrey,
              fontSize: 12.fs,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: AppStrings.privacyStatement,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.appOrange,
              fontSize: 12.fs,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => AppUtils.launchDeepLinkURL(),
          ),
        ],
      ),
    );
  }
}
