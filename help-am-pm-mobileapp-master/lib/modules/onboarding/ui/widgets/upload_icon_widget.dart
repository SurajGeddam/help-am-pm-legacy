import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';

class UploadIconWidget extends StatelessWidget {
  final String? bgImageString;
  final Color? textColor;

  const UploadIconWidget({
    Key? key,
    this.bgImageString,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            bgImageString ?? AppAssets.dottedBoxSvg,
            height: 42.sh,
            width: 115.sw,
            fit: BoxFit.fill,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.uploadSvgIcon,
                height: 22.sh,
                width: 22.sw,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 10.sw),
              Text(
                AppStrings.upload,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  color: textColor ?? AppColors.textColorOnForm,
                  fontSize: 12.fs,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
