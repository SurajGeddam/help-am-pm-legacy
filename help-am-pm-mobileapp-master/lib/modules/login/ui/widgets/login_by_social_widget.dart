import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_assets.dart';
import '../../../../core_components/common_widgets/soical_button_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_utils.dart';

class LoginBySocialWidget extends StatelessWidget {
  const LoginBySocialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sw),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SocialButtonWidget(
            buttonTitle: AppStrings.logInWithGmail,
            buttonBGColor: AppColors.white,
            imageOnButton: AppAssets.gmailIcon,
            onPressed: () => AppUtils.debugPrint("Tap on gmail button"),
          ),
          SizedBox(height: 21.sh),
          SocialButtonWidget(
            buttonTitle: AppStrings.logInWithFacebook,
            buttonBGColor: AppColors.white,
            imageOnButton: AppAssets.facebookIcon,
            onPressed: () => AppUtils.debugPrint("Tap on facebook button"),
          ),
        ],
      ),
    );
  }
}
