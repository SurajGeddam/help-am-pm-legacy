import 'package:flutter/material.dart';
import 'package:helpampm/modules/provider_new_order/model/api/new_order_list_model.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';

class ServiceAmountDetailWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const ServiceAmountDetailWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _contentWidget(
            scheduleOrder.categoryName,
            scheduleOrder.serviceCategory,
          ),
          _contentWidget(
            "${AppUtils.getCurrencySymbol(scheduleOrder.currency)}${scheduleOrder.totalBill.toStringAsFixed(2).toString()}",
            AppStrings.amount,
            CrossAxisAlignment.end,
            TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(String key, String value,
      [CrossAxisAlignment? crossAxisAlignment, TextAlign? textAlign]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          key,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 16.fs,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          maxLines: 1,
          textAlign: textAlign ?? TextAlign.left,
        ),
        SizedBox(height: 6.sh),
        Text(
          value,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 14.fs,
            fontWeight: FontWeight.w400,
            color: AppColors.appMediumGrey,
          ),
          maxLines: 1,
          textAlign: textAlign ?? TextAlign.left,
        )
      ],
    );
  }
}
