import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../core_components/common_widgets/orders_widget/order_card_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_enum.dart';
import '../../../utils/app_constant.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import 'ongoing_order_list_screen.dart';

class OngoingOrdersWidget extends StatelessWidget {
  final List<Quotes> list;
  final bool isFromHome;

  const OngoingOrdersWidget({
    Key? key,
    required this.list,
    this.isFromHome = false,
  }) : super(key: key);

  OrdersType getOrdersType(String status) {
    switch (status) {
      case AppConstants.history:
        return OrdersType.history;
      case AppConstants.schedule:
        return OrdersType.schedule;
      default:
        return OrdersType.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.sh, left: 20.sw, right: 20.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.ongoingOrders,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            textAlign: TextAlign.left,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (isFromHome && list.length > 4) ? 4 : list.length,
            itemBuilder: (BuildContext ctx, int index) {
              return OrderCardWidget(
                scheduleOrder: list[index],
                ordersType: getOrdersType(list[index].status),
              );
            },
          ),
          (isFromHome && list.length > 4)
              ? GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, OngoingOrderListScreen.routeName),
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 25.sh,
                    padding: EdgeInsets.only(top: 12.sh),
                    child: Text(
                      AppStrings.more,
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 14.fs,
                        fontWeight: FontWeight.w500,
                        color: AppColors.hyperLinkBlue,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                )
              : const Offstage(),
        ],
      ),
    );
  }
}
