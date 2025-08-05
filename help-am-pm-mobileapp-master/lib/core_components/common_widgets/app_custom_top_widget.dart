import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_utils.dart';

class AppCustomTopWidget extends StatelessWidget {
  final bool isProviderReached;
  final bool isFromTrackingScreen;

  const AppCustomTopWidget({
    Key? key,
    this.isProviderReached = false,
    this.isFromTrackingScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            AppAssets.backBtnInCircleIconSvg,
            height: 36.sh,
            width: 36.sw,
          ),
        ),
        Expanded(
          child: Text(
            isFromTrackingScreen
                ? AppStrings.emptyString
                : AppStrings.ongoingService,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        isFromTrackingScreen
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  AppAssets.crossBtnInCircleIconSvg,
                  height: 36.sh,
                  width: 36.sw,
                ),
              )
            : SizedBox(width: 36.sw),
      ],
    );
  }
}
