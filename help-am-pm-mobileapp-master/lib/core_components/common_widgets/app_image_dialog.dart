import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_utils.dart';

class AppImageDialog extends StatelessWidget {
  final String byteImage;

  const AppImageDialog({
    super.key,
    required this.byteImage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            color: AppColors.white,
            height: AppUtils.deviceHeight * 0.8,
            width: AppUtils.deviceWidth,
            child: Image.memory(
              AppUtils.convertImage(byteImage),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 12.sh,
            right: 12.sh,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close_rounded,
                size: 28.sh,
                color: AppColors.appDarkOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
