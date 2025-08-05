import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/notifications/ui/notifications_screen.dart';
import 'package:helpampm/modules/provider_home/model/provider_log_model/provider_log_model.dart';
import 'package:helpampm/modules/provider_home/ui/widgets/current_location_widget.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/device_token_bloc.dart';
import '../../../core/services/bloc/loading_indicator_bloc.dart';
import '../../../core/services/bloc/location_cubit.dart';
import '../../../core/services/location/location_alert_widget.dart';
import '../../../core/services/location/location_manager_handler.dart';
import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_colors.dart';
import '../../app_drawer/ui/app_drawer_screen.dart';
import '../../ongoing_orders/bloc/ongoing_order_cubit/ongoing_order_cubit.dart';
import '../../ongoing_orders/bloc/ongoing_order_cubit/ongoing_order_state.dart';
import '../../ongoing_orders/ui/ongoing_orders_widget.dart';
import '../../provider_new_order/bloc/new_order_cubit/new_order_cubit.dart';
import '../../provider_new_order/bloc/new_order_cubit/new_order_state.dart';
import '../../provider_orders/bloc/schedule_order_cubit/schedule_order_cubit.dart';
import '../../provider_orders/bloc/schedule_order_cubit/schedule_order_state.dart';
import '../bloc/provider_log_cubit/provider_log_cubit.dart';
import '../bloc/provider_log_cubit/provider_log_state.dart';
import '../bloc/sending_location_cubit/sending_location_cubit.dart';
import 'widgets/kyc_verification_widget.dart';
import 'widgets/location_disable_widget.dart';
import 'widgets/logs_screen.dart';
import 'widgets/new_orders_widget.dart';
import 'widgets/operations_list_widget.dart';
import 'widgets/schedule_orders_widget.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const String routeName = "/ProviderHomeScreen";

  const ProviderHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ProviderLogCubit providerLogCubit;
  late ScheduleOrderCubit scheduleOrderCubit;
  late NewOrderCubit newOrderCubit;
  late OngoingOrderCubit ongoingOrderCubit;

  late SendingLocationCubit sendingLocationCubit;
  late LocationCubit locationCubit;
  late Timer timer;

  late LoadingIndicatorBloc loadingIndicatorBloc;
  bool isLocationEnableValue = false;

  Future<void> requestPermission() async {
    await LocationManagerHandler.shared
        .askForPermission(
      openAppSettings: true,
    )
        .then((value) async {
      AppUtils.debugPrint("value => $value");
      bool havePermission = value ?? false;
      loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingFinished);
      if (havePermission) {
        setState(() => isLocationEnableValue = true);
        await locationCubit.getCurrentLocation();
      } else {
        setState(() => isLocationEnableValue = false);
      }
    });
  }

  void timerMethod(timer) async {
    String token = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.token);
    try {
      if (token.isNotEmpty && !SharedPreferenceHelper().getIsRoleCustomer()) {
        await locationCubit.getCurrentPosition().then((value) =>
            sendingLocationCubit
                .sentProviderLocation(locationCubit.getPosition()));
      }
    } catch (e) {
      timer.cancel();
    }
  }

  void init() async {
    requestPermission();
    providerLogCubit =
        BlocProvider.of<ProviderLogCubit>(context, listen: false);
    scheduleOrderCubit =
        BlocProvider.of<ScheduleOrderCubit>(context, listen: false);

    newOrderCubit = BlocProvider.of<NewOrderCubit>(context, listen: false);
    locationCubit = BlocProvider.of<LocationCubit>(context, listen: false);

    loadingIndicatorBloc = LoadingIndicatorBloc();
    loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingStarted);

    ongoingOrderCubit =
        BlocProvider.of<OngoingOrderCubit>(context, listen: false);

    sendingLocationCubit = SendingLocationCubit();
  }

  Future<void> _pullRefresh() async {
    providerLogCubit.fetchProviderLog();
    scheduleOrderCubit.fetchScheduleOrder();
    newOrderCubit.fetchNewOrder();
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
            "-----Updating FCM Device Token------ provider_home.dart");
        deviceTokenBloc.updateFCMDeviceToken(deviceToken.toString());
      }
    }
  }

  @override
  void initState() {
    init();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isLocationEnable =
          await LocationManagerHandler.shared.isLocationEnable();
      if (!isLocationEnable) {
        setState(() => isLocationEnableValue = false);
        if (GlobalKeys.navigatorKey.currentState?.context != null) {
          Future.delayed(
              Duration.zero,
              () => LocationAlert()
                  .showAlert(GlobalKeys.navigatorKey.currentState?.context));
        }
      } else {
        setState(() => isLocationEnableValue = true);
        timer = Timer.periodic(
            const Duration(seconds: AppConstants.locationTimer),
            (timer) => timerMethod(timer));
      }

      checkAndUpdateDeviceTokenToServer();
      _pullRefresh();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppScaffoldWidget(
          key: _scaffoldKey,
          isHomeScreen: true,
          appTitle: AppConstants.applicationName,
          onTapBack: () =>
              Navigator.pushNamed(context, AppDrawerScreen.routeName),
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
                isLocationEnableValue
                    ? const Offstage()
                    : const LocationDisableWidget(),

                /// provider log
                BlocConsumer<ProviderLogCubit, ProviderLogState>(
                  bloc: providerLogCubit,
                  listener: (_, state) {},
                  builder: (_, state) {
                    if (state is ProviderLogErrorState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          AppUtils.showSnackBar(state.errorMessage,
                              bgColor: state.bgColor));
                      return const Offstage();
                    } else if (state is ProviderLogLoadedState) {
                      ProviderLogModel logModel = state.providerLogModel;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!(logModel.stripeAccountCompleted ?? true))
                            const KYCVerificationWidget(),
                          if (logModel.countModel != null)
                            LogsScreen(list: logModel.countModel ?? [])
                        ],
                      );
                    }
                    return const AppLoadingWidget();
                  },
                ),

                /// provider ongoing orders list
                BlocConsumer<OngoingOrderCubit, OngoingOrderState>(
                  bloc: ongoingOrderCubit,
                  listener: (_, state) {},
                  builder: (_, state) {
                    if (state is OngoingOrderErrorState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          AppUtils.showSnackBar(state.errorMessage,
                              bgColor: state.bgColor));
                      return const Offstage();
                    } else if (state is OngoingOrderLoadedState) {
                      return state.list.isNotEmpty
                          ? OngoingOrdersWidget(
                              list: state.list, isFromHome: true)
                          : const Offstage();
                    }
                    return const AppLoadingWidget();
                  },
                ),

                /// provider new orders list
                BlocConsumer<NewOrderCubit, NewOrderState>(
                  bloc: newOrderCubit,
                  listener: (_, state) {},
                  builder: (_, state) {
                    if (state is NewOrderErrorState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          AppUtils.showSnackBar(state.errorMessage,
                              bgColor: state.bgColor));
                      return const Offstage();
                    } else if (state is NewOrderLoadedState) {
                      return state.list.isNotEmpty
                          ? NewOrdersWidget(list: state.list, isFromHome: true)
                          : const Offstage();
                    }
                    return const AppLoadingWidget();
                  },
                ),

                /// provider schedule orders list
                BlocConsumer<ScheduleOrderCubit, ScheduleOrderState>(
                  bloc: scheduleOrderCubit,
                  listener: (_, state) {},
                  builder: (_, state) {
                    if (state is ScheduleOrderErrorState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          AppUtils.showSnackBar(state.errorMessage,
                              bgColor: state.bgColor));
                      return const Offstage();
                    } else if (state is ScheduleOrderLoadedState) {
                      return state.list.isNotEmpty
                          ? ScheduleOrdersWidget(
                              list: state.list, isFromHome: true)
                          : const Offstage();
                    }
                    return const AppLoadingWidget();
                  },
                ),

                /// provider location
                BlocBuilder<LocationCubit, LocationCubitState>(
                  bloc: locationCubit,
                  builder: (_, state) {
                    if (state == LocationCubitState.loaded) {
                      AppUtils.debugPrint(
                          "Location => ${locationCubit.getPosition()}");
                      return CurrentLocationWidget(
                          position: locationCubit.getPosition());
                    }
                    return const Offstage();
                  },
                ),

                /// others
                const OperationsListWidget(),
                SizedBox(height: 25.sh),
              ],
            ),
          ),
        ),
        BlocBuilder<LoadingIndicatorBloc, LoadingIndicatorState>(
            bloc: loadingIndicatorBloc,
            builder: (_, state) {
              if (state == LoadingIndicatorState.loading) {
                return AppLoadingWidget(
                  bgColor: AppColors.appDarkGrey,
                );
              }
              return const Offstage();
            })
      ],
    );
  }
}
