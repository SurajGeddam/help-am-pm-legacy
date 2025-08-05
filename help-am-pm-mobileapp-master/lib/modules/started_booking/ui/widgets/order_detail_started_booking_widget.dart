import 'package:flutter/material.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import '../../../provider_orders/ui/widgets/pricing_details_widget.dart';
import '../../../provider_orders/ui/widgets/service_to_widget.dart';

class OrderDetailStartedBookingWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const OrderDetailStartedBookingWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.only(
          top: AppUtils.deviceHeight * 0.2,
          bottom: 100.sh,
          left: 20.sw,
          right: 20.sw),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 1.sw, color: AppColors.appGrey),
      ),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.all(16.sh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  AppStrings.orderDetails,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  AppUtils.getDateMMDDYYYY(scheduleOrder.createdAt),
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDarkColorOnForm,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1.sh,
            thickness: 1.sh,
            color: AppColors.dividerColor,
          ),
          Padding(
            padding: EdgeInsets.all(20.sh),
            child: Text(
              AppStrings.serviceTo,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          ServiceToWidget(
            scheduleOrder: scheduleOrder,
            isFromStartBooking: true,
          ),
          Divider(
            height: 1.sh,
            thickness: 1.sh,
            color: AppColors.dividerColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.sh, bottom: 30.sh),
            child: PricingDetailsWidget(scheduleOrder: scheduleOrder),
          ),
        ],
      ),
    );
  }
}
