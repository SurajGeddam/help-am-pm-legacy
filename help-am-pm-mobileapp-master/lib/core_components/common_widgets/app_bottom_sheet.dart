import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_colors.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double sheetHeight;

  const AppBottomSheet({
    Key? key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.sheetHeight = 0.88,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          backgroundColor ?? AppColors.transparent.withOpacity(0.7),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: onTap,
              child: Container(
                height: MediaQuery.of(context).size.height * (1 - sheetHeight),
              ),
            ),
            Container(
              height: AppUtils.deviceHeight * sheetHeight,
              width: AppUtils.deviceWidth,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  topLeft: Radius.circular(16.r),
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
