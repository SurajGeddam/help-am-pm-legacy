import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_text_styles.dart';
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
import '../../app_drawer/bloc/logout_cubit.dart';
import '../bloc/bank_bloc/bank_bloc.dart';
import '../bloc/bank_bloc/bank_event.dart';
import '../bloc/bank_bloc/bank_state.dart';
import '../model/common/policy_type_model.dart';
import 'widgets/app_drop_down_widget.dart';
import 'widgets/horizontal_stepper_widget.dart';
import 'widgets/is_mandatory_text_label_widget.dart';
import 'widgets/pro_team_member_form_widgets/uploaded_doc_submitted_widget.dart';

class BankInformationScreen extends StatefulWidget {
  static const String routeName = "/BankInformationScreen";

  const BankInformationScreen({Key? key}) : super(key: key);

  @override
  State<BankInformationScreen> createState() => _BankInformationScreenState();
}

class _BankInformationScreenState extends State<BankInformationScreen> {
  final TextEditingController nameOfTheBank = TextEditingController();
  final TextEditingController nameOnTheBankAccount = TextEditingController();
  final TextEditingController accountRoutingNumber = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController bankAddress = TextEditingController();

  late BankBloc bankBloc;
  bool isLoading = false;

  late LoadingIndicatorBloc loadingIndicatorBloc;
  late LogoutCubit logoutCubit;

  List<PolicyTypeModel> loadedList = [];
  PolicyTypeModel? policyTypeObj;

  setData() {
    bankBloc = BankBloc();

    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);

    loadedList = [
      PolicyTypeModel(
        id: 0,
        name: AppStrings.personal,
        isActive: true,
      ),
      PolicyTypeModel(
        id: 0,
        name: AppStrings.business,
        isActive: true,
      )
    ];

    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = true;
      if (InputFormType.bank.code == AppMockList.userInputDetailList[i].key) {
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
    nameOfTheBank.dispose();
    nameOnTheBankAccount.dispose();
    accountRoutingNumber.dispose();
    accountNumber.dispose();
    bankAddress.dispose();
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
              appTitle: AppStrings.bankInformation,
              isBackShow: false,
              isLogoutShow: true,
              onLogoutPressed: () => logoutCubit.logoutApi(),
              child: BlocListener<BankBloc, BankState>(
                bloc: bankBloc,
                listener: (ctx, state) {
                  if (state is BankLoadingState) {
                    setState(() => isLoading = true);
                  } else if (state is BankValidState) {
                    bankBloc.add(
                      BankSubmittedEvent(
                        nameOfTheBank: nameOfTheBank.text,
                        nameOnTheBankAccount: nameOnTheBankAccount.text,
                        accountRoutingNumber: accountRoutingNumber.text,
                        accountNumber: accountNumber.text,
                        bankAddress: bankAddress.text,
                        bankAccountType: policyTypeObj?.name.toUpperCase() ??
                            loadedList[0].name.toUpperCase(),
                      ),
                    );
                    setState(() => isLoading = false);
                  } else if (state is BankErrorState) {
                    setState(() => isLoading = false);
                    AppUtils.showSnackBar(state.errorMessage,
                        bgColor: state.bgColor);
                  } else if (state is BankCompleteState) {
                    setState(() => isLoading = false);
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        return const UploadedDocSubmittedWidget();
                      },
                    );
                    return;
                  }
                },
                child: ListView(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(left: 20.sh, right: 20.sw, top: 20.sh),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Text(
                      AppStrings.companyOrIndividualBankInformation,
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

                    /// Name Of The Bank
                    AppTextLabelFormWidget(
                      labelText: AppStrings.nameOfTheBank.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: nameOfTheBank,
                      maxLength: 50,
                      textFormFieldType: TextFormFieldType.name,
                    ),
                    SizedBox(height: 24.sh),

                    /// Name On The Bank Account
                    AppTextLabelFormWidget(
                      labelText: AppStrings.nameOnTheBankAccount.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: nameOnTheBankAccount,
                      maxLength: 50,
                      textFormFieldType: TextFormFieldType.name,
                    ),
                    SizedBox(height: 24.sh),

                    /// Account Routing Number
                    AppTextLabelFormWidget(
                      labelText: AppStrings.accountRoutingNumber.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: accountRoutingNumber,
                      maxLength: 20,
                      textFormFieldType: TextFormFieldType.number,
                    ),
                    SizedBox(height: 24.sh),

                    /// Account Number
                    AppTextLabelFormWidget(
                      labelText: AppStrings.accountNumber.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: accountNumber,
                      maxLength: 20,
                      textFormFieldType: TextFormFieldType.number,
                    ),
                    SizedBox(height: 24.sh),

                    /// Bank Account Type
                    const AppTextLabelFormWidget(
                      labelText: AppStrings.bankAccountType,
                      isMandatory: false,
                    ),
                    loadedList.isEmpty
                        ? const Offstage()
                        : AppDropdownWidget(
                            list: loadedList,
                            onSelect: (value) => policyTypeObj = value),
                    SizedBox(height: 24.sh),

                    /// Bank Address
                    const AppTextLabelFormWidget(
                      labelText: AppStrings.bankAddress,
                      isMandatory: false,
                    ),
                    AppTextFieldFormWidget(
                      textController: bankAddress,
                      maxLength: 50,
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
                              onPressed: () => bankBloc.add(
                                BankValidationEvent(
                                  nameOfTheBank: nameOfTheBank.text,
                                  nameOnTheBankAccount:
                                      nameOnTheBankAccount.text,
                                  accountRoutingNumber:
                                      accountRoutingNumber.text,
                                  accountNumber: accountNumber.text,
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
