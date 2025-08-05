import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../utils/app_colors.dart';

class LoadingIndicatorScreen extends StatelessWidget {
  final Widget? customChild;

  const LoadingIndicatorScreen({
    Key? key,
    this.customChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.2),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: AppColors.appYellow,
              color: AppColors.white,
            ),
            SizedBox(height: 16.sh),
            customChild ?? const Offstage()
          ]),
    );
  }
}
