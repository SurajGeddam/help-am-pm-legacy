import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/onboarding/ui/bank_information_screen.dart';
import 'package:helpampm/modules/onboarding/ui/widgets/is_mandatory_text_label_widget.dart';
import 'package:helpampm/modules/onboarding/ui/widgets/upload_icon_widget.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../core/services/bloc/loading_indicator_bloc.dart';
import '../../../core/services/bloc/upload_file_bloc/upload_file_cubit.dart';
import '../../../core/services/bloc/upload_file_bloc/upload_file_state.dart';
import '../../../core/services/media/media_service.dart';
import '../../../core/services/media/uoload_file_model.dart';
import '../../../core/services/service_locator.dart';
import '../../../core_components/common_screens/loading_indicator_screen.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/upload_pic_dialog_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import '../../app_drawer/bloc/logout_cubit.dart';
import '../bloc/vehicle_bloc/vehicle_bloc.dart';
import '../bloc/vehicle_bloc/vehicle_event.dart';
import '../bloc/vehicle_bloc/vehicle_state.dart';
import '../model/common/policy_type_model.dart';
import 'widgets/horizontal_stepper_widget.dart';
import 'widgets/uploaded_image_widget.dart';

class VehicleInformationScreen extends StatefulWidget {
  static const String routeName = "/VehicleInformationScreen";

  const VehicleInformationScreen({Key? key}) : super(key: key);

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  final MediaService _mediaService = getIt<MediaService>();

  final TextEditingController vehicleMake = TextEditingController();
  final TextEditingController vehicleModel = TextEditingController();
  final TextEditingController vehicleVIN = TextEditingController();
  final TextEditingController vehicleLicensePlate = TextEditingController();
  final TextEditingController vehicleInsuranceCarrier = TextEditingController();
  final TextEditingController vehicleInsurancePolicy = TextEditingController();
  final TextEditingController vehicleInsurancePolicyAccountHolder =
      TextEditingController();

  final TextEditingController vehicleInsuranceExpirationDate =
      TextEditingController();

  late VehicleBloc vehicleBloc;
  late UploadFileCubit uploadFileCubit;

  late LoadingIndicatorBloc loadingIndicatorBloc;
  late LogoutCubit logoutCubit;

  bool isLoading = false;
  bool isLoadingForPolicyType = false;
  bool isLoadingForUploadFile = false;

  File? imageFile;
  String imagePath = AppStrings.emptyString;

  List<PolicyTypeModel> loadedList = [];
  PolicyTypeModel? policyTypeObj;

  Widget uploadFileWidget() {
    return GestureDetector(
      onTap: () => {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return UploadPicDialogWidget(
              onCloseBtn: () => Navigator.pop(context),
              onSelected: (AppImageSource appImageSource) {
                AppUtils.debugPrint("Selected : $appImageSource");
                Navigator.pop(context);
                _getImage(appImageSource);
              },
            );
          },
        )
      },
      child: const UploadIconWidget(),
    );
  }

  Future _getImage(AppImageSource appImageSource) async {
    final pickedImageFile = await _mediaService
        .uploadImage(context, appImageSource, shouldCompress: false);
    if (pickedImageFile != null) {
      setState(() => imageFile = pickedImageFile);
      await uploadFileCubit.upLoadFile(
        file: pickedImageFile,
        uploadFile: UploadFileModel(
            fileName: AppUtils.getUploadFileName(pickedImageFile.path),
            purpose: FileUploadPurpose.providerInsurance.name,
            replace: true),
      );
    }
  }

  setData() {
    uploadFileCubit = BlocProvider.of<UploadFileCubit>(context);
    vehicleBloc = BlocProvider.of<VehicleBloc>(context);
    vehicleBloc.add(VehicleGetDataEvent());

    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);

    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = true;
      if (InputFormType.vehicle.code ==
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
    vehicleMake.dispose();
    vehicleModel.dispose();
    vehicleVIN.dispose();
    vehicleLicensePlate.dispose();

    vehicleInsuranceCarrier.dispose();
    vehicleInsurancePolicy.dispose();
    vehicleInsurancePolicyAccountHolder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutCubitState>(
      listener: (_, state) {
        if (state == LogoutCubitState.loading) {
          loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingStarted);
        } else if (state == LogoutCubitState.loaded) {
          loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingFinished);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AppScaffoldWidget(
              appTitle: AppStrings.vehicleInformation,
              isBackShow: false,
              isLogoutShow: true,
              onLogoutPressed: () => logoutCubit.logoutApi(),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<VehicleBloc, VehicleState>(
                    bloc: vehicleBloc,
                    listener: (ctx, state) {
                      if (state is VehicleDataLoadingState) {
                        setState(() => isLoadingForPolicyType = true);
                      } else if (state is VehicleDataLoadedState) {
                        setState(() => isLoadingForPolicyType = false);
                        loadedList = state.list;
                        if (loadedList.isNotEmpty) {
                          policyTypeObj = PolicyTypeModel(
                            id: loadedList[3].id,
                            name: loadedList[3].name,
                            isActive: loadedList[3].isActive,
                          );
                        }
                      } else if (state is VehicleLoadingState) {
                        setState(() => isLoading = true);
                      } else if (state is VehicleValidState) {
                        vehicleBloc.add(VehicleSubmittedEvent(
                          policyType: policyTypeObj,
                          vehicleMake: vehicleMake.text,
                          vehicleModel: vehicleModel.text,
                          vehicleVIN: vehicleVIN.text,
                          vehicleLicensePlate: vehicleLicensePlate.text,
                          vehicleInsuranceCarrier: vehicleInsuranceCarrier.text,
                          vehicleInsurancePolicy: vehicleInsurancePolicy.text,
                          vehicleInsuranceExpirationDate:
                              AppUtils.saveDateToServer(
                                  vehicleInsuranceExpirationDate.text),
                          vehicleInsurancePolicyAccountHolder:
                              vehicleInsurancePolicyAccountHolder.text,
                          imagePath: imagePath,
                        ));
                        setState(() => isLoading = false);
                      } else if (state is VehicleErrorState) {
                        setState(() => isLoading = false);
                        AppUtils.showSnackBar(state.errorMessage,
                            bgColor: state.bgColor);
                      } else if (state is VehicleCompleteState) {
                        AppUtils.showSnackBar(state.message,
                            bgColor: state.bgColor);
                        Future.delayed(
                            Duration.zero,
                            () => Navigator.pushReplacementNamed(
                                context, BankInformationScreen.routeName));
                        return;
                      }
                    },
                  ),
                  BlocListener<UploadFileCubit, UploadFileState>(
                      bloc: uploadFileCubit,
                      listener: (ctx, state) {
                        if (state is UploadFileLoadingState) {
                          setState(() => isLoadingForUploadFile = true);
                        } else if (state is UploadFileErrorState) {
                          setState(() {
                            isLoadingForUploadFile = false;
                            imageFile = null;
                            imagePath = AppStrings.emptyString;
                          });

                          Future.delayed(
                              Duration.zero,
                              () => AppUtils.showSnackBar(state.errorMessage,
                                  bgColor: state.bgColor));
                        } else if (state is UploadFileCompleteState) {
                          setState(() {
                            isLoadingForUploadFile = false;
                            imageFile = state.imageFile;
                            imagePath = state.responseModel.uploadedPath ??
                                AppStrings.emptyString;
                          });
                        }
                      }),
                ],
                child: isLoadingForPolicyType
                    ? const AppLoadingWidget()
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: 20.sh, right: 20.sw, top: 20.sh),
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Text(
                            AppStrings.companyOrIndividualVehicleInformation,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 16.fs,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 28.sh),
                            child: HorizontalStepperWidget(
                              userInputDetailList:
                                  AppMockList.userInputDetailList,
                            ),
                          ),

                          /// Vehicle Make
                          AppTextLabelFormWidget(
                            labelText: AppStrings.vehicleMake.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleMake,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Vehicle Model
                          AppTextLabelFormWidget(
                            labelText: AppStrings.vehicleModel.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleModel,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Vehicle VIN
                          AppTextLabelFormWidget(
                            labelText: AppStrings.vehicleVIN.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleVIN,
                          ),
                          SizedBox(height: 24.sh),

                          /// Vehicle License Plate
                          AppTextLabelFormWidget(
                            labelText:
                                AppStrings.vehicleLicensePlate.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleLicensePlate,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company policy type
                          /*AppTextLabelFormWidget(
                            labelText: AppStrings.policyType.toUpperCase(),
                            isMandatory: true,
                          ),
                          loadedList.isEmpty
                              ? const Offstage()
                              : AppDropdownWidget(
                                  list: loadedList,
                                  onSelect: (value) => policyTypeObj = value),
                          SizedBox(height: 24.sh),*/

                          /// Vehicle Insurance Carrier
                          AppTextLabelFormWidget(
                            labelText: AppStrings.vehicleInsuranceCarrier
                                .toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleInsuranceCarrier,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Vehicle Insurance Policy
                          AppTextLabelFormWidget(
                            labelText:
                                AppStrings.vehicleInsurancePolicy.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleInsurancePolicy,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Vehicle Insurance Policy
                          AppTextLabelFormWidget(
                            labelText: AppStrings
                                .vehicleInsurancePolicyAccountHolder
                                .toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: vehicleInsurancePolicyAccountHolder,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Vehicle Insurance Expiration Date
                          AppTextLabelFormWidget(
                            labelText: AppStrings.vehicleInsuranceExpirationDate
                                .toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            isDateField: true,
                            textController: vehicleInsuranceExpirationDate,
                            readOnly: true,
                            isExpirationCondition: true,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company Trade License Pic
                          const AppTextLabelFormWidget(
                            labelText: AppStrings.insurancePic,
                            isMandatory: false,
                          ),
                          (imageFile == null)
                              ? uploadFileWidget()
                              : (isLoadingForUploadFile
                                  ? const AppLoadingWidget()
                                  : UploadedImageWidget(
                                      imageFile: imageFile,
                                      callback: () => setState(() {
                                        imageFile = null;
                                        imagePath = AppStrings.emptyString;
                                      }),
                                    )),

                          /*/// Add Another Vehicle
                          const AppTextLabelFormWidget(labelText: AppStrings.addAnotherVehicle),

                          Divider(
                            height: 1.sh,
                            thickness: 1.sh,
                            color: AppColors.dividerColor,
                          ),*/

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.sh),
                            child: const IsMandatoryTextLabelWidget(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.sh),
                            child: isLoading
                                ? const AppLoadingWidget()
                                : BottomButtonWidget(
                                    buttonTitle: AppStrings.next,
                                    buttonBGColor: AppColors.black,
                                    onPressed: () => vehicleBloc.add(
                                      VehicleValidationEvent(
                                          vehicleMake: vehicleMake.text,
                                          vehicleModel: vehicleModel.text,
                                          vehicleVIN: vehicleVIN.text,
                                          vehicleLicensePlate:
                                              vehicleLicensePlate.text,
                                          vehicleInsuranceCarrier:
                                              vehicleInsuranceCarrier.text,
                                          vehicleInsurancePolicy:
                                              vehicleInsurancePolicy.text,
                                          vehicleInsuranceExpirationDate:
                                              vehicleInsuranceExpirationDate
                                                  .text,
                                          vehicleInsurancePolicyAccountHolder:
                                              vehicleInsurancePolicyAccountHolder
                                                  .text),
                                    ),
                                  ),
                          )
                        ],
                      ),
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
