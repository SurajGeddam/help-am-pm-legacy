import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_enum.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import 'row_items_widget.dart';

class TextWidget extends StatelessWidget {
  final Quotes scheduleOrder;
  final OrdersType ordersType;

  const TextWidget({
    Key? key,
    required this.scheduleOrder,
    required this.ordersType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currencySymbol = AppUtils.getCurrencySymbol(scheduleOrder.currency);

    return Expanded(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(0.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.appGrey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 4),
              // first par-meter of offset is left-right
              // second parameter is top to down
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 14.sh, left: 14.sw, right: 14.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RowItemsWidget(
                text1: scheduleOrder.categoryName,
                text2:
                    "$currencySymbol${scheduleOrder.totalBill.toStringAsFixed(2)}",
                textStyle: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 16.fs,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14.sh, bottom: 7.sh),
                child: RowItemsWidget(
                  text1: (ordersType.type == OrdersType.history.type)
                      ? scheduleOrder.customerName
                      : AppUtils.getDateMMDDYYYY(scheduleOrder.createdAt),
                  textStyle: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appMediumGrey,
                  ),
                  isBackIcon: true,
                  isImageWithIcon: true,
                  imageName: (ordersType.type == OrdersType.history.type)
                      ? AppAssets.userLogoSvgIcon
                      : AppAssets.calenderIconSvg,
                ),
              ),
              RowItemsWidget(
                text1: (ordersType.type == OrdersType.history.type)
                    ? AppUtils.getLocationName(scheduleOrder.customerAddress)
                    : AppUtils.getDateHhMmA(scheduleOrder.createdAt),
                text2: AppUtils.getDateMMDDYYYY(scheduleOrder.serviceDate),
                textStyle: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appMediumGrey,
                ),
                isImageWithIcon: true,
                imageName: (ordersType.type == OrdersType.history.type)
                    ? AppAssets.locationIconSvg
                    : AppAssets.timeIconSvg,
              )
            ],
          ),
        ),
      ),
    );
  }
}
