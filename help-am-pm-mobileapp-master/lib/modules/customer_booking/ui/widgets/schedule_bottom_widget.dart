// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:helpampm/utils/app_utils.dart';
//
// import '../../../../core_components/common_widgets/bottom_button_widget.dart';
// import '../../../../core_components/common_widgets/upload_pic_dialog_widget.dart';
// import '../../../../utils/app_assets.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/app_strings.dart';
// import '../../../../utils/app_text_styles.dart';
// import '../../../onboarding/ui/widgets/upload_icon_widget.dart';
// import '../../../onboarding/ui/widgets/uploaded_image_widget.dart';
// import '../../../searching_provider/ui/searching_provider_screen.dart';
//
// class ScheduleBottomWidget extends StatefulWidget {
//   const ScheduleBottomWidget({Key? key}) : super(key: key);
//
//   @override
//   State<ScheduleBottomWidget> createState() => _ScheduleBottomWidgetState();
// }
//
// class _ScheduleBottomWidgetState extends State<ScheduleBottomWidget> {
//   File? imageFile;
//
//   void showDialog() {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierColor: Colors.black45,
//       transitionDuration: const Duration(milliseconds: 200),
//       pageBuilder: (BuildContext buildContext, Animation animation,
//           Animation secondaryAnimation) {
//         return UploadPicDialogWidget(
//           onCloseBtn: () => Navigator.pop(context),
//           onSelected: (value) {
//             AppUtils.debugPrint("Selected : $value");
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.white,
//       padding:
//           EdgeInsets.only(bottom: 24.sh, top: 24.sh, left: 20.sw, right: 20.sw),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 (imageFile == null)
//                     ? AppStrings.addPhotoOptional
//                     : AppStrings.photo,
//                 style: AppTextStyles.defaultTextStyle.copyWith(
//                   fontSize: 14.fs,
//                   fontWeight: FontWeight.w400,
//                   color: AppColors.black,
//                 ),
//                 textAlign: TextAlign.start,
//                 maxLines: 1,
//               ),
//               (imageFile == null)
//                   ? GestureDetector(
//                       onTap: () => showDialog(),
//                       child: UploadIconWidget(
//                         bgImageString: AppAssets.linedBoxSvg,
//                         textColor: AppColors.appOrange,
//                       ),
//                     )
//                   : const Offstage(),
//             ],
//           ),
//           SizedBox(height: 12.sh),
//           (imageFile != null)
//               ? UploadedImageWidget(
//                   imageFile: imageFile,
//                   callback: () {},
//                 )
//               : const Offstage(),
//           SizedBox(height: 36.sh),
//           BottomButtonWidget(
//             buttonTitle: AppStrings.submit,
//             buttonBGColor: AppColors.black,
//             onPressed: () =>
//                 Navigator.pushNamed(context, SearchingProviderScreen.routeName),
//           )
//         ],
//       ),
//     );
//   }
// }
