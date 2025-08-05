import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/modules/provider_home/ui/provider_home_screen.dart';
import 'package:helpampm/modules/provider_orders/ui/order_details_screen.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../core/services/bloc/location_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_state.dart';
import '../../../core/services/location/location_manager_handler.dart';
import '../../../core_components/common_models/marker_item_model.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/google_map_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../bloc/confirm_order_cubit/confirm_order_cubit.dart';
import '../bloc/confirm_order_cubit/confirm_order_state.dart';
import '../model/api/new_order_list_model.dart';
import 'widgets/booking_details_widget.dart';

class ProviderNewOrderScreen extends StatefulWidget {
  static const String routeName = "/ProviderNewOrderScreen";
  final Quotes scheduleOrder;

  const ProviderNewOrderScreen({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<ProviderNewOrderScreen> createState() => _ProviderNewOrderScreenState();
}

class _ProviderNewOrderScreenState extends State<ProviderNewOrderScreen> {
  late LocationCubit locationCubit;
  late ConfirmOrderCubit confirmOrderCubit;
  late QuotesCubit quotesCubit;
  bool isLoading = false;
  String selectedDelay = "00:00:00";
  String currentTimeInHour = '00';
  String currentTimeInMin = '00';

  getValue(String value) {
    return value.padLeft(2, '0');
  }

  Widget durationPicker({bool inMinutes = false}) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.25,
      squeeze: 1,
      useMagnifier: true,
      itemExtent: 32,
      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          background: Colors.transparent),
      onSelectedItemChanged: (x) {
        if (inMinutes) {
          currentTimeInMin = x.toString();
        } else {
          currentTimeInHour = x.toString();
        }
        setState(() {
          selectedDelay =
              "${getValue(currentTimeInHour)}:${getValue(currentTimeInMin)}:00";
        });
      },
      children: List.generate(
        inMinutes ? 60 : 24,
        (index) => Text(
          inMinutes ? '$index mins' : '$index Hr',
        ),
      ),
    );
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Container(
              height: 260,
              padding: EdgeInsets.all(8.sw),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppStrings.cancel,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                                color: Colors.blue,
                                fontSize: 16.fs,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              AppUtils.debugPrint(
                                  "selectedDelay => $selectedDelay");
                              confirmOrderCubit.orderConfirm(
                                  widget.scheduleOrder.orderNumber,
                                  selectedDelay);
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppStrings.done,
                              style: AppTextStyles.defaultTextStyle.copyWith(
                                  color: Colors.blue,
                                  fontSize: 18.fs,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                    Material(
                      child: Text(
                        AppStrings.estimatedTime,
                        style: AppTextStyles.defaultTextStyle.copyWith(
                            color: Colors.black,
                            fontSize: 16.fs,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ));
  }

  Future<void> requestPermission() async {
    await LocationManagerHandler.shared
        .askForPermission(
      openAppSettings: true,
    )
        .then((value) async {
      AppUtils.debugPrint("value => $value");
      bool havePermission = value ?? false;
      if (havePermission) {
        init();
      } else {
        // LocationAlert().showAlert(context, isPermissionDenied: true);
      }
    });
  }

  void init() async {
    await locationCubit.getCurrentLocation();
    quotesCubit.quoteDetails(quoteUniqueId: widget.scheduleOrder.orderNumber);
  }

  onPressBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(context, ProviderHomeScreen.routeName);
    }
  }

  @override
  void initState() {
    confirmOrderCubit = ConfirmOrderCubit();
    locationCubit = BlocProvider.of<LocationCubit>(context, listen: false);
    quotesCubit = BlocProvider.of<QuotesCubit>(context, listen: false);
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.newOrder,
      isBackShow: true,
      onTapBack: onPressBack,
      child: BlocBuilder<LocationCubit, LocationCubitState>(
        bloc: locationCubit,
        builder: (_, state) {
          if (state == LocationCubitState.loaded) {
            Position position = locationCubit.getPosition();
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: AppUtils.deviceWidth,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.0, 1.0],
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            tileMode: TileMode.repeated,
                            colors: [
                              Color(0xFFFCCD37),
                              Color(0xFFFAD047),
                            ],
                          ),
                        ),
                        alignment: Alignment.topCenter,
                        child: GoogleMapWidget(
                          latLng: LatLng(position.latitude, position.longitude),
                          markerItemList: [
                            MarkerItemModel(
                              id: getDefaultStringValue(
                                  widget.scheduleOrder.customerAddress?.name),
                              title: getDefaultStringValue(
                                  widget.scheduleOrder.customerAddress?.name),
                              snippet: getDefaultStringValue(widget
                                  .scheduleOrder.customerAddress?.building),
                              imageString: AppUtils.getLocationIconOnMap(
                                  widget.scheduleOrder.textOnYellow),
                              location: LatLng(
                                  getDefaultDoubleValue(widget
                                      .scheduleOrder.customerAddress?.latitude),
                                  getDefaultDoubleValue(widget.scheduleOrder
                                      .customerAddress?.longitude)),
                            )
                          ],
                          isForSearchProvider: false,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: AppUtils.deviceWidth,
                        color: AppColors.white,
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 24.sh, left: 20.sw, right: 20.sw),
                          child: BlocListener<ConfirmOrderCubit,
                              ConfirmOrderState>(
                            bloc: confirmOrderCubit,
                            listener: (ctx, state) {
                              if (state is ConfirmOrderLoadingState) {
                                setState(() => isLoading = true);
                              } else if (state is ConfirmOrderErrorState) {
                                setState(() => isLoading = false);
                                AppUtils.showSnackBar(state.errorMessage,
                                    bgColor: state.bgColor);
                              } else if (state is ConfirmOrderLoadedState) {
                                setState(() => isLoading = false);
                                if (state.messageStatusModel?.status == 417 ||
                                    state.messageStatusModel?.status == 500) {
                                  AppUtils.showSnackBar(
                                      state.messageStatusModel?.message ??
                                          AppStrings.emptyString,
                                      bgColor: AppColors.red);
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                ProviderHomeScreen.routeName,
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    },
                                  );
                                } else {
                                  AppUtils.showSnackBar(
                                      state.messageStatusModel?.message ??
                                          AppStrings.emptyString,
                                      bgColor: state.bgColor);
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () => Navigator.pushReplacementNamed(
                                        context, OrderDetailsScreen.routeName,
                                        arguments: widget.scheduleOrder),
                                  );
                                }
                              }
                            },
                            child: isLoading
                                ? SizedBox(
                                    height: 48.sh,
                                    child: const AppLoadingWidget(),
                                  )
                                : BottomButtonWidget(
                                    buttonTitle: AppStrings.confirmOrder,
                                    buttonBGColor: AppColors.black,
                                    onPressed: () {
                                      currentTimeInHour =
                                          currentTimeInMin = "00";
                                      _showDialog(
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: durationPicker()),
                                              Expanded(
                                                  child: durationPicker(
                                                      inMinutes: true)),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<QuotesCubit, QuotesState>(
                      bloc: quotesCubit,
                      builder: (_, state) {
                        if (state is QuotesLoadedState) {
                          Quotes quotes = state.quotes;
                          return BookingDetailsWidget(scheduleOrder: quotes);
                        }
                        return const AppLoadingWidget();
                      }),
                ),
              ],
            );
          }
          return const AppLoadingWidget();
        },
      ),
    );
  }
}
