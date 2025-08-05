// import 'package:flutter/material.dart';
// import 'package:helpampm/utils/app_utils.dart';
// import '../../../../../core_components/common_widgets/app_text_field_form_widget.dart';
// import '../../../../../core_components/common_widgets/app_text_label_widget.dart';
// import '../../../../../utils/app_colors.dart';
// import '../../../../../utils/app_strings.dart';
// import '../../widgets/is_mandatory_text_label_widget.dart';
//
// class VehicleInfoFormWidget extends StatelessWidget {
//   VehicleInfoFormWidget({Key? key}) : super(key: key);
//
//   final TextEditingController _vehicleMake = TextEditingController();
//   final TextEditingController _vehicleModel = TextEditingController();
//   final TextEditingController _vehicleVIN = TextEditingController();
//   final TextEditingController _vehicleLicensePlate = TextEditingController();
//   final TextEditingController _vehicleInsuranceCarrier =
//       TextEditingController();
//   final TextEditingController _vehicleInsurancePolicy = TextEditingController();
//   final TextEditingController _vehicleInsuranceExpirationDate =
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
//           /// Vehicle Make
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleMake.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleMake,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Vehicle Model
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleModel.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleModel,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Vehicle VIN
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleVIN.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleVIN,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Vehicle License Plate
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleLicensePlate.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleLicensePlate,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Vehicle Insurance Carrier
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleInsuranceCarrier.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleInsuranceCarrier,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Vehicle Insurance Policy
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleInsurancePolicy.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleInsurancePolicy,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Vehicle Insurance Expiration Date
//           AppTextLabelFormWidget(
//             labelText: AppStrings.vehicleInsuranceExpirationDate.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _vehicleInsuranceExpirationDate,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Add Another Vehicle
//           const AppTextLabelFormWidget(labelText: AppStrings.addAnotherVehicle),
//
//           Divider(
//             height: 1.sh,
//             thickness: 1.sh,
//             color: AppColors.dividerColor,
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
