import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class CardWidget extends StatelessWidget {
  final KeyValueModel item;

  const CardWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: item.bgColor,
      ),
      padding:
          EdgeInsets.only(left: 20.sw, right: 20.sh, top: 24.sh, bottom: 16.sh),
      margin: EdgeInsets.all(20.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  item.key,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 18.fs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 24.sh),
                Text(
                  item.value,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDarkColorOnForm,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            item.imageString,
          )
        ],
      ),
    );
  }
}
