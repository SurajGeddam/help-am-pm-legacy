import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';

class ChooseCategoryTextBoxWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ChooseCategoryTextBoxWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 44.sh,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.sw,
              color: AppColors.appThinGrey,
            ),
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.appLightMediumGrey,
              fontSize: 14.fs,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
