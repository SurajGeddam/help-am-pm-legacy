// import 'package:flutter/material.dart';
// import 'package:helpampm/utils/app_utils.dart';
//
// import '../../../../../core_components/common_widgets/app_text_field_form_widget.dart';
// import '../../../../../core_components/common_widgets/app_text_label_widget.dart';
// import '../../../../../utils/app_strings.dart';
// import '../../widgets/is_mandatory_text_label_widget.dart';
//
// class BankInfoFormWidget extends StatelessWidget {
//   BankInfoFormWidget({Key? key}) : super(key: key);
//
//   final TextEditingController _nameOfTheBank = TextEditingController();
//   final TextEditingController _nameOnTheBankAccount = TextEditingController();
//   final TextEditingController _accountRoutingNumber = TextEditingController();
//   final TextEditingController _accountNumber = TextEditingController();
//   final TextEditingController _bankAddress = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           /// Name Of The Bank
//           AppTextLabelFormWidget(
//             labelText: AppStrings.nameOfTheBank.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _nameOfTheBank,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Name On The Bank Account
//           AppTextLabelFormWidget(
//             labelText: AppStrings.nameOnTheBankAccount.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _nameOnTheBankAccount,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Account Routing Number
//           AppTextLabelFormWidget(
//             labelText: AppStrings.accountRoutingNumber.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _accountRoutingNumber,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Account Number
//           AppTextLabelFormWidget(
//             labelText: AppStrings.accountNumber.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _accountNumber,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Bank Address
//           const AppTextLabelFormWidget(
//             labelText: AppStrings.bankAddress,
//             isMandatory: false,
//           ),
//           AppTextFieldFormWidget(
//             textController: _bankAddress,
//             maxLength: 50,
//           ),
//
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 20.sh),
//             child: const IsMandatoryTextLabelWidget(),
//           ),
//           SizedBox(height: 70.sh),
//         ],
//       ),
//     );
//   }
// }
