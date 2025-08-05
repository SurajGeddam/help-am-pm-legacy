import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class RowImageTextWidget extends StatelessWidget {
  final String imageString;
  final String text;
  final Color imageColor;

  const RowImageTextWidget({
    Key? key,
    required this.imageString,
    required this.text,
    required this.imageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SvgPicture.asset(
          imageString,
          width: 14.sw,
          height: 14.sh,
          color: imageColor,
        ),
        SizedBox(width: 8.sw),
        Text(
          text,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 14.fs,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ],
    );
  }
}
