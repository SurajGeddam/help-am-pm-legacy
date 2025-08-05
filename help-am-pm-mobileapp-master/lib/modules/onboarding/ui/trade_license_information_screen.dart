import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../utils/app_text_styles.dart';
import '../../app_drawer/bloc/logout_cubit.dart';
import '../bloc/license_bloc/license_bloc.dart';
import '../bloc/license_bloc/license_event.dart';
import '../bloc/license_bloc/license_state.dart';
import '../model/common/policy_type_model.dart';
import 'vehicle_information_screen.dart';
import 'widgets/horizontal_stepper_widget.dart';
import 'widgets/is_mandatory_text_label_widget.dart';
import 'widgets/upload_icon_widget.dart';
import 'widgets/uploaded_image_widget.dart';

class TradeLicenseInformationScreen extends StatefulWidget {
  static const String routeName = "/TradeLicenseInformationScreen";

  const TradeLicenseInformationScreen({Key? key}) : super(key: key);

  @override
  State<TradeLicenseInformationScreen> createState() =>
      _TradeLicenseInformationScreenState();
}

class _TradeLicenseInformationScreenState
    extends State<TradeLicenseInformationScreen> {
  final MediaService _mediaService = getIt<MediaService>();

  final TextEditingController companyLicenseIssueAuthority =
      TextEditingController();
  final TextEditingController companyLicenseHolderName =
      TextEditingController();
  final TextEditingController companyLicenseRegisteredState =
      TextEditingController();
  final TextEditingController companyLicenseNumber = TextEditingController();

  final TextEditingController companyLicenseStartDate = TextEditingController();
  final TextEditingController companyLicenseExpiration =
      TextEditingController();
  final TextEditingController companyBusinessLicenseRegisteredSate =
      TextEditingController();
  final TextEditingController companyBusinessLicense = TextEditingController();
  final TextEditingController companyBusinessLicenseExpiration =
      TextEditingController();

  late LicenseBloc licenseBloc;
  late UploadFileCubit uploadFileCubit;

  late LoadingIndicatorBloc loadingIndicatorBloc;
  late LogoutCubit logoutCubit;

  List<PolicyTypeModel> loadedList = [];
  PolicyTypeModel? policyTypeObj;

  File? imageFile;
  String imagePath = AppStrings.emptyString;

  bool isLoading = false;
  bool isLoadingForPolicyType = false;
  bool isLoadingForUploadFile = false;

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
            purpose: FileUploadPurpose.providerLicense.name,
            replace: true),
      );
    }
  }

  void setData() {
    uploadFileCubit = BlocProvider.of<UploadFileCubit>(context);
    licenseBloc = BlocProvider.of<LicenseBloc>(context);
    licenseBloc.add(LicenseGetDataEvent());

    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);

    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = true;
      if (InputFormType.tradeLicense.code ==
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
    companyLicenseIssueAuthority.dispose();
    companyLicenseHolderName.dispose();
    companyLicenseRegisteredState.dispose();
    companyLicenseNumber.dispose();

    companyLicenseStartDate.dispose();
    companyLicenseExpiration.dispose();
    companyBusinessLicenseRegisteredSate.dispose();
    companyBusinessLicense.dispose();
    companyBusinessLicenseExpiration.dispose();
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
              appTitle: AppStrings.tradeLicense,
              isBackShow: false,
              isLogoutShow: true,
              onLogoutPressed: () => logoutCubit.logoutApi(),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<LicenseBloc, LicenseState>(
                    bloc: licenseBloc,
                    listener: (ctx, state) {
                      if (state is LicenseDataLoadingState) {
                        setState(() => isLoadingForPolicyType = true);
                      } else if (state is LicenseDataLoadedState) {
                        setState(() => isLoadingForPolicyType = false);
                        loadedList = state.list;
                        if (loadedList.isNotEmpty) {
                          policyTypeObj = PolicyTypeModel(
                            id: loadedList[1].id,
                            name: loadedList[1].name,
                            isActive: loadedList[1].isActive,
                          );
                        }
                      } else if (state is LicenseLoadingState) {
                        setState(() => isLoading = true);
                      } else if (state is LicenseValidState) {
                        licenseBloc.add(
                          LicenseSubmittedEvent(
                            licenseType: policyTypeObj!,
                            companyLicenseRegisteredState:
                                companyLicenseRegisteredState.text,
                            companyLicenseNumber: companyLicenseNumber.text,
                            companyLicenseStartDate: AppUtils.saveDateToServer(
                                    companyLicenseStartDate.text)
                                .toString(),
                            companyLicenseExpiration: AppUtils.saveDateToServer(
                                    companyLicenseExpiration.text)
                                .toString(),
                            companyLicenseHolderName:
                                companyLicenseHolderName.text,
                            issueAuthority: companyLicenseIssueAuthority.text,
                            imagePath: imagePath,
                          ),
                        );
                        setState(() => isLoading = false);
                      } else if (state is LicenseErrorState) {
                        setState(() => isLoading = false);
                        AppUtils.showSnackBar(state.errorMessage,
                            bgColor: state.bgColor);
                      } else if (state is LicenseCompleteState) {
                        AppUtils.showSnackBar(state.message,
                            bgColor: state.bgColor);
                        Future.delayed(
                            Duration.zero,
                            () => Navigator.pushReplacementNamed(
                                context, VehicleInformationScreen.routeName));
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
                            AppStrings.tradeIndividualIsTradeNBusiness,
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

                          /// Company TradeLicense Registered State
                          AppTextLabelFormWidget(
                            labelText: AppStrings.tradeLicenseRegisteredState
                                .toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: companyLicenseRegisteredState,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company Licence type
                          /*AppTextLabelFormWidget(
                            labelText:
                                AppStrings.tradeLicenseType.toUpperCase(),
                            isMandatory: true,
                          ),
                          loadedList.isEmpty
                              ? const Offstage()
                              : AppDropdownWidget(
                                  list: loadedList,
                                  onSelect: (value) => policyTypeObj = value),
                          SizedBox(height: 24.sh),*/

                          /// Company Licence issuing authority
                          AppTextLabelFormWidget(
                            labelText: AppStrings.tradeLicenseIssuingAuthority
                                .toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: companyLicenseIssueAuthority,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company Licence Holder name
                          AppTextLabelFormWidget(
                            labelText: AppStrings.tradeHolderName.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: companyLicenseHolderName,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company  License number
                          AppTextLabelFormWidget(
                            labelText:
                                AppStrings.tradeLicenseNumber.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            textController: companyLicenseNumber,
                            maxLength: 50,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company License Expiration
                          AppTextLabelFormWidget(
                            labelText:
                                AppStrings.tradeLicenseStartDate.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            isDateField: true,
                            readOnly: true,
                            textController: companyLicenseStartDate,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company License Expiration
                          AppTextLabelFormWidget(
                            labelText:
                                AppStrings.tradeLicenseExpiration.toUpperCase(),
                            isMandatory: true,
                          ),
                          AppTextFieldFormWidget(
                            isDateField: true,
                            readOnly: true,
                            textController: companyLicenseExpiration,
                            isExpirationCondition: true,
                          ),
                          SizedBox(height: 24.sh),

                          /// Company Trade License Pic
                          const AppTextLabelFormWidget(
                            labelText: AppStrings.tradeLicensePic,
                            isMandatory: true,
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
                                    onPressed: () => licenseBloc.add(
                                      LicenseValidationEvent(
                                        companyLicenseRegisteredState:
                                            companyLicenseRegisteredState.text,
                                        companyLicenseNumber:
                                            companyLicenseNumber.text,
                                        companyLicenseStartDate:
                                            companyLicenseStartDate.text,
                                        companyLicenseExpiration:
                                            companyLicenseExpiration.text,
                                        companyLicenseHolderName:
                                            companyLicenseHolderName.text,
                                        issueAuthority:
                                            companyLicenseIssueAuthority.text,
                                        imagePath: imagePath,
                                      ),
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
