import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class SelectionYellowCardWidget extends StatelessWidget {
  final String displayPrice;

  const SelectionYellowCardWidget({
    Key? key,
    required this.displayPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 36.sh, bottom: 48.sh),
      height: 120.sh,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appOrange,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.serviceCallCharges,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 18.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          SizedBox(height: 12.sh),
          Text(
            displayPrice,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 30.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
