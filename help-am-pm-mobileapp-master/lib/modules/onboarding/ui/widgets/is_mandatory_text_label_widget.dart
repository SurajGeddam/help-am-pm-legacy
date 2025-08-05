import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class IsMandatoryTextLabelWidget extends StatelessWidget {
  const IsMandatoryTextLabelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: AppStrings.asteriskSign,
        style: AppTextStyles.defaultTextStyle.copyWith(
          fontSize: 12.fs,
          fontWeight: FontWeight.w400,
          color: AppColors.appOrange,
        ),
        children: <TextSpan>[
          TextSpan(
            text: AppStrings.fieldsAreMandatory,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 12.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.textColorOnForm,
            ),
          ),
        ],
      ),
    );
  }
}
