import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class HeaderRowWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback? onPressed;

  const HeaderRowWidget({
    Key? key,
    required this.text1,
    this.text2 = AppStrings.emptyString,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            text1,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 20.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          (text2.isNotEmpty)
              ? InkWell(
                  onTap: onPressed,
                  child: Text(
                    text2,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 12.fs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                )
              : const Offstage(),
        ],
      ),
    );
  }
}
