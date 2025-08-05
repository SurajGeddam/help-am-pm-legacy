import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../utils/app_strings.dart';

class ColumnKeyValueWidget extends StatelessWidget {
  final String header;
  final String value;
  final bool isDateTime;
  final String dateTimeString;

  const ColumnKeyValueWidget({
    Key? key,
    required this.header,
    required this.value,
    this.isDateTime = false,
    this.dateTimeString = AppStrings.emptyString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            header,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w300,
              color: AppColors.appMediumGrey,
            ),
          ),
          SizedBox(height: 6.sh),
          isDateTime
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 16.fs,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.sw),
                      child: SvgPicture.asset(
                        AppAssets.dotIconSvg,
                        color: AppColors.black,
                        fit: BoxFit.contain,
                        width: 6.sw,
                      ),
                    ),
                    Text(
                      dateTimeString,
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 16.fs,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                )
              : Text(
                  value,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
        ],
      ),
    );
  }
}
