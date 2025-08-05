import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';

class AppErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  final Color? textColor;

  const AppErrorMessageWidget({
    Key? key,
    this.errorMessage = AppStrings.dioErrorTypeDefault,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sw),
      alignment: Alignment.center,
      child: Text(
        errorMessage,
        style: AppTextStyles.defaultTextStyle.copyWith(
          fontSize: 14.fs,
          fontWeight: FontWeight.w400,
          color: textColor ?? AppColors.appRed,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
