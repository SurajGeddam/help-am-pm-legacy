import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core_components/common_models/key_value_model.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_mock_list.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_checkbox_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_strings.dart';
import '../../onboarding/ui/choose_category_screen.dart';
import '../bloc/address_cubit/address_cubit.dart';
import '../bloc/save_address_bloc/save_address_bloc.dart';
import '../bloc/save_address_bloc/save_address_event.dart';
import '../bloc/save_address_bloc/save_address_state.dart';
import '../model/save_address_model/request_body/save_address_req_body_model.dart';
import 'widgets/type_of_address_widget.dart';

class SaveNewAddressScreen extends StatefulWidget {
  static const String routeName = "/SaveNewAddressScreen";
  final SaveAddressReqBodyModel? addressModel;
  final KeyValueModel? categoryObj;
  final bool isSavedAddress;
  final bool isForUpdateAddress;

  const SaveNewAddressScreen({
    Key? key,
    this.addressModel,
    this.categoryObj,
    required this.isSavedAddress,
    required this.isForUpdateAddress,
  }) : super(key: key);

  @override
  State<SaveNewAddressScreen> createState() => _SaveNewAddressScreenState();
}

class _SaveNewAddressScreenState extends State<SaveNewAddressScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  late SaveAddressBloc saveAddressBloc;
  List<KeyValueModel> _list = [];

  bool isLoading = false;
  bool isSaveThisAddress = false;
  String selectedAddressType = AppConstants.home;

  void onSelect(KeyValueModel obj) {
    setState(() {
      for (var e in _list) {
        e.isSelected = false;
      }
      obj.isSelected = true;
      selectedAddressType = obj.key;
    });
  }

  setUpExistAddress() {
    nameController.text = widget.addressModel?.name ?? AppStrings.emptyString;
    pinCodeController.text =
        widget.addressModel?.zipcode ?? AppStrings.emptyString;
    cityController.text =
        widget.addressModel?.district ?? AppStrings.emptyString;
    stateController.text =
        widget.addressModel?.county ?? AppStrings.emptyString;
    countryController.text =
        widget.addressModel?.country ?? AppStrings.emptyString;
    flatNoController.text =
        widget.addressModel?.building ?? AppStrings.emptyString;
    areaController.text = widget.addressModel?.street ?? AppStrings.emptyString;
  }

  @override
  void initState() {
    saveAddressBloc = SaveAddressBloc();
    _list = AppMockList.typeOfAddress;

    isSaveThisAddress = widget.isSavedAddress;
    if (widget.addressModel != null) {
      setUpExistAddress();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        appTitle: AppStrings.addAddress,
        child: BlocListener<SaveAddressBloc, SaveAddressState>(
          bloc: saveAddressBloc,
          listener: (ctx, state) {
            if (state is SaveAddressLoadingState) {
              setState(() => isLoading = true);
            } else if (state is SaveAddressValidState) {
              setState(() => isLoading = false);
              if (isSaveThisAddress || widget.isForUpdateAddress) {
                saveAddressBloc.add(SaveAddressSubmittedEvent(
                  nameController: nameController.text,
                  pinCodeController: pinCodeController.text,
                  cityController: cityController.text,
                  stateController: stateController.text,
                  countryController: countryController.text,
                  flatNoController: flatNoController.text,
                  areaController: areaController.text,
                  latitude: widget.addressModel!.latitude,
                  longitude: widget.addressModel!.longitude,
                  altitude: widget.addressModel!.altitude,
                  addressType: selectedAddressType,
                  isDefault: false,
                  customerUniqueId: widget.addressModel?.customerUniqueId ??
                      AppStrings.emptyString,
                  id: widget.addressModel?.id,
                ));
              } else {
                Navigator.popAndPushNamed(
                    context, ChooseCategoryScreen.routeName,
                    arguments: {
                      "address": SaveAddressReqBodyModel(
                        name: nameController.text,
                        house: AppStrings.emptyString,
                        building: flatNoController.text,
                        street: areaController.text,
                        district: cityController.text,
                        county: stateController.text,
                        country: countryController.text,
                        zipcode: pinCodeController.text,
                        latitude: widget.addressModel!.latitude,
                        longitude: widget.addressModel!.longitude,
                        altitude: widget.addressModel!.altitude,
                        addressType: selectedAddressType,
                        isDefault: false,
                      ),
                      "categoryObj": widget.categoryObj,
                    });
              }
            } else if (state is SaveAddressErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            } else if (state is SaveAddressCompleteState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
              BlocProvider.of<AddressCubit>(context, listen: false)
                  .fetchAddress();

              Future.delayed(const Duration(seconds: 1), () {
                if (widget.isForUpdateAddress || widget.isSavedAddress) {
                  Navigator.pop(context);
                } else {
                  Navigator.popAndPushNamed(
                      context, ChooseCategoryScreen.routeName,
                      arguments: {
                        "address": SaveAddressReqBodyModel(
                          name: nameController.text,
                          house: AppStrings.emptyString,
                          building: flatNoController.text,
                          street: areaController.text,
                          district: cityController.text,
                          county: stateController.text,
                          country: countryController.text,
                          zipcode: pinCodeController.text,
                          latitude: widget.addressModel!.latitude,
                          longitude: widget.addressModel!.longitude,
                          altitude: widget.addressModel!.altitude,
                          addressType: selectedAddressType,
                          isDefault: false,
                        ),
                        "categoryObj": widget.categoryObj,
                      });
                }
              });
            }
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 18.sh),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Name
                    AppTextLabelFormWidget(
                      labelText: AppStrings.name.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: nameController,
                      maxLength: 50,
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
                      readOnly: false,
                    ),
                    SizedBox(height: 18.sh),

                    /// State
                    AppTextLabelFormWidget(
                      labelText: AppStrings.state.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: stateController,
                      maxLength: 25,
                      readOnly: stateController.text.isNotEmpty,
                    ),
                    SizedBox(height: 18.sh),

                    AppTextLabelFormWidget(
                      labelText: AppStrings.zipCode.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: pinCodeController,
                      maxLength: 10,
                      textFormFieldType: TextFormFieldType.postalCode,
                      readOnly: false,
                    ),
                    SizedBox(height: 18.sh),

                    /// Country
                    AppTextLabelFormWidget(
                      labelText: AppStrings.country.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: countryController,
                      maxLength: 25,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              TypeOfAddressWidget(
                list: _list,
                onSelect: (obj) {
                  onSelect(obj);
                },
              ),
              (widget.isForUpdateAddress || widget.isSavedAddress)
                  ? const Offstage()
                  : AppCheckBoxWidget(
                      text: AppStrings.saveThisAddress,
                      onTap: (value) => isSaveThisAddress = value),
              SizedBox(height: widget.isForUpdateAddress ? 0.sh : 20.sh),
              Divider(
                thickness: 5.sh,
                color: AppColors.appGrey,
              ),
              Padding(
                padding: EdgeInsets.all(20.sw),
                child: isLoading
                    ? const AppLoadingWidget()
                    : BottomButtonWidget(
                        buttonTitle: widget.isForUpdateAddress
                            ? AppStrings.update
                            : AppStrings.proceed,
                        buttonBGColor: AppColors.black,
                        onPressed: () =>
                            saveAddressBloc.add(SaveAddressValidationEvent(
                          nameController: nameController.text,
                          pinCodeController: pinCodeController.text,
                          cityController: cityController.text,
                          stateController: stateController.text,
                          countryController: countryController.text,
                          flatNoController: flatNoController.text,
                          areaController: areaController.text,
                        )),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
