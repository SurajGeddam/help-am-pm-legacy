import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:helpampm/modules/options/ui/options_screen.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class DoNotHaveAnAccountTextWidget extends StatelessWidget {
  const DoNotHaveAnAccountTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 30.sh, bottom: 40.sh),
        child: RichText(
          text: TextSpan(
            text: AppStrings.doNotHaveAnAccount,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 12.fs,
              fontWeight: FontWeight.w300,
              color: AppColors.appMediumGrey,
            ),
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Navigator.pushNamed(context, OptionsScreen.routeName),
                text: AppStrings.signUp,
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
