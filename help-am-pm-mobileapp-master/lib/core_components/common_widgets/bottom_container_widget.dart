import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../utils/app_colors.dart';

class BottomContainerWidget extends StatelessWidget {
  final Widget? child;

  const BottomContainerWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: AppUtils.deviceHeight - 235.sh,
        width: AppUtils.deviceWidth,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.r),
            topLeft: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
