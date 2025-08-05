import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class ScreenHeaderWidget extends StatelessWidget {
  final String headerString;

  const ScreenHeaderWidget({
    Key? key,
    this.headerString = AppStrings.emptyString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 26.sh, bottom: 21.sh, left: 19.sw, right: 19.sw),
      child: Text(
        headerString,
        style: AppTextStyles.defaultTextStyle.copyWith(
          fontSize: 24.fs,
          fontWeight: FontWeight.w700,
          color: AppColors.mediumBlackColor,
        ),
      ),
    );
  }
}
