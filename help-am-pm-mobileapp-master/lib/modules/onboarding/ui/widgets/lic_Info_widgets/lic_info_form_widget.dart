// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:helpampm/utils/app_utils.dart';
//
// import '../../../../../core/services/media/media_service.dart';
// import '../../../../../core/services/service_locator.dart';
// import '../../../../../core_components/common_widgets/app_text_field_form_widget.dart';
// import '../../../../../core_components/common_widgets/app_text_label_widget.dart';
// import '../../../../../core_components/common_widgets/image_picker_action_sheet.dart';
// import '../../../../../core_components/common_widgets/upload_pic_dialog_widget.dart';
// import '../../../../../utils/app_strings.dart';
// import '../is_mandatory_text_label_widget.dart';
// import '../upload_icon_widget.dart';
// import '../uploaded_image_widget.dart';
//
// class LicenseInformationFormWidget extends StatefulWidget {
//   const LicenseInformationFormWidget({Key? key}) : super(key: key);
//
//   @override
//   State<LicenseInformationFormWidget> createState() =>
//       _LicenseInformationFormWidgetState();
// }
//
// class _LicenseInformationFormWidgetState
//     extends State<LicenseInformationFormWidget> {
//   final MediaService _mediaService = getIt<MediaService>();
//
//   final TextEditingController _companyTradeLicenseRegisteredState =
//       TextEditingController();
//
//   final TextEditingController _companyTradeLicense = TextEditingController();
//
//   final TextEditingController _companyTradeLicenseExpiration =
//       TextEditingController();
//
//   final TextEditingController _companyBusinessLicenseRegisteredSate =
//       TextEditingController();
//
//   final TextEditingController _companyBusinessLicense = TextEditingController();
//
//   final TextEditingController _companyBusinessLicenseExpiration =
//       TextEditingController();
//
//   File? imageFile;
//
//   Future<AppImageSource?> _pickImageSource() async {
//     AppImageSource? appImageSource = await showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) => const ImagePickerActionSheet(),
//     );
//     if (appImageSource != null) {
//       _getImage(appImageSource);
//     }
//     return null;
//   }
//
//   Future _getImage(AppImageSource appImageSource) async {
//     final pickedImageFile = await _mediaService
//         .uploadImage(context, appImageSource, shouldCompress: false);
//
//     if (pickedImageFile != null) {
//       setState(() => imageFile = pickedImageFile);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           /// Company TradeLicense Registered State
//           AppTextLabelFormWidget(
//             labelText:
//                 AppStrings.companyLicenseRegisteredState.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyTradeLicenseRegisteredState,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Trade License
//           AppTextLabelFormWidget(
//             labelText: AppStrings.companyLicenseNumber.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyTradeLicense,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Trade License Expiration
//           AppTextLabelFormWidget(
//             labelText: AppStrings.companyLicenseExpiration.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyTradeLicenseExpiration,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Trade License Pic
//           const AppTextLabelFormWidget(
//             labelText: AppStrings.companyTradeLicensePic,
//             isMandatory: false,
//           ),
//           !(imageFile == null)
//               ? GestureDetector(
//                   // onTap: () => _settingModalBottomSheet(context),
//                   onTap: _pickImageSource,
//                   child: const UploadIconWidget(),
//                 )
//               : UploadedImageWidget(
//                   imageFile: imageFile,
//                   callback: () {
//                     // setState(() => imageFile = XFile(AppStrings.emptyString));
//                   },
//                 ),
//           SizedBox(height: 24.sh),
//
//           /// Company Business License Registered Sate
//           AppTextLabelFormWidget(
//             labelText:
//                 AppStrings.companyBusinessLicenseRegisteredSate.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyBusinessLicenseRegisteredSate,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Business License
//           AppTextLabelFormWidget(
//             labelText: AppStrings.companyBusinessLicense.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyBusinessLicense,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Business License Expiration
//           AppTextLabelFormWidget(
//             labelText:
//                 AppStrings.companyBusinessLicenseExpiration.toUpperCase(),
//             isMandatory: true,
//           ),
//           AppTextFieldFormWidget(
//             textController: _companyBusinessLicenseExpiration,
//             maxLength: 50,
//           ),
//           SizedBox(height: 24.sh),
//
//           /// Company Business License Pic
//           const AppTextLabelFormWidget(
//             labelText: AppStrings.companyBusinessLicensePic,
//             isMandatory: false,
//           ),
//           GestureDetector(
//             onTap: () => {
//               showGeneralDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 barrierLabel:
//                     MaterialLocalizations.of(context).modalBarrierDismissLabel,
//                 barrierColor: Colors.black45,
//                 transitionDuration: const Duration(milliseconds: 200),
//                 pageBuilder: (BuildContext buildContext, Animation animation,
//                     Animation secondaryAnimation) {
//                   return UploadPicDialogWidget(
//                     onCloseBtn: () => Navigator.pop(context),
//                     onSelected: (value) {
//                       AppUtils.debugPrint("Selected : $value");
//                     },
//                   );
//                 },
//               )
//             },
//             child: const UploadIconWidget(),
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
//
//   /*Future imageSelector(BuildContext context, ImageSource source) async {
//     try {
//       final XFile? pickedFile = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 90,
//       );
//       setState(() {
//         imageFile = pickedFile;
//       });
//     } catch (e) {
//       AppUtils.debugPrint("You have not taken image: $e");
//     }
//   }
//
//   /// Image picker
//   void _settingModalBottomSheet(context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return Wrap(
//           children: <Widget>[
//             ListTile(
//                 title: const Text('Gallery'),
//                 onTap: () => {
//                       imageSelector(context, ImageSource.gallery),
//                       Navigator.pop(context),
//                     }),
//             ListTile(
//               title: const Text('Camera'),
//               onTap: () => {
//                 imageSelector(context, ImageSource.camera),
//                 Navigator.pop(context)
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }*/
// }
