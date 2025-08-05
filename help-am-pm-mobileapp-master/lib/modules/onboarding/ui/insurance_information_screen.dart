import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/onboarding/ui/license_information_screen.dart';
import 'package:helpampm/modules/onboarding/ui/widgets/app_drop_down_widget.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/loading_indicator_bloc.dart';
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
import '../../../utils/app_text_styles.dart';
import '../../app_drawer/bloc/logout_cubit.dart';
import '../bloc/insurance_bloc/insurance_bloc.dart';
import '../bloc/insurance_bloc/insurance_event.dart';
import '../bloc/insurance_bloc/insurance_state.dart';
import '../model/common/policy_type_model.dart';
import 'widgets/horizontal_stepper_widget.dart';
import 'widgets/is_mandatory_text_label_widget.dart';

class InsuranceInformationScreen extends StatefulWidget {
  static const String routeName = "/InsuranceInformationScreen";

  const InsuranceInformationScreen({Key? key}) : super(key: key);

  @override
  State<InsuranceInformationScreen> createState() =>
      _InsuranceInformationScreenState();
}

class _InsuranceInformationScreenState
    extends State<InsuranceInformationScreen> {
  final TextEditingController companyGeneralLiabilityInsCarrier =
      TextEditingController();
  final TextEditingController policyHolderName = TextEditingController();
  final TextEditingController companyPolicyNumber = TextEditingController();
  final TextEditingController companyGLPolicyExpirationDate =
      TextEditingController();

  late InsuranceBloc insuranceBloc;
  bool isLoading = false;
  List<PolicyTypeModel> loadedList = [];
  PolicyTypeModel? policyTypeObj;

  late LoadingIndicatorBloc loadingIndicatorBloc;
  late LogoutCubit logoutCubit;

  setData() {
    insuranceBloc = BlocProvider.of<InsuranceBloc>(context);
    insuranceBloc.add(InsuranceGetDataEvent());

    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);

    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = true;
      if (InputFormType.insurance.code ==
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
    companyGeneralLiabilityInsCarrier.dispose();
    policyHolderName.dispose();
    companyPolicyNumber.dispose();
    companyGLPolicyExpirationDate.dispose();
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
              appTitle: AppStrings.insuranceInformation,
              isBackShow: false,
              isLogoutShow: true,
              onLogoutPressed: () => logoutCubit.logoutApi(),
              child: BlocConsumer<InsuranceBloc, InsuranceState>(
                bloc: insuranceBloc,
                listener: (ctx, state) {
                  if (state is InsuranceLoadingState) {
                    setState(() => isLoading = true);
                  } else if (state is InsuranceValidState) {
                    insuranceBloc.add(
                      InsuranceSubmittedEvent(
                        companyGeneralLiabilityInsCarrier:
                            companyGeneralLiabilityInsCarrier.text,
                        companyPolicyNumber: companyPolicyNumber.text,
                        policyType: policyTypeObj!,
                        policyHolderName: policyHolderName.text,
                        companyGLPolicyExpirationDate:
                            AppUtils.saveDateToServer(
                                companyGLPolicyExpirationDate.text),
                      ),
                    );
                    setState(() => isLoading = false);
                  } else if (state is InsuranceErrorState) {
                    setState(() => isLoading = false);
                    AppUtils.showSnackBar(state.errorMessage,
                        bgColor: state.bgColor);
                  } else if (state is InsuranceCompleteState) {
                    AppUtils.showSnackBar(state.message,
                        bgColor: state.bgColor);
                    Future.delayed(
                        Duration.zero,
                        () => Navigator.pushReplacementNamed(
                            context, LicenseInformationScreen.routeName));
                    return;
                  }
                },
                builder: (ctx, state) {
                  if (state is InsuranceDataLoadingState) {
                    return const AppLoadingWidget();
                  } else if (state is InsuranceDataLoadedState) {
                    loadedList = state.list;
                    if (loadedList.isNotEmpty) {
                      policyTypeObj = PolicyTypeModel(
                        id: loadedList[0].id,
                        name: loadedList[0].name,
                        isActive: loadedList[0].isActive,
                      );
                    }
                  }
                  return ListView(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.only(left: 20.sh, right: 20.sw, top: 20.sh),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Text(
                        AppStrings.companyIsInsuranceInformation,
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

                      /// Company General Liability Ins Carrier
                      AppTextLabelFormWidget(
                        labelText: AppStrings.companyGeneralLiabilityInsCarrier
                            .toUpperCase(),
                        isMandatory: true,
                      ),
                      AppTextFieldFormWidget(
                        textController: companyGeneralLiabilityInsCarrier,
                        maxLength: 50,
                      ),
                      SizedBox(height: 24.sh),

                      AppTextLabelFormWidget(
                        labelText: AppStrings.policyHolderName.toUpperCase(),
                        isMandatory: true,
                      ),
                      AppTextFieldFormWidget(
                        textController: policyHolderName,
                        maxLength: 50,
                      ),
                      SizedBox(height: 24.sh),

                      /// Company policy type
                      AppTextLabelFormWidget(
                        labelText: AppStrings.policyType.toUpperCase(),
                        isMandatory: true,
                      ),
                      loadedList.isEmpty
                          ? const Offstage()
                          : AppDropdownWidget(
                              list: loadedList,
                              onSelect: (value) => policyTypeObj = value),
                      SizedBox(height: 24.sh),

                      /// Company PolicyNumber
                      AppTextLabelFormWidget(
                        labelText: AppStrings.companyPolicyNumber.toUpperCase(),
                        isMandatory: true,
                      ),
                      AppTextFieldFormWidget(
                        textController: companyPolicyNumber,
                        maxLength: 50,
                      ),
                      SizedBox(height: 24.sh),

                      /// Company GL Policy Expiration Date
                      AppTextLabelFormWidget(
                        labelText: AppStrings.companyGLPolicyExpirationDate
                            .toUpperCase(),
                        isMandatory: true,
                      ),
                      AppTextFieldFormWidget(
                        isDateField: true,
                        readOnly: true,
                        textController: companyGLPolicyExpirationDate,
                        isExpirationCondition: true,
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
                                onPressed: () => insuranceBloc.add(
                                  InsuranceValidationEvent(
                                    companyGeneralLiabilityInsCarrier:
                                        companyGeneralLiabilityInsCarrier.text,
                                    companyPolicyNumber:
                                        companyPolicyNumber.text,
                                    policyHolderName: policyHolderName.text,
                                    companyGLPolicyExpirationDate:
                                        companyGLPolicyExpirationDate.text,
                                  ),
                                ),
                              ),
                      )
                    ],
                  );
                },
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
