import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/bloc/all_country_bloc/all_country_bloc.dart';
import '../../core/services/bloc/all_country_bloc/all_country_state.dart';
import '../../core/services/model/country_code_model.dart';
import '../../core_components/common_widgets/app_loading_widget.dart';
import '../../core_components/common_widgets/app_scaffold_widget.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_utils.dart';
import '../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../address/ui/save_new_address_screen.dart';

class GoogleSearchScreen extends StatefulWidget {
  static const String routeName = "/GoogleSearchScreen";
  const GoogleSearchScreen({super.key});

  @override
  State<GoogleSearchScreen> createState() => _GoogleSearchScreenState();
}

class _GoogleSearchScreenState extends State<GoogleSearchScreen> {
  TextEditingController controller = TextEditingController();
  late GetAllCountryCodeBloc getAllCountryCodeBloc;
  List<CountryCodeModel> countyCodeList = [];
  List<String> countryList = [];

  @override
  void initState() {
    getAllCountryCodeBloc = GetAllCountryCodeBloc();
    getAllCountryCodeBloc.getAllCountryCode();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        child: BlocBuilder<GetAllCountryCodeBloc, GetAllCountryCodeState>(
            bloc: getAllCountryCodeBloc,
            builder: (context, state) {
              if (state is GetAllCountryCodeLoadedState) {
                countyCodeList = state.list;
                for (int i = 0; i < countyCodeList.length; i++) {
                  countryList
                      .add(countyCodeList[i].code ?? AppStrings.emptyString);
                }

                return Container(
                  color: AppColors.transparent,
                  height: 65.sh,
                  width: AppUtils.deviceWidth,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: controller,
                    googleAPIKey: AppConstants.mapAPIKey,
                    inputDecoration: InputDecoration(
                      hintText: AppStrings.searchYourLocation,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.black,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => controller.clear(),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.black,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 8.sw, top: 16.sh),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: _getBorderRadius(),
                        borderSide: BorderSide(
                          width: 1.sw,
                          color: AppColors.textColorOnForm,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: _getBorderRadius(),
                        borderSide: BorderSide(
                          width: 2.sw,
                          color: AppColors.red,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: _getBorderRadius(),
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColors.appThinGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: _getBorderRadius(),
                        borderSide: BorderSide(
                          width: 1.sw,
                          color: AppColors.appOrange,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: _getBorderRadius(),
                        borderSide: BorderSide(width: 1.sw),
                      ),
                    ),
                    debounceTime: 800,
                    countries: countryList,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      Future.delayed(Duration.zero, () {
                        List<Terms>? terms = prediction.terms;
                        if (terms != null && terms.isNotEmpty) {
                          SaveAddressReqBodyModel addressReqBodyModel =
                              SaveAddressReqBodyModel(
                            building: terms.first.value.toString(),
                            street: terms[1].value.toString(),
                            district: terms.length > 2
                                ? terms[2].value.toString()
                                : AppStrings.emptyString,
                            county: terms.length > 3
                                ? terms[3].value.toString()
                                : AppStrings.emptyString,
                            country: terms.last.value.toString(),
                            latitude: double.parse(prediction.lat ?? "0.0"),
                            longitude: double.parse(prediction.lng ?? "0.0"),
                          );
                          Navigator.pushReplacementNamed(
                              context, SaveNewAddressScreen.routeName,
                              arguments: {
                                "address": addressReqBodyModel,
                                "isSavedAddress": true,
                              });
                        }
                      });
                    },
                    itemClick: (Prediction prediction) {
                      controller.text =
                          prediction.description ?? AppStrings.emptyString;
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(
                              offset: prediction.description?.length ?? 0));
                    },
                  ),
                );
              }
              return const AppLoadingWidget();
            }),
      ),
    );
  }

  _getBorderRadius() => BorderRadius.all(Radius.circular(8.r));
}
