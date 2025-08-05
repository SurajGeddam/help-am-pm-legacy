// import 'package:flutter/material.dart';
// import 'package:helpampm/utils/app_utils.dart';
//
// import '../../../../../utils/app_colors.dart';
// import '../../../../../utils/app_strings.dart';
// import '../../../../../utils/app_text_styles.dart';
//
// class PricingDetailWidget extends StatelessWidget {
//   const PricingDetailWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 20.sw),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             AppStrings.pricingDetails,
//             style: AppTextStyles.defaultTextStyle.copyWith(
//               fontSize: 18.fs,
//               fontWeight: FontWeight.w500,
//               color: AppColors.black,
//             ),
//           ),
//           SizedBox(height: 18.sh),
//           rowKeyValue(
//             key: "Air Conditioner Service",
//             value: "\$125.00",
//           ),
//           SizedBox(height: 12.sh),
//           rowKeyValue(
//             key: AppStrings.taxes,
//             value: "\$15.85",
//           ),
//           SizedBox(height: 20.sh),
//           rowKeyValue(
//             key: AppStrings.totalPayment,
//             value: "\$135.85",
//             isTotalPayment: true,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget rowKeyValue({
//     required String key,
//     required String value,
//     bool isTotalPayment = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Text(
//           key,
//           maxLines: 2,
//           textAlign: TextAlign.left,
//           overflow: TextOverflow.ellipsis,
//           style: isTotalPayment
//               ? AppTextStyles.defaultTextStyle.copyWith(
//                   fontSize: 16.fs,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.black,
//                 )
//               : AppTextStyles.defaultTextStyle.copyWith(
//                   fontSize: 14.fs,
//                   fontWeight: FontWeight.w400,
//                   color: AppColors.appMediumGrey,
//                 ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             maxLines: 1,
//             textAlign: TextAlign.right,
//             overflow: TextOverflow.ellipsis,
//             style: isTotalPayment
//                 ? AppTextStyles.defaultTextStyle.copyWith(
//                     fontSize: 16.fs,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.black,
//                   )
//                 : AppTextStyles.defaultTextStyle.copyWith(
//                     fontSize: 14.fs,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.appMediumGrey,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }
