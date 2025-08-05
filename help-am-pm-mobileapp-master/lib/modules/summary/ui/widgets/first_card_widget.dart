import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class FirstCardWidget extends StatelessWidget {
  final Quotes quotes;

  const FirstCardWidget({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.all(20.sh),
      padding: EdgeInsets.all(16.sh),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.appGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1.sw, color: AppColors.appThinGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.congratulations,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 18.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.sh),
          Text(
            AppStrings.congratulationsMsg,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.appMediumGrey,
            ),
          ),
          SizedBox(height: 28.sh),
          rowKeyValueWidget(AppStrings.orderId, quotes.orderNumber),
          SizedBox(height: 10.sh),
          rowKeyValueWidget(
              AppStrings.bookedOn, AppUtils.getDateMMDDYYYY(quotes.createdAt)),
        ],
      ),
    );
  }

  Widget rowKeyValueWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          key,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 16.fs,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        SizedBox(width: 32.sh),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
