// import 'package:flutter/material.dart';
// import 'package:helpampm/utils/app_utils.dart';
//
// import '../../../../../core_components/common_widgets/app_text_field_form_widget.dart';
// import '../../../../../core_components/common_widgets/app_text_label_widget.dart';
// import '../../../../../utils/app_strings.dart';
// import '../is_mandatory_text_label_widget.dart';
//
// class InsuranceInformationFormWidget extends StatelessWidget {
//   InsuranceInformationFormWidget({Key? key}) : super(key: key);
//
//   final TextEditingController _companyGeneralLiabilityInsCarrier =
//       TextEditingController();
//   final TextEditingController _companyGLPolicy = TextEditingController();
//   final TextEditingController _companyGLPolicyExpirationDate =
//       TextEditingController();
//   final TextEditingController _companyWorkmanIsCompInsCarrier =
//       TextEditingController();
//   final TextEditingController _companyWCPolicyIfDifferentFromGL =
//       TextEditingController();
//   final TextEditingController _companyWCPolicyExpirationDate =
//       TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           /// Company General Liability Ins Carrier
//           AppTextLabelFormWidget(
//             labelText:
//                 AppStrings.companyGeneralLiabilityInsCarrier.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyGeneralLiabilityInsCarrier,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company GL Policy
//           AppTextLabelFormWidget(
//             labelText: AppStrings.companyPolicyNumber.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyGLPolicy,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company GL Policy Expiration Date
//           AppTextLabelFormWidget(
//             labelText: AppStrings.companyGLPolicyExpirationDate.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyGLPolicyExpirationDate,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Workman Is Comp Ins Carrier
//           const AppTextLabelFormWidget(
//             labelText: AppStrings.companyWorkmanIsCompInsCarrier,
//             isMandatory: false,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyWorkmanIsCompInsCarrier,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company WC Policy If Different From GL
//           AppTextLabelFormWidget(
//             labelText:
//                 AppStrings.companyWCPolicyIfDifferentFromGL.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyWCPolicyIfDifferentFromGL,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company WC Policy Expiration Date
//           AppTextLabelFormWidget(
//             labelText: AppStrings.companyWCPolicyExpirationDate.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyWCPolicyExpirationDate,
//             maxLength: 50,
//           ),
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
