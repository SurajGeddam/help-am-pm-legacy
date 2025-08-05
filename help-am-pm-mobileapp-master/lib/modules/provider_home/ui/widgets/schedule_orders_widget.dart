import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../core_components/common_widgets/orders_widget/order_card_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_enum.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import '../../../provider_orders/ui/provider_orders_screen.dart';

class ScheduleOrdersWidget extends StatelessWidget {
  final List<Quotes> list;
  final bool isFromHome;

  const ScheduleOrdersWidget({
    Key? key,
    required this.list,
    this.isFromHome = false,
  }) : super(key: key);

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
            AppStrings.scheduleOrders,
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
                ordersType: OrdersType.schedule,
              );
            },
          ),
          (isFromHome && list.length > 4)
              ? GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ProviderOrdersListScreen.routeName),
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
