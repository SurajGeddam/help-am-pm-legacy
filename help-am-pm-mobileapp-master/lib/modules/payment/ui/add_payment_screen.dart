import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_models/key_value_model.dart';
import '../../../core_components/common_widgets/app_checkbox_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../ongoing_service/ui/ongoing_service_screen.dart';
import 'widgets/booking_success_dialog_widget.dart';
import 'widgets/type_of_payment_widget.dart';

class AddPaymentScreen extends StatefulWidget {
  static const String routeName = "/AddPaymentScreen";

  const AddPaymentScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  List<KeyValueModel> _list = [];
  // late KeyValueModel _selectedObj;
  bool isSelected = false;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void onSelect(KeyValueModel obj) {
    setState(() {
      for (var e in _list) {
        e.isSelected = false;
      }
      obj.isSelected = true;
    });
  }

  @override
  void initState() {
    _list = AppMockList.paymentMethod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.addPayment,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.sh, left: 20.sw, right: 20.sw),
                child: Text(
                  AppStrings.choosePaymentMethod,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appDarkGrey,
                  ),
                ),
              ),
              TypeOfPaymentWidget(
                list: _list,
                onSelect: (obj) {
                  onSelect(obj);
                  // _selectedObj = obj;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.sh),
                child: Divider(
                  thickness: 2.sh,
                  color: AppColors.appGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sh),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Card number
                    AppTextLabelFormWidget(
                      labelText: AppStrings.cardNumber.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: _cardNumberController,
                      maxLength: 16,
                      textFormFieldType: TextFormFieldType.number,
                    ),
                    SizedBox(height: 24.sh),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        /// Expiry date
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTextLabelFormWidget(
                                labelText: AppStrings.expiryDate.toUpperCase(),
                                isMandatory: true,
                              ),
                              AppTextFieldFormWidget(
                                textController: _expDateController,
                                maxLength: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.sw),

                        /// CVV
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTextLabelFormWidget(
                                labelText: AppStrings.cvv.toUpperCase(),
                                isMandatory: true,
                              ),
                              AppTextFieldFormWidget(
                                textController: _cvvController,
                                maxLength: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.sh),

                    /// Card holder name
                    AppTextLabelFormWidget(
                      labelText: AppStrings.cardholderName.toUpperCase(),
                      isMandatory: true,
                    ),
                    AppTextFieldFormWidget(
                      textController: _nameController,
                      maxLength: 25,
                    ),
                    SizedBox(height: 24.sh),
                  ],
                ),
              ),
              Divider(
                thickness: 5.sh,
                color: AppColors.appGrey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28.sh),
                child: AppCheckBoxWidget(
                  text: AppStrings.rememberCard,
                  onTap: (value) {
                    isSelected = value;
                    AppUtils.debugPrint("isSelected : $isSelected");
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
              child: BottomButtonWidget(
                buttonTitle: AppStrings.payNow,
                buttonBGColor: AppColors.black,
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (BuildContext buildContext,
                        Animation animation, Animation secondaryAnimation) {
                      return BookingSuccessDialogWidget(
                          /*onPressed: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(CustomerHomeScreen.routeName,
                              (Route<dynamic> route) => false);*/
                          onPressed: () => Navigator.pushNamed(
                              context, OngoingServiceScreen.routeName));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
