import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class AppLoadingWidget extends StatelessWidget {
  final Color? bgColor;
  const AppLoadingWidget({
    Key? key,
    this.bgColor = AppColors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.appYellow),
      ),
    );
  }
}
