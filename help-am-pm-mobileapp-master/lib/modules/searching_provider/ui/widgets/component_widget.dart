import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class ComponentWidget extends StatelessWidget {
  const ComponentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.weCareForYour,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.sh),
            child: SvgPicture.asset(AppAssets.loadingStickSvg),
          ),
          Text(
            AppStrings.weCareForYourMsg,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 12.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.appMediumGrey,
            ),
            maxLines: 2,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 14.sh),
          Expanded(
            child: Center(
              child: Image.asset(
                AppAssets.loadingIcon,
                height: 104.sh,
                width: 104.sw,
              ),
            ),
          )
        ],
      ),
    );
  }
}
