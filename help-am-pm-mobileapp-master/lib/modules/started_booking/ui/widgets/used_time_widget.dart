import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';

class UsedTimeWidget extends StatelessWidget {
  const UsedTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sh),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            AppAssets.yellowEllipseSvg,
            width: 260.sw,
            height: 176.sh,
            fit: BoxFit.fill,
          ),
          Container(
            height: 176.sh,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "00:00",
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 60.fs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  AppStrings.workingSession,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
