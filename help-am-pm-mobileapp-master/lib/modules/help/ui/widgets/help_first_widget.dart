import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';

class HelpFirstWidget extends StatelessWidget {
  const HelpFirstWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 28.sh, left: 20, right: 20.sw),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.helpNSupport,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 20.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 14.sh),
          Text(
            AppStrings.helpNSupportMsg,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.textColorOnForm,
            ),
          ),
        ],
      ),
    );
  }
}
