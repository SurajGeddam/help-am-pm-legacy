import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class AppTextLabelFormWidget extends StatelessWidget {
  final String labelText;
  final TextStyle? labelTextStyle;
  final bool isMandatory;
  final TextStyle? label2TextStyle;

  const AppTextLabelFormWidget({
    Key? key,
    required this.labelText,
    this.labelTextStyle,
    this.isMandatory = false,
    this.label2TextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sh),
      child: RichText(
        text: TextSpan(
          text: labelText,
          style: labelTextStyle ??
              AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 12.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorOnForm,
              ),
          children: <TextSpan>[
            TextSpan(
              text: isMandatory
                  ? AppStrings.asteriskSign
                  : AppStrings.emptyString,
              style: label2TextStyle ??
                  AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 12.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appOrange,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
