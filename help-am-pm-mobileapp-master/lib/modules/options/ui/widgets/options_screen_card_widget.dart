import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../utils/app_text_styles.dart';

class OptionsScreenCardWidget extends StatelessWidget {
  final String userKey;
  final String title;
  final String imageIcon;
  final bool isSelected;

  const OptionsScreenCardWidget({
    Key? key,
    required this.userKey,
    required this.title,
    required this.imageIcon,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.sh,
      child: Stack(
        children: [
          Container(
            height: 110.sh,
            width: 110.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.appYellow,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  imageIcon,
                  height: 29.sh,
                ),
                Text(
                  title,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          isSelected
              ? Positioned(
                  left: 50.sw,
                  top: 100.sh,
                  child: SvgPicture.asset(
                    AppAssets.circleCheckSvgIcon,
                    height: 19.sh,
                  ),
                )
              : const Offstage(),
        ],
      ),
    );
  }
}
