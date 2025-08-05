import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../core/services/bloc/all_country_bloc/all_country_bloc.dart';
import '../../../core/services/bloc/all_country_bloc/all_country_state.dart';
import '../../../core/services/bloc/loading_indicator_bloc.dart';
import '../../../core/services/model/country_code_model.dart';
import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_screens/loading_indicator_screen.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import '../../app_drawer/bloc/logout_cubit.dart';
import '../bloc/individual_bloc/individual_bloc.dart';
import '../bloc/individual_bloc/individual_event.dart';
import '../bloc/individual_bloc/individual_state.dart';
import 'insurance_information_screen.dart';
import 'widgets/horizontal_stepper_widget.dart';
import 'widgets/is_mandatory_text_label_widget.dart';

class CompanyDetailsScreen extends StatefulWidget {
  static const String routeName = "/CompanyDetailsScreen";

  const CompanyDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController companyNameEditingController =
      TextEditingController();
  final TextEditingController companyPhoneEditingController =
      TextEditingController();
  final TextEditingController companyEmailEditingController =
      TextEditingController();
  final TextEditingController companyWebsiteEditingController =
      TextEditingController();

  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  late IndividualBloc individualBloc;
  late LoadingIndicatorBloc loadingIndicatorBloc;
  late LogoutCubit logoutCubit;

  late GetAllCountryCodeBloc getAllCountryCodeBloc;
  List<CountryCodeModel> countyCodeList = [];

  String countryCode = AppStrings.emptyString;
  String countryName = AppStrings.emptyString;

  bool isLoading = false;

  setData() async {
    individualBloc = IndividualBloc();
    companyEmailEditingController.text = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.userName);

    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);

    getAllCountryCodeBloc = GetAllCountryCodeBloc();
    getAllCountryCodeBloc.getAllCountryCode();

    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = false;
    }

    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = true;
      if (InputFormType.individual.code ==
          AppMockList.userInputDetailList[i].key) {
        break;
      }
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  void dispose() {
    companyNameEditingController.dispose();
    companyPhoneEditingController.dispose();
    companyEmailEditingController.dispose();
    companyWebsiteEditingController.dispose();
    flatNoController.dispose();
    areaController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IndividualBloc, IndividualState>(
          bloc: individualBloc,
          listener: (ctx, state) {
            if (state is IndividualLoadingState) {
              setState(() => isLoading = true);
            } else if (state is IndividualValidState) {
              individualBloc.add(
                IndividualSubmittedEvent(
                  companyNameEditingController:
                      companyNameEditingController.text,
                  companyPhoneEditingController:
                      "$countryCode ${companyPhoneEditingController.text.trim()}",
                  companyEmailEditingController:
                      companyEmailEditingController.text,
                  companyWebsiteEditingController:
                      companyWebsiteEditingController.text,
                  flatNoController: flatNoController.text,
                  areaController: areaController.text,
                  cityController: cityController.text,
                  stateController: stateController.text,
                  countryController: countryName,
                  pinCodeController: pinCodeController.text,
                  latitude: AppConstants.defaultPosition.latitude,
                  longitude: AppConstants.defaultPosition.longitude,
                  altitude: 0,
                ),
              );
              setState(() => isLoading = false);
            } else if (state is IndividualErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            } else if (state is IndividualCompleteState) {
              AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
              Future.delayed(
                  const Duration(seconds: 1),
                  () => Navigator.pushReplacementNamed(
                      context, InsuranceInformationScreen.routeName));
              return;
            }
          },
          child: const Offstage(),
        ),
        BlocListener<LogoutCubit, LogoutCubitState>(
          listener: (_, state) {
            if (state == LogoutCubitState.loading) {
              loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingStarted);
            } else if (state == LogoutCubitState.loaded) {
              loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingFinished);
            }
          },
        ),
      ],
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AppScaffoldWidget(
              appTitle: AppStrings.companyDetails,
              isBackShow: false,
              isLogoutShow: true,
              onLogoutPressed: () => logoutCubit.logoutApi(),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.sh, right: 20.sw, top: 20.sh),
                physics: const ClampingScrollPhysics(),
                children: [
                  Text(
                    AppStrings.companiesOrIndividualsInformation,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 16.fs,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 28.sh),
                    child: HorizontalStepperWidget(
                      userInputDetailList: AppMockList.userInputDetailList,
                    ),
                  ),

                  /// Company Name
                  AppTextLabelFormWidget(
                    labelText: AppStrings.companyName.toUpperCase(),
                    isMandatory: true,
                  ),
                  AppTextFieldFormWidget(
                    textController: companyNameEditingController,
                    maxLength: 25,
                  ),
                  SizedBox(height: 18.sh),

                  /// Company Phone
                  AppTextLabelFormWidget(
                    labelText: AppStrings.companyPhone.toUpperCase(),
                    isMandatory: true,
                  ),
                  BlocBuilder<GetAllCountryCodeBloc, GetAllCountryCodeState>(
                      bloc: getAllCountryCodeBloc,
                      builder: (ctx, state) {
                        if (state is GetAllCountryCodeLoadedState) {
                          countyCodeList = state.list;
                          countryCode = countyCodeList.first.dialCode!;
                          if (countryCode.isNotEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                countryCode.isNotEmpty
                                    ? SizedBox(
                                        height: 60,
                                        child: DropdownButton<String>(
                                          hint: const Text(
                                              AppStrings.countryCode),
                                          value: countryCode,
                                          onChanged: (String? value) {
                                            setState(
                                                () => countryCode = value!);
                                          },
                                          items: countyCodeList
                                              .map((CountryCodeModel value) {
                                            return DropdownMenuItem<String>(
                                              value: value.dialCode,
                                              child: Text(value.dialCode ??
                                                  AppStrings.emptyString),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : const Offstage(),
                                SizedBox(width: 18.sw),
                                Expanded(
                                  child: AppTextFieldFormWidget(
                                    textController:
                                        companyPhoneEditingController,
                                    textFormFieldType: TextFormFieldType.phone,
                                    maxLength: 10,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return const Offstage();
                      }),
                  SizedBox(height: 18.sh),

                  /// Company Email
                  AppTextLabelFormWidget(
                    labelText: AppStrings.companyEmail.toUpperCase(),
                    isMandatory: true,
                  ),
                  AppTextFieldFormWidget(
                    textController: companyEmailEditingController,
                    maxLength: 25,
                    textFormFieldType: TextFormFieldType.email,
                    readOnly: true,
                  ),
                  SizedBox(height: 18.sh),

                  /// Flat
                  AppTextLabelFormWidget(
                    labelText: AppStrings.addressLine1.toUpperCase(),
                    isMandatory: true,
                  ),
                  AppTextFieldFormWidget(
                    textController: flatNoController,
                    maxLength: 100,
                  ),
                  SizedBox(height: 18.sh),

                  /// Area
                  AppTextLabelFormWidget(
                    labelText: AppStrings.addressLine2.toUpperCase(),
                    isMandatory: false,
                  ),
                  AppTextFieldFormWidget(
                    textController: areaController,
                    maxLength: 100,
                  ),
                  SizedBox(height: 18.sh),

                  AppTextLabelFormWidget(
                    labelText: AppStrings.city.toUpperCase(),
                    isMandatory: true,
                  ),
                  AppTextFieldFormWidget(
                    textController: cityController,
                    maxLength: 25,
                  ),
                  SizedBox(height: 18.sh),

                  AppTextLabelFormWidget(
                    labelText: AppStrings.zipCode.toUpperCase(),
                    isMandatory: true,
                  ),
                  AppTextFieldFormWidget(
                    textController: pinCodeController,
                    maxLength: 6,
                    textFormFieldType: TextFormFieldType.postalCode,
                  ),
                  SizedBox(height: 18.sh),

                  /// State
                  AppTextLabelFormWidget(
                    labelText: AppStrings.state.toUpperCase(),
                    isMandatory: true,
                  ),
                  AppTextFieldFormWidget(
                    textController: stateController,
                    maxLength: 50,
                  ),
                  SizedBox(height: 18.sh),

                  /// Country
                  AppTextLabelFormWidget(
                    labelText: AppStrings.country.toUpperCase(),
                    isMandatory: true,
                  ),

                  BlocBuilder(
                      bloc: getAllCountryCodeBloc,
                      builder: (ctx, state) {
                        if (state is GetAllCountryCodeLoadedState) {
                          countyCodeList = state.list;
                          countryName = countyCodeList.first.name!;
                          if (countryName.isNotEmpty) {
                            return DropdownButton<String>(
                              hint: const Text(AppStrings.country),
                              value: countryName,
                              onChanged: (String? value) {
                                setState(() => countryName = value!);
                              },
                              items:
                                  countyCodeList.map((CountryCodeModel value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text(
                                      value.name ?? AppStrings.emptyString),
                                );
                              }).toList(),
                              isExpanded: true,
                            );
                          }
                        }
                        return const Offstage();
                      }),
                  SizedBox(height: 18.sh),

                  /// Company Website
                  const AppTextLabelFormWidget(
                    labelText: AppStrings.companyWebsite,
                    isMandatory: false,
                  ),
                  AppTextFieldFormWidget(
                    textController: companyWebsiteEditingController,
                    maxLength: 25,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.sh),
                    child: const IsMandatoryTextLabelWidget(),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.sh),
                    child: isLoading
                        ? const AppLoadingWidget()
                        : BottomButtonWidget(
                            buttonTitle: AppStrings.next,
                            buttonBGColor: AppColors.black,
                            onPressed: () => individualBloc.add(
                              IndividualValidationEvent(
                                companyNameEditingController:
                                    companyNameEditingController.text,
                                companyPhoneEditingController:
                                    companyPhoneEditingController.text,
                                companyEmailEditingController:
                                    companyEmailEditingController.text,
                                flatNoController: flatNoController.text,
                                cityController: cityController.text,
                                stateController: stateController.text,
                                countryController: countryName,
                                pinCodeController: pinCodeController.text,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<LoadingIndicatorBloc, LoadingIndicatorState>(
            bloc: loadingIndicatorBloc,
            builder: (_, state) {
              if (state == LoadingIndicatorState.loading) {
                return const LoadingIndicatorScreen();
              }
              return const Offstage();
            },
          ),
        ],
      ),
    );
  }
}
