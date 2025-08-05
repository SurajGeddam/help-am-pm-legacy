import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/device_token_bloc.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_assets.dart';
import '../../app_drawer/ui/app_drawer_screen.dart';
import '../../notifications/ui/notifications_screen.dart';
import '../../ongoing_orders/bloc/ongoing_order_cubit/ongoing_order_cubit.dart';
import '../../ongoing_orders/bloc/ongoing_order_cubit/ongoing_order_state.dart';
import '../../ongoing_orders/ui/ongoing_orders_widget.dart';
import 'widgets/customer_operations_list_widget.dart';

class CustomerHomeScreen extends StatefulWidget {
  static const String routeName = "/CustomerHomeScreen";

  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  late OngoingOrderCubit ongoingOrderCubit;

  Future<void> _pullRefresh() async {
    ongoingOrderCubit.fetchOngoingOrder();
  }

  void checkAndUpdateDeviceTokenToServer() {
    bool isLoggedIn = SharedPreferenceHelper().getIsUserLogin();
    String deviceToken = AppUtils.getDeviceToken();
    AppUtils.debugPrint("deviceToken ===> $deviceToken");

    if (isLoggedIn && deviceToken.isNotEmpty) {
      if (!AppUtils.isDeviceTokenUpdated()) {
        DeviceTokenBloc deviceTokenBloc = DeviceTokenBloc();
        deviceTokenBloc.stream.listen((event) {
          AppUtils.setDeviceTokenUpdateStatus(event == DeviceTokenState.loaded);
        });
        AppUtils.debugPrint(
            "-----Updating FCM Device Token------ customer_home_screen.dart");
        deviceTokenBloc.updateFCMDeviceToken(deviceToken.toString());
      }
    }
  }

  @override
  void initState() {
    ongoingOrderCubit =
        BlocProvider.of<OngoingOrderCubit>(context, listen: false);

    ongoingOrderCubit.fetchOngoingOrder();
    checkAndUpdateDeviceTokenToServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isHomeScreen: true,
      onTapBack: () => Navigator.pushNamed(context, AppDrawerScreen.routeName),
      onSearchPressed: () =>
          Navigator.pushNamed(context, NotificationsScreen.routeName),
      onRefreshPressed: () => _pullRefresh(),
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180.sh,
              padding: EdgeInsets.only(top: 28.sh, left: 20.sw, right: 20.sw),
              width: double.infinity,
              child: SvgPicture.asset(
                AppAssets.customerHomeImageSvg,
                fit: BoxFit.fill,
              ),
            ),
            const CustomerOperationsListWidget(),

            /// provider ongoing orders list
            BlocConsumer<OngoingOrderCubit, OngoingOrderState>(
              bloc: ongoingOrderCubit,
              listener: (_, state) {
                if (state is OngoingOrderErrorState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      AppUtils.showSnackBar(state.errorMessage,
                          bgColor: state.bgColor));
                }
              },
              builder: (_, state) {
                if (state is OngoingOrderErrorState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      AppUtils.showSnackBar(state.errorMessage,
                          bgColor: state.bgColor));
                  return const Offstage();
                } else if (state is OngoingOrderLoadedState) {
                  return state.list.isNotEmpty
                      ? OngoingOrdersWidget(list: state.list, isFromHome: true)
                      : const Offstage();
                }
                return const AppLoadingWidget();
              },
            ),

            SizedBox(height: 24.sh),
          ],
        ),
      ),
    );
  }
}
