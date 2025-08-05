import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';

class CommentBoxWidget extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final double textBoxHeight;

  const CommentBoxWidget({
    Key? key,
    required this.textController,
    this.hintText = AppStrings.tellUsYourExperienceWithCustomer,
    this.textBoxHeight = 170.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.sw, left: 20.sw, right: 20.sh),
      height: textBoxHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.appGrey, width: 1.sh),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: textController,
        cursorColor: AppColors.textMediumColorOnForm,
        textAlign: TextAlign.start,
        enabled: true,
        maxLines: 50,
        onChanged: (s) {},
        style: TextStyle(
          fontSize: 14.fs,
          color: AppColors.textMediumColorOnForm,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.defaultTextStyle.copyWith(
            color: AppColors.appLightGrey,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.sw,
            vertical: 12.sh,
          ),
        ),
      ),
    );
  }
}
