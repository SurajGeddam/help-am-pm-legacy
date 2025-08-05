import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../contact_us/ui/contact_us_screen.dart';
import 'faq_screen.dart';
import 'widgets/help_second_widget.dart';

class HelpScreen extends StatelessWidget {
  static const String routeName = "/HelpScreen";

  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.helpNSupport,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Todo: for next alteration
          /*const HelpFirstWidget(),
          SizedBox(height: 26.sh),*/
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.sh),
            child: Divider(
              height: 1.sh,
              thickness: 1.sh,
              color: AppColors.dividerColor,
            ),
          ),
          SizedBox(height: 8.sh),
          const ContactUsScreen(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, FaqScreen.routeName),
            child: faqsWidget(),
          ),
          const HelpSecondWidget(),
        ],
      ),
    );
  }

  Widget faqsWidget() {
    return Container(
      height: 60.sh,
      padding: EdgeInsets.symmetric(horizontal: 20.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            AppStrings.faqs,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SvgPicture.asset(
            AppAssets.backIconSvg,
            height: 12.sh,
            fit: BoxFit.contain,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}
