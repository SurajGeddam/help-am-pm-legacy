import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class TopWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const TopWidget({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      color: AppColors.transparent,
      padding: EdgeInsets.only(top: 10.sh, left: 20.sw, right: 20.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            AppStrings.logo.toUpperCase(),
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 24.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            textAlign: TextAlign.left,
          ),
          InkWell(
            onTap: onPressed,
            child: Text(
              AppStrings.skip,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
