import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../login_screen.dart';

class AlreadyHaveAcTextWidget extends StatelessWidget {
  const AlreadyHaveAcTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 30.sh, bottom: 40.sh),
        child: RichText(
          text: TextSpan(
            text: AppStrings.alreadyHaveAnAccount,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 12.fs,
              fontWeight: FontWeight.w300,
              color: AppColors.appMediumGrey,
            ),
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.routeName, (Route<dynamic> route) => false),
                text: AppStrings.logIn,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 12.fs,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
