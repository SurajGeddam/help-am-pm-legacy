import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class DataNotAvailableWidget extends StatelessWidget {
  const DataNotAvailableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtils.deviceHeight,
      alignment: Alignment.center,
      child: Text(
        AppStrings.dataNotAvailable,
        style: AppTextStyles.defaultTextStyle.copyWith(
          fontSize: 16.fs,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
