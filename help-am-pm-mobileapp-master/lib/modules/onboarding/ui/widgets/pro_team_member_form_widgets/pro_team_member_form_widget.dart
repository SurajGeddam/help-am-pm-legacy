import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../../../core_components/common_widgets/upload_pic_dialog_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_enum.dart';
import '../../../../../utils/app_strings.dart';
import '../is_mandatory_text_label_widget.dart';
import '../upload_icon_widget.dart';

class ProTeamMemberFormWidget extends StatefulWidget {
  const ProTeamMemberFormWidget({Key? key}) : super(key: key);

  @override
  State<ProTeamMemberFormWidget> createState() =>
      _ProTeamMemberFormWidgetState();
}

class _ProTeamMemberFormWidgetState extends State<ProTeamMemberFormWidget> {
  /*final MediaService _mediaService = getIt<MediaService>();*/

  final TextEditingController _name = TextEditingController();

  final TextEditingController _cellPhone = TextEditingController();

  final TextEditingController _emailIdIfDifferentFromCompanyEmail =
      TextEditingController();

  final TextEditingController _dl = TextEditingController();

  final TextEditingController _yearsOfExperience = TextEditingController();

  final TextEditingController _twitterHandle = TextEditingController();

  File? imageFile;

  /*Future<AppImageSource?> _pickImageSource() async {
    AppImageSource? appImageSource = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => const ImagePickerActionSheet(),
    );
    if (appImageSource != null) {
      _getImage(appImageSource);
    }
    return null;
  }

  Future _getImage(AppImageSource appImageSource) async {
    final pickedImageFile = await _mediaService
        .uploadImage(context, appImageSource, shouldCompress: false);

    if (pickedImageFile != null) {
      setState(() => imageFile = pickedImageFile);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          /// Name
          AppTextLabelFormWidget(
            labelText: AppStrings.name.toUpperCase(),
            isMandatory: true,
          ),
          AppTextFieldFormWidget(
            textController: _name,
            maxLength: 50,
          ),
          SizedBox(height: 24.sh),

          /// Cell Phone
          const AppTextLabelFormWidget(labelText: AppStrings.cellPhone),
          AppTextFieldFormWidget(
            textController: _cellPhone,
            maxLength: 10,
            textFormFieldType: TextFormFieldType.phone,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 24.sh),

          /// Email Id If Different From Company Email
          const AppTextLabelFormWidget(
              labelText: AppStrings.emailIdIfDifferentFromCompanyEmail),
          AppTextFieldFormWidget(
            textController: _emailIdIfDifferentFromCompanyEmail,
            maxLength: 50,
            textFormFieldType: TextFormFieldType.email,
          ),
          SizedBox(height: 24.sh),

          /// dl
          AppTextLabelFormWidget(
            labelText: AppStrings.dl.toUpperCase(),
            isMandatory: true,
          ),
          AppTextFieldFormWidget(
            textController: _dl,
            maxLength: 50,
          ),
          SizedBox(height: 24.sh),

          /// Pic
          const AppTextLabelFormWidget(
            labelText: AppStrings.pic,
            isMandatory: true,
          ),
          GestureDetector(
            onTap: () => {
              showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return UploadPicDialogWidget(
                    onCloseBtn: () => Navigator.pop(context),
                    onSelected: (value) {
                      AppUtils.debugPrint("Selected : $value");
                    },
                  );
                },
              )
            },
            child: const UploadIconWidget(),
          ),
          SizedBox(height: 24.sh),

          /// Years Of Experience
          AppTextLabelFormWidget(
            labelText: AppStrings.yearsOfExperience.toUpperCase(),
            isMandatory: true,
          ),
          AppTextFieldFormWidget(
            textController: _yearsOfExperience,
            maxLength: 50,
          ),
          SizedBox(height: 24.sh),

          /// Twitter Handle
          const AppTextLabelFormWidget(labelText: AppStrings.twitterHandle),
          AppTextFieldFormWidget(
            textController: _twitterHandle,
            maxLength: 50,
          ),
          SizedBox(height: 24.sh),

          /// Add Another Pro Team Member
          const AppTextLabelFormWidget(
              labelText: AppStrings.addAnotherProTeamMember),
          Divider(
            height: 1.sh,
            thickness: 1.sh,
            color: AppColors.dividerColor,
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.sh),
            child: const IsMandatoryTextLabelWidget(),
          ),
          SizedBox(height: 70.sh),
        ],
      ),
    );
  }
}
