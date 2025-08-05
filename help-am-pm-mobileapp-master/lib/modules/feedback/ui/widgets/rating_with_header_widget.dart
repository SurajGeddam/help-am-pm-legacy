import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_utils.dart';

class RatingWithHeaderWidget extends StatelessWidget {
  final bool isShowHeader;
  final Function onPressed;

  const RatingWithHeaderWidget({
    Key? key,
    this.isShowHeader = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isShowHeader
            ? Padding(
                padding: EdgeInsets.only(top: 30.sh, left: 20.sw, right: 40.sw),
                child: Text(
                  AppStrings.rateYourExperienceWithCustomer,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 20.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMediumColorOnForm,
                  ),
                ),
              )
            : const Offstage(),
        Padding(
          padding: EdgeInsets.only(top: 20.sh, bottom: 20.sh, left: 10.sw),
          child: RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 32.sh,
            itemPadding: EdgeInsets.symmetric(horizontal: 6.sw),
            itemBuilder: (context, _) => SvgPicture.asset(
              AppAssets.starIconSvg,
              color: AppColors.appYellow,
            ),
            onRatingUpdate: (rating) {
              AppUtils.debugPrint("rating = $rating");
              onPressed(rating);
            },
          ),
        ),
      ],
    );
  }
}
