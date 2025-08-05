import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../core/services/media/media_service.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class UploadPicDialogWidget extends StatelessWidget {
  final VoidCallback? onCloseBtn;
  final Function? onSelected;

  const UploadPicDialogWidget({
    Key? key,
    this.onCloseBtn,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 227.sh,
          margin: EdgeInsets.symmetric(horizontal: 20.sw),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 44.sh,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.appOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      AppStrings.image,
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 16.fs,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: onCloseBtn,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.sh),
                          child: SvgPicture.asset(
                            AppAssets.crossSvgIcon,
                            height: 14.sh,
                            width: 14.sw,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _columnWidget(
                        onTap: () => onSelected!(AppImageSource.camera),
                        image: AppAssets.takeCameraSvgIcon,
                        value: AppStrings.takePhoto),
                    _columnWidget(
                        onTap: () => onSelected!(AppImageSource.gallery),
                        image: AppAssets.chooseFromGallerySvgIcon,
                        value: AppStrings.chooseFromGallery),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _columnWidget({
    required VoidCallback onTap,
    required String image,
    required String value,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 41.sh),
          SvgPicture.asset(
            image,
            height: 54.sh,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 14.sh),
          Text(
            value,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.appMediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
