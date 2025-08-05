import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/services/bloc/location_cubit.dart';
import '../../../core_components/common_widgets/app_custom_top_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/google_map_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_utils.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import 'widgets/provider_profile_widget.dart';
import 'widgets/tracking_component_widget.dart';

class OrderTrackingScreen extends StatefulWidget {
  static const String routeName = "/OrderTrackingScreen";
  final Quotes quotes;

  const OrderTrackingScreen({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late LocationCubit locationCubit;
  late Position position;

  void init() async {
    locationCubit = BlocProvider.of<LocationCubit>(context, listen: false);
    await locationCubit.getCurrentLocation();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      safeAreaTop: false,
      isAppBarShow: false,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  width: AppUtils.deviceWidth,
                  alignment: Alignment.topCenter,
                  child: BlocBuilder<LocationCubit, LocationCubitState>(
                    bloc: locationCubit,
                    builder: (_, state) {
                      if (state == LocationCubitState.loaded) {
                        Position position = locationCubit.getPosition();
                        return GoogleMapWidget(
                            latLng:
                                LatLng(position.latitude, position.longitude));
                      }
                      return const AppLoadingWidget();
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: AppUtils.deviceWidth,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 56.sh, left: 20.sw, right: 20.sw),
              child: const AppCustomTopWidget(isFromTrackingScreen: true),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: AppUtils.deviceHeight * 0.33,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TrackingComponentWidget(),
                  Expanded(
                    child: GestureDetector(
                      onTap: null,
                      // onTap: () => Navigator.pushNamed(
                      //     context, OngoingServiceScreen.routeName,
                      //     arguments: {
                      //       "isProviderReached": true,
                      //       "quotes": widget.quotes,
                      //     }),
                      child: Container(
                        width: AppUtils.deviceWidth,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.0, 1.0],
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            tileMode: TileMode.repeated,
                            colors: [
                              Color(0xFFFBB034),
                              Color(0xFFFFDD00),
                            ],
                          ),
                        ),
                        child: ProviderProfileWidget(quotes: widget.quotes),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
