import 'package:flutter/material.dart';
import 'package:helpampm/modules/provider_home/ui/provider_home_screen.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../customer_home/ui/customer_home_screen.dart';

class ThanksFeedbackScreen extends StatelessWidget {
  static const String routeName = "/ThanksFeedbackScreen";

  const ThanksFeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.feedback,
      isBackShow: false,
      child: Container(
        padding: EdgeInsets.only(left: 20.sw, right: 20.sw),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.thanksForYourValuableFeedback,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 32.fs,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.sh, left: 20.sw, right: 20.sw),
              child: BottomButtonWidget(
                  buttonTitle: AppStrings.backToHome,
                  buttonBGColor: AppColors.black,
                  onPressed: () => AppUtils.getIsRoleCustomer()
                      ? Navigator.of(context).pushNamedAndRemoveUntil(
                          CustomerHomeScreen.routeName,
                          (Route<dynamic> route) => true)
                      : Navigator.of(context).pushNamedAndRemoveUntil(
                          ProviderHomeScreen.routeName,
                          (Route<dynamic> route) => false)),
            )
          ],
        ),
      ),
    );
  }
}
