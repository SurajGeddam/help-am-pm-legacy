import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class ServiceToWidget extends StatelessWidget {
  final Quotes scheduleOrder;
  final bool isFromStartBooking;

  const ServiceToWidget({
    Key? key,
    required this.scheduleOrder,
    this.isFromStartBooking = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: isFromStartBooking
          ? null
          : EdgeInsets.only(top: 14.sh, left: 20.sw, right: 20.sw),
      padding: isFromStartBooking
          ? EdgeInsets.symmetric(horizontal: 20.sw)
          : EdgeInsets.only(top: 14.sh, left: 16.sw, right: 16.sw),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: isFromStartBooking
            ? null
            : Border.all(width: 1.sw, color: AppColors.appGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _imageTextWidget(
            AppAssets.locationIconSvg,
            AppUtils.getLocationName(scheduleOrder.customerAddress),
            20.sh,
            isFromStartBooking
                ? AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appDarkGrey,
                  )
                : AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
          ),
          SizedBox(height: 14.sh),
          _imageTextWidget(
            AppAssets.userLogoSvgIcon,
            scheduleOrder.customerName,
          ),
          SizedBox(height: 12.sh),
          _imageTextWidget(
            AppAssets.callIconSvg,
            scheduleOrder.customerPhone,
          ),
          SizedBox(height: 14.sh),
        ],
      ),
    );
  }

  Widget _imageTextWidget(String imagePath, String text,
      [double? imageHeight, TextStyle? textStyle]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 12.sw),
          child: SvgPicture.asset(
            imagePath,
            height: imageHeight ?? 16.sh,
            color: AppColors.appYellow,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: textStyle ??
                AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w400,
                  color: isFromStartBooking
                      ? AppColors.appDarkGrey
                      : AppColors.textDarkColorOnForm,
                ),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
