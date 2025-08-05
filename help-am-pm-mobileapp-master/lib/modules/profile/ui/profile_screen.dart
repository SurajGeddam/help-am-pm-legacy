import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/onboarding/ui/widgets/is_mandatory_text_label_widget.dart';
import 'package:helpampm/modules/onboarding/ui/widgets/upload_icon_widget.dart';
import 'package:helpampm/modules/profile/bloc/save_profile_bloc/save_profile_bloc.dart';
import 'package:helpampm/modules/profile/bloc/save_profile_bloc/save_profile_event.dart';
import 'package:helpampm/modules/profile/bloc/save_profile_bloc/save_profile_state.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/all_country_bloc/all_country_bloc.dart';
import '../../../core/services/bloc/all_country_bloc/all_country_state.dart';
import '../../../core/services/bloc/upload_file_bloc/upload_file_cubit.dart';
import '../../../core/services/bloc/upload_file_bloc/upload_file_state.dart';
import '../../../core/services/media/media_service.dart';
import '../../../core/services/media/uoload_file_model.dart';
import '../../../core/services/model/country_code_model.dart';
import '../../../core/services/service_locator.dart';
import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/upload_pic_dialog_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_strings.dart';
import '../../app_drawer/bloc/user_dto_cubit.dart';
import '../../login/model/login_model/auth_token_model.dart';
import '../../onboarding/ui/widgets/uploaded_image_widget.dart';
import '../bloc/provider_profile_cubit/provider_profile_cubit.dart';
import '../bloc/provider_profile_cubit/provider_profile_state.dart';
import '../model/provider_profile_model.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/ProfileScreen";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SaveProfileBloc saveProfileBloc;
  final MediaService _mediaService = getIt<MediaService>();

  bool isRoleCustomer = AppUtils.getIsRoleCustomer();
  String? profilePicturePath;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();

  late UploadFileCubit uploadFileCubit;
  late ProfileCubit profileCubit;
  late UserDtoCubit userDtoCubit;

  bool isLoading = false;
  bool isLoadingForUploadFile = false;

  File? imageFile;
  String imagePath = AppStrings.emptyString;
  String imageBytes = AppStrings.emptyString;
  String countryCode = AppStrings.emptyString;
  UserDetailsDto? userDetailsDto;

  ProfileModel profileModel = ProfileModel();
  bool isOTPSent = false;

  late GetAllCountryCodeBloc getAllCountryCodeBloc;
  List<CountryCodeModel> countyCodeList = [];

  Future<void> getData() async {
    userDetailsDto = await userDtoCubit.getRecord();
  }

  @override
  void initState() {
    userDtoCubit = BlocProvider.of<UserDtoCubit>(context, listen: false);
    getData();

    profileCubit = BlocProvider.of<ProfileCubit>(context, listen: false);
    profileCubit.fetchProfile();

    uploadFileCubit = BlocProvider.of<UploadFileCubit>(context);
    saveProfileBloc = BlocProvider.of<SaveProfileBloc>(context);

    getAllCountryCodeBloc = GetAllCountryCodeBloc();
    getAllCountryCodeBloc.getAllCountryCode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        appTitle: AppStrings.editProfile,
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetAllCountryCodeBloc, GetAllCountryCodeState>(
              bloc: getAllCountryCodeBloc,
              listener: (ctx, state) {
                if (state is GetAllCountryCodeLoadedState) {
                  countyCodeList = state.list;
                  countryCode = countyCodeList.first.dialCode!;
                }
              },
              child: const Offstage(),
            )
          ],
          child: BlocBuilder<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            builder: (ctx, state) {
              if (state is ProfileErrorState) {
                return AppErrorMessageWidget(
                  errorMessage: state.errorMessage,
                  textColor: state.bgColor,
                );
              } else if (state is ProfileLoadedState) {
                profileModel = state.providerProfile;
                _name.text = profileModel.name;
                _firstName.text = profileModel.firstName;
                _lastName.text = profileModel.lastName;
                _email.text = profileModel.email;
                String fullMobileNumber = profileModel.mobileNumber;

                if (fullMobileNumber.contains(' ')) {
                  countryCode = fullMobileNumber.split(' ')[0];
                  _mobileNumber.text = fullMobileNumber.split(' ')[1];
                } else {
                  _mobileNumber.text = fullMobileNumber;
                }
                _dateOfBirth.text = profileModel.dateOfBirth;

                return ListView(
                  shrinkWrap: true,
                  children: [
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
                            imageBytes = state.responseModel.uploadImageBytes ??
                                AppStrings.emptyString;
                          });
                        }
                      },
                      child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                              left: 20.sh, right: 20.sw, top: 20.sh),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const AppTextLabelFormWidget(
                                labelText: AppStrings.profilePic,
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
                                            imageBytes = AppStrings.emptyString;
                                          }),
                                        )),
                            ],
                          )),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            left: 20.sh, right: 20.sw, top: 20.sh),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            /*if (profileModel.profilePicture.isNotEmpty)
                              Image.network(
                                profileModel.profilePicture,
                                alignment: Alignment.centerLeft,
                                height: 118.sh,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),*/
                            if (profileModel.imageBytes.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.memory(
                                  AppUtils.convertImage(
                                      profileModel.imageBytes),
                                  fit: BoxFit.fill,
                                  alignment: Alignment.centerLeft,
                                  width: AppUtils.deviceWidth * 0.5,
                                ),
                              ),
                            SizedBox(height: 18.sh),
                            if (isRoleCustomer) ...[
                              /// First Name
                              AppTextLabelFormWidget(
                                labelText: AppStrings.firstName.toUpperCase(),
                                isMandatory: true,
                              ),
                              AppTextFieldFormWidget(
                                textController: _firstName,
                                maxLength: 50,
                              ),
                              SizedBox(height: 18.sh),

                              /// Last Name
                              AppTextLabelFormWidget(
                                labelText: AppStrings.lastName.toUpperCase(),
                                isMandatory: true,
                              ),
                              AppTextFieldFormWidget(
                                textController: _lastName,
                                maxLength: 50,
                              ),
                              SizedBox(height: 18.sh),

                              /// Todo: Date Of Birth for next release
                              /*AppTextLabelFormWidget(
                                labelText: AppStrings.dateOfBirth.toUpperCase(),
                                isMandatory: false,
                              ),
                              AppTextFieldFormWidget(
                                textController: _dateOfBirth,
                                isDateField: true,
                                readOnly: true,
                              ),
                              SizedBox(height: 18.sh),*/
                            ] else ...[
                              /// Name
                              AppTextLabelFormWidget(
                                labelText: AppStrings.name.toUpperCase(),
                                isMandatory: true,
                              ),
                              AppTextFieldFormWidget(
                                textController: _name,
                                maxLength: 50,
                              ),
                              SizedBox(height: 18.sh),
                            ],

                            /// Email Address
                            AppTextLabelFormWidget(
                              labelText: AppStrings.emailAddress.toUpperCase(),
                              isMandatory: true,
                            ),
                            AppTextFieldFormWidget(
                              textController: _email,
                              maxLength: 50,
                              readOnly: true,
                            ),
                            SizedBox(height: 18.sh),

                            /// Mobile Number
                            AppTextLabelFormWidget(
                              labelText: AppStrings.mobileNumber.toUpperCase(),
                              isMandatory: true,
                            ),
                            Row(
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
                                    textController: _mobileNumber,
                                    maxLength: 10,
                                    textFormFieldType: TextFormFieldType.phone,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.sh),
                              child: const IsMandatoryTextLabelWidget(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocListener<SaveProfileBloc, SaveProfileState>(
                        bloc: saveProfileBloc,
                        listener: (ctx, state) {
                          if (state is SaveProfileValidState) {
                            if (isRoleCustomer) {
                              saveProfileBloc.add(
                                  SaveCustomerProfileSubmittedEvent(
                                      profilePicturePath: imagePath,
                                      firstNameController: _firstName.text,
                                      lastNameController: _lastName.text,
                                      emailController: _email.text,
                                      mobileNumberController:
                                          '$countryCode ${_mobileNumber.text}'));
                            } else {
                              saveProfileBloc.add(
                                  SaveProviderProfileSubmittedEvent(
                                      profilePicturePath: imagePath,
                                      nameController: _name.text,
                                      emailController: _email.text,
                                      mobileNumberController:
                                          '$countryCode ${_mobileNumber.text}'));
                            }
                          } else if (state is SaveProfileErrorState) {
                            AppUtils.showSnackBar(state.errorMessage,
                                bgColor: state.bgColor);
                          } else if (state is SaveProfileCompleteState) {
                            if (userDetailsDto != null) {
                              userDetailsDto?.name = isRoleCustomer
                                  ? ("${_firstName.text} ${_lastName.text}")
                                  : _name.text;
                              userDetailsDto?.phone =
                                  '$countryCode ${_mobileNumber.text}';
                              userDetailsDto?.profilePicture = imagePath;
                              userDetailsDto?.profileBytes = imageBytes;
                              userDtoCubit.setUserData(userDetailsDto!);
                            }
                            AppUtils.showSnackBar(state.message,
                                bgColor: state.bgColor);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 24.sh, left: 20.sw, right: 20.sw),
                            child: BottomButtonWidget(
                                buttonTitle: AppStrings.save,
                                buttonBGColor: AppColors.black,
                                onPressed: () => {
                                      saveProfileBloc.add(
                                        isRoleCustomer
                                            ? SaveCustomerProfileValidationEvent(
                                                firstNameController:
                                                    _firstName.text,
                                                lastNameController:
                                                    _lastName.text,
                                                emailController: _email.text,
                                                mobileNumberController:
                                                    _mobileNumber.text)
                                            : SaveProviderProfileValidationEvent(
                                                nameController: _name.text,
                                                emailController: _email.text,
                                                mobileNumberController:
                                                    _mobileNumber.text),
                                      ),
                                    }),
                          ),
                        )),
                  ],
                );
              }
              return const AppLoadingWidget();
            },
          ),
        ),
      ),
    );
  }

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
            purpose: FileUploadPurpose.userProfile.name,
            replace: true),
      );
    }
  }
}
