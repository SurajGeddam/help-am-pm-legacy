import 'package:flutter/material.dart';
import 'package:helpampm/modules/service_provider/ui/service_provider_screen.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_enum.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../../modules/provider_new_order/ui/provider_new_order_screen.dart';
import '../../../modules/provider_orders/ui/order_details_screen.dart';
import '../../../modules/provider_orders/ui/order_information_screen.dart';
import '../../../modules/started_booking/ui/started_booking_detail_screen.dart';
import '../../../utils/app_constant.dart';
import '../../common_screens/undefined_screen.dart';
import 'text_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final Quotes scheduleOrder;
  final OrdersType ordersType;

  const OrderCardWidget({
    Key? key,
    required this.scheduleOrder,
    this.ordersType = OrdersType.history,
  }) : super(key: key);

  String getNavigationPath() {
    AppUtils.debugPrint("Status: ${scheduleOrder.status}");
    switch (scheduleOrder.status) {
      case AppConstants.schedule:
        return AppUtils.getIsRoleCustomer()
            ? OrderInformationScreen.routeName
            : ProviderNewOrderScreen.routeName;
      case AppConstants.started:
        return StartedBookingDetailScreen.routeName;
      case AppConstants.acceptedByProvider:
        return AppUtils.getIsRoleCustomer()
            ? ServiceProviderScreen.routeName
            : OrderDetailsScreen.routeName;
      case AppConstants.paymentDone:
        return OrderInformationScreen.routeName;
      case AppConstants.paymentPending:
        return StartedBookingDetailScreen.routeName;
      case AppConstants.orderCancelled:
        return OrderInformationScreen.routeName;
      default:
        return UndefinedScreen.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, getNavigationPath(),
          arguments: scheduleOrder),
      child: Container(
        margin: EdgeInsets.only(top: 20.sh),
        height: 100.sh,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 100.sh,
              width: 75.sw,
              color: AppColors.appYellow,
              alignment: Alignment.center,
              child: Text(
                scheduleOrder.textOnYellow,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 24.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextWidget(
              scheduleOrder: scheduleOrder,
              ordersType: ordersType,
            ),
          ],
        ),
      ),
    );
  }
}
