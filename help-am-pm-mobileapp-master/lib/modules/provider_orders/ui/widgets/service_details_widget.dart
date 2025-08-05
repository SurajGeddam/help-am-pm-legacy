import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../utils/app_colors.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class ServiceDetailsWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const ServiceDetailsWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.sw, top: 16.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 32.sh,
            width: 32.sw,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.appYellow,
              border: Border.all(width: 1.sw, color: AppColors.appGrey),
            ),
            alignment: Alignment.center,
            child: Text(
              scheduleOrder.textOnYellow,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 16.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scheduleOrder.categoryName,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 4.sh),
                Text(
                  scheduleOrder.serviceCategory,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appMediumGrey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
