import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../modules/ongoing_orders/bloc/ongoing_order_cubit/ongoing_order_cubit.dart';
import '../../../modules/provider_new_order/bloc/new_order_cubit/new_order_cubit.dart';
import '../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../../modules/provider_new_order/ui/provider_new_order_screen.dart';
import '../../../modules/provider_orders/bloc/schedule_order_cubit/schedule_order_cubit.dart';
import '../../../modules/service_provider/ui/service_provider_screen.dart';
import '../shared_preferences/shared_preference_helper.dart';

class NotificationHelper {
  NotificationHelper._();

  static navigateNotification(
      {RemoteMessage? message,
      NotificationResponse? payload,
      bool isNotificationClicked = false}) async {
    AppUtils.debugPrint("navigateNotification decoded => $message");
    final ctx = GlobalKeys.navigatorKey.currentState?.context;

    if (ctx != null && SharedPreferenceHelper().getIsUserLogin()) {
      if (message?.data["status"] != null &&
          (message?.data["status"] == AppConstants.schedule.toUpperCase())) {
        AppUtils.debugPrint("message[status] ==> ${message?.data["status"]}");
        if (!AppUtils.getIsRoleCustomer()) {
          if (isNotificationClicked) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                  ProviderNewOrderScreen.routeName,
                  arguments:
                      Quotes(orderNumber: message?.data["quoteUniqueId"]),
                  (Route<dynamic> route) => false);
            });
          }
          BlocProvider.of<NewOrderCubit>(ctx, listen: false).fetchNewOrder();
          BlocProvider.of<ScheduleOrderCubit>(ctx, listen: false)
              .fetchScheduleOrder();
        }
      } else if (message?.data["status"] != null &&
          (message?.data["status"] ==
              AppConstants.acceptedByProvider.toUpperCase())) {
        if (AppUtils.getIsRoleCustomer()) {
          if (isNotificationClicked) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                  ServiceProviderScreen.routeName,
                  arguments:
                      Quotes(orderNumber: message?.data["quoteUniqueId"]),
                  (Route<dynamic> route) => false);
            });
          }
        }
      } else if (message?.data["status"] != null &&
          (message?.data["status"] ==
                  AppConstants.paymentPending.toUpperCase() ||
              message?.data["status"] == AppConstants.started.toUpperCase())) {
        BlocProvider.of<OngoingOrderCubit>(ctx, listen: false)
            .fetchOngoingOrder();
      }
    }
  }
}
