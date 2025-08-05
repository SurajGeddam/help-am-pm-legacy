import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class RowItemsWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final TextStyle? textStyle;
  final bool isBackIcon;
  final bool isImageWithIcon;
  final String imageName;

  const RowItemsWidget({
    Key? key,
    required this.text1,
    this.text2 = AppStrings.emptyString,
    this.textStyle,
    this.isBackIcon = false,
    this.isImageWithIcon = false,
    this.imageName = AppAssets.userLogoSvgIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                isImageWithIcon
                    ? Padding(
                        padding: EdgeInsets.only(right: 6.sw),
                        child: SvgPicture.asset(
                          imageName,
                          height: 12.sh,
                          color: AppColors.appYellow,
                        ),
                      )
                    : const Offstage(),
                Expanded(
                  child: Text(
                    text1,
                    style: textStyle ??
                        AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 16.fs,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
        ),
        isBackIcon
            ? SvgPicture.asset(
                AppAssets.backIconSvg,
                height: 8.sh,
                color: AppColors.appMediumGrey,
              )
            : Text(
                text2,
                style: textStyle ??
                    AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 16.fs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ],
    );
  }
}
