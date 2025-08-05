import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class TopYellowWidget extends StatelessWidget {
  final String title;
  final VoidCallback? callback;

  const TopYellowWidget({
    Key? key,
    this.title = AppStrings.emptyString,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.sh,
      width: AppUtils.deviceWidth,
      color: AppColors.appYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 36.sh),
          Padding(
            padding: EdgeInsets.only(left: 20.sw),
            child: Text(
              title,
              style: AppTextStyles.defaultTextStyle.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
                fontSize: 26.fs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
