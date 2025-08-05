import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/all_country_bloc/all_country_bloc.dart';
import '../../../core/services/bloc/all_country_bloc/all_country_state.dart';
import '../../../core/services/model/country_code_model.dart';
import '../../../core_components/common_widgets/app_checkbox_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/bottom_container_widget.dart';
import '../../../core_components/common_widgets/text_field_with_bg_widget.dart';
import '../../../core_components/common_widgets/top_yellow_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_enum.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/register_bloc/register_event.dart';
import '../bloc/register_bloc/register_state.dart';
import 'login_screen.dart';
import 'widgets/already_have_ac_text_widget.dart';
import 'widgets/tnc_message_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/RegisterScreen";
  final String keyValue;

  const RegisterScreen({
    Key? key,
    required this.keyValue,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController employerCodeController = TextEditingController();

  late RegisterBloc registerBloc;
  bool isLoading = false;
  bool selectUserIsCustomer = false;
  bool isMandatoryProviderEmployee = false;

  late GetAllCountryCodeBloc getAllCountryCodeBloc;
  List<CountryCodeModel> countyCodeList = [];
  String countryCode = AppStrings.emptyString;

  @override
  void initState() {
    registerBloc = RegisterBloc();
    selectUserIsCustomer = (widget.keyValue == AppConstants.customer);

    getAllCountryCodeBloc = GetAllCountryCodeBloc();
    getAllCountryCodeBloc.getAllCountryCode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        scaffoldBgColor: AppColors.appYellow,
        appBarBgColor: AppColors.appYellow,
        isDividerShow: false,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            const TopYellowWidget(title: AppStrings.register),
            BlocListener<RegisterBloc, RegisterState>(
              bloc: registerBloc,
              listener: (ctx, state) {
                if (state is RegisterLoadingState) {
                  setState(() => isLoading = true);
                } else if (state is RegisterValidState) {
                  registerBloc.add(RegisterSubmittedEvent(
                    selectUserIsCustomer: selectUserIsCustomer,
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    phoneNumber:
                        "$countryCode ${phoneNumberController.text.trim()}",
                    emailValue: emailController.text.trim(),
                    passwordValue: passwordController.text.trim(),
                    confirmPasswordValue: confirmPasswordController.text.trim(),
                    employerCode:
                        employerCodeController.text.trim().toUpperCase(),
                    isMandatoryProviderEmployee: isMandatoryProviderEmployee,
                  ));
                } else if (state is RegisterErrorState) {
                  setState(() => isLoading = false);
                  AppUtils.showSnackBar(state.errorMessage,
                      bgColor: state.bgColor);
                } else if (state is RegisterCompleteState) {
                  setState(() => isLoading = false);
                  AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
                  Future.delayed(
                      const Duration(seconds: 1),
                      () => Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName,
                          (Route<dynamic> route) => false));
                }
              },
              child: BottomContainerWidget(
                child: BlocBuilder<GetAllCountryCodeBloc,
                        GetAllCountryCodeState>(
                    bloc: getAllCountryCodeBloc,
                    builder: (context, state) {
                      if (state is GetAllCountryCodeLoadedState) {
                        countyCodeList = state.list;
                        countryCode = countyCodeList.first.dialCode!;
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 46.sh),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.sw),
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  // -------------- START customer UI ------------
                                  selectUserIsCustomer
                                      ? ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            TextFieldWithBgWidget(
                                              textFieldIcon:
                                                  AppAssets.userLogoSvgIcon,
                                              hintText: AppStrings.firstName,
                                              textController:
                                                  firstNameController,
                                              textFormFieldType:
                                                  TextFormFieldType.name,
                                            ),
                                            SizedBox(height: 18.sh),
                                            TextFieldWithBgWidget(
                                              textFieldIcon:
                                                  AppAssets.userLogoSvgIcon,
                                              hintText: AppStrings.lastName,
                                              textController:
                                                  lastNameController,
                                              textFormFieldType:
                                                  TextFormFieldType.name,
                                            ),
                                            SizedBox(height: 18.sh),
                                            TextFieldWithBgWidget(
                                              textFieldIcon:
                                                  AppAssets.callIconSvg,
                                              hintText: AppStrings.mobileNumber,
                                              textController:
                                                  phoneNumberController,
                                              textFormFieldType:
                                                  TextFormFieldType.phone,
                                              isDropdownButton: true,
                                              countyCodeList: countyCodeList,
                                              onSelectCountryCode: (value) {
                                                countryCode = value;
                                              },
                                            ),
                                            SizedBox(height: 18.sh),
                                          ],
                                        )
                                      : const Offstage(),
                                  // -------------- END customer UI ------------
                                  TextFieldWithBgWidget(
                                    textFieldIcon: AppAssets.emailSvgIcon,
                                    hintText: AppStrings.emailId,
                                    textController: emailController,
                                    textFormFieldType: TextFormFieldType.email,
                                  ),
                                  SizedBox(height: 18.sh),
                                  TextFieldWithBgWidget(
                                    textFieldIcon: AppAssets.passwordSvgIcon,
                                    hintText: AppStrings.password,
                                    textController: passwordController,
                                    isObscureText: true,
                                  ),
                                  SizedBox(height: 18.sh),
                                  TextFieldWithBgWidget(
                                    textFieldIcon: AppAssets.passwordSvgIcon,
                                    hintText: AppStrings.confirmPassword,
                                    textController: confirmPasswordController,
                                    isObscureText: true,
                                  ),

                                  // -------------- START Employee UI ------------
                                  selectUserIsCustomer
                                      ? const Offstage()
                                      : ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            SizedBox(height: 18.sh),
                                            isMandatoryProviderEmployee
                                                ? TextFieldWithBgWidget(
                                                    textFieldIcon: AppAssets
                                                        .userLogoSvgIcon,
                                                    hintText:
                                                        AppStrings.employerCode,
                                                    textController:
                                                        employerCodeController,
                                                    textFormFieldType:
                                                        TextFormFieldType
                                                            .employer,
                                                    maxLength: 12,
                                                  )
                                                : const Offstage(),
                                            SizedBox(
                                                height:
                                                    isMandatoryProviderEmployee
                                                        ? 20.sh
                                                        : 0.sh),
                                            AppCheckBoxWidget(
                                              text:
                                                  AppStrings.registerAsEmployee,
                                              onTap: (value) {
                                                setState(() =>
                                                    isMandatoryProviderEmployee =
                                                        value);
                                                AppUtils.debugPrint(
                                                    "isSelected : $isMandatoryProviderEmployee");
                                              },
                                            ),
                                          ],
                                        ),
                                  // -------------- END Employee UI ------------

                                  SizedBox(height: 26.sh),
                                  const TnCMessageWidget(),
                                  SizedBox(height: 28.sh),
                                  isLoading
                                      ? const AppLoadingWidget()
                                      : BottomButtonWidget(
                                          buttonTitle: AppStrings.signUp,
                                          buttonBGColor: AppColors.black,
                                          onPressed: () {
                                            registerBloc
                                                .add(RegisterValidationEvent(
                                              selectUserIsCustomer:
                                                  selectUserIsCustomer,
                                              firstName:
                                                  firstNameController.text,
                                              lastName: lastNameController.text,
                                              phoneNumber:
                                                  phoneNumberController.text,
                                              emailValue: emailController.text,
                                              passwordValue:
                                                  passwordController.text,
                                              confirmPasswordValue:
                                                  confirmPasswordController
                                                      .text,
                                              employerCode:
                                                  employerCodeController.text,
                                              isMandatoryProviderEmployee:
                                                  isMandatoryProviderEmployee,
                                            ));
                                          },
                                        ),
                                ],
                              ),
                            ),
                            /*Padding(
                        padding: EdgeInsets.symmetric(vertical: 38.sh),
                        child: Divider(
                          height: 1.sh,
                          thickness: 1.sh,
                          color: AppColors.dividerColor,
                        ),
                      ),
                      const LoginBySocialWidget(),*/
                            const AlreadyHaveAcTextWidget(),
                          ],
                        );
                      }
                      return const AppLoadingWidget();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
