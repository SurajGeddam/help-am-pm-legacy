import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';

// https://medium.com/flutter-community/flutter-image-uploader-with-app-permissions-and-compression-using-getit-services-59ffea13f913
// https://github.com/Roaa94/flutter-tutorials/blob/main/lib/main.dart

class UploadedImageWidget extends StatelessWidget {
  final File? imageFile;
  final VoidCallback? callback;
  final bool isFromCC;
  final Widget containerWidget;
  final double containerHeight;
  final Alignment containerAlignment;

  const UploadedImageWidget({
    Key? key,
    this.imageFile,
    this.callback,
    this.isFromCC = false,
    this.containerWidget = const Offstage(),
    this.containerHeight = 118.0,
    this.containerAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: containerHeight,
          width: double.infinity,
          alignment: containerAlignment,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(width: 1.sw, color: AppColors.appThinGrey),
            borderRadius: BorderRadius.circular(6.r),
            image: (imageFile == null)
                ? const DecorationImage(
                    image: AssetImage(AppAssets.ccBgImage),
                    fit: BoxFit.fill,
                  )
                : DecorationImage(
                    image: FileImage(imageFile!),
                    fit: BoxFit.contain,
                  ),
          ),
          child: containerWidget,
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: callback,
            child: Padding(
              padding: EdgeInsets.only(top: 12.sh, right: 5.sh),
              child: SvgPicture.asset(
                AppAssets.deleteCircleSvgIcon,
                height: 28.sh,
                width: 28.sw,
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    );
  }
}
