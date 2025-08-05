import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/core/services/shared_preferences/shared_preference_helper.dart';
import 'package:helpampm/modules/address/ui/address_screen.dart';

import '../../../core/services/bloc/location_cubit.dart';
import '../../../core_components/common_models/key_value_model.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/google_map_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_utils.dart';
import '../../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../address/ui/save_new_address_screen.dart';
import '../../login/model/login_model/auth_token_model.dart';
import '../../onboarding/ui/choose_category_screen.dart';
import 'widgets/location_with_address_widget.dart';

class ConfirmLocationScreen extends StatefulWidget {
  static const String routeName = "/ConfirmLocationScreen";
  final KeyValueModel? categoryObj;

  const ConfirmLocationScreen({Key? key, this.categoryObj}) : super(key: key);

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  late LocationCubit locationCubit;
  late Position position;
  late SaveAddressReqBodyModel addressModel;

  String locationName = AppStrings.emptyString;
  String locationDescription = AppStrings.emptyString;

  // bool isComingFromAddressList = false;
  Position? updatedPosition;

  late SharedPreferenceHelper sharedPreferenceHelper;

  void getAddressFormLocation(SaveAddressReqBodyModel addressModel) async {
    locationDescription =
        '${addressModel.building} ${addressModel.street} ${addressModel.district} '
        '\n${addressModel.county} ${addressModel.zipcode} '
        '${addressModel.country}';
    locationCubit.initDefaultLocation(locationName, locationDescription);
  }

  Future<void> setupData() async {
    List<Placemark> placeMarks = await locationCubit.getPlaceMarks(
        position.latitude, position.longitude);
    Placemark location = placeMarks.first;

    addressModel = SaveAddressReqBodyModel(
      name: locationName,
      building: location.street ?? AppStrings.emptyString,
      street: location.subLocality ?? AppStrings.emptyString,
      district: location.locality ?? AppStrings.emptyString,
      county: location.administrativeArea ?? AppStrings.emptyString,
      zipcode: location.postalCode ?? AppStrings.emptyString,
      country: location.country ?? AppStrings.emptyString,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    getAddressFormLocation(addressModel);
  }

  void init() async {
    locationCubit = BlocProvider.of<LocationCubit>(context, listen: false);
    sharedPreferenceHelper = SharedPreferenceHelper();

    UserDetailsDto? userDetailsDto =
        await sharedPreferenceHelper.getUserDetailsDto();
    locationName = userDetailsDto?.name ?? AppStrings.emptyString;

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
      appTitle: AppStrings.confirmLocation,
      child: BlocBuilder<LocationCubit, LocationCubitState>(
        bloc: locationCubit,
        builder: (_, state) {
          if (state == LocationCubitState.loaded) {
            position = locationCubit.getPosition();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    width: AppUtils.deviceWidth,
                    color: AppColors.white,
                    alignment: Alignment.topCenter,
                    child: GoogleMapWidget(
                        latLng: LatLng(position.latitude, position.longitude),
                        zoomValue: 18.0),
                  ),
                ),
                if (position.latitude != 0.0)
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: AppUtils.deviceWidth,
                      color: AppColors.white,
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 12.sh,
                            bottom: 24.sh,
                            left: 20.sw,
                            right: 20.sw),
                        child: FutureBuilder(
                            future: setupData(),
                            builder: (context, snapshot) {
                              return locationDetailWidget(snapshot);
                            }),
                      ),
                    ),
                  ),
              ],
            );
          }
          return const AppLoadingWidget();
        },
      ),
    );
  }

  Widget locationDetailWidget(AsyncSnapshot snapshot) {
    if (!snapshot.hasError &&
        (snapshot.connectionState == ConnectionState.done)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: LocationWithAddressWidget(
                isChangeBtnShow: (widget.categoryObj != null),
                locationName: locationName,
                locationDescription: locationDescription,
                onTapChangeBtn: () {
                  Navigator.of(context)
                      .pushNamed(AddressScreen.routeName, arguments: true)
                      .then((value) {
                    if (value != null) {
                      Future.delayed(Duration.zero, () {
                        Navigator.pushReplacementNamed(
                            context, ChooseCategoryScreen.routeName,
                            arguments: {
                              "address": value,
                              "categoryObj": widget.categoryObj,
                            });
                      });
                    }
                  });
                },
              ),
            ),
          ),
          BottomButtonWidget(
              buttonTitle: AppStrings.continueString,
              buttonBGColor: AppColors.black,
              onPressed: () {
                if (addressModel.customerUniqueId.isNotEmpty) {
                  Navigator.pushNamed(context, ChooseCategoryScreen.routeName,
                      arguments: {
                        "address": addressModel,
                        "categoryObj": widget.categoryObj,
                      });
                } else {
                  if (widget.categoryObj == null) {
                    Navigator.pop(context);
                  }
                  Navigator.pushNamed(context, SaveNewAddressScreen.routeName,
                      arguments: {
                        "address": addressModel,
                        "categoryObj": widget.categoryObj,
                        "isSavedAddress": (widget.categoryObj == null),
                      });
                }
              })
        ],
      );
    }
    return const AppLoadingWidget();
  }
}
