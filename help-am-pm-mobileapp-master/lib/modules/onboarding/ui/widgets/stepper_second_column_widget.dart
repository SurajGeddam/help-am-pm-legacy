import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class StepperSecondColumnWidget extends StatelessWidget {
  final KeyValueModel data;

  const StepperSecondColumnWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 16.sh),
          Text(
            data.key,
            maxLines: 2,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.black,
              fontSize: 14.fs,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.sh),
          Text(
            data.value,
            maxLines: 4,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.black,
              fontSize: 14.fs,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 46.sh),
          Divider(
            height: 1.sh,
            thickness: 1.sh,
            color: AppColors.dividerColor,
          )
        ],
      ),
    );
  }
}
