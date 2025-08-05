import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../core_components/common_widgets/app_dotted_line_widget.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';

class StepperFirstColumnWidget extends StatelessWidget {
  final List<KeyValueModel> earnWithHelpList;
  final int index;

  const StepperFirstColumnWidget({
    Key? key,
    required this.earnWithHelpList,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        (index == 0)
            ? SizedBox(height: 20.sh)
            : SizedBox(
                height: 20.sh,
                child: CustomPaint(
                  painter: AppDottedLineWidget(
                    color: AppColors.appDarkGrey,
                    isDottedLineVertical: true,
                    dashHeight: 2,
                  ),
                ),
              ),
        Container(
          height: 86.sh,
          decoration: const BoxDecoration(
            color: AppColors.transparent,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            index == 0
                ? AppAssets.selectedDocUnderCircle
                : AppAssets.docUnderCircle,
            fit: BoxFit.fill,
          ),
        ),
        if (index < earnWithHelpList.length - 1)
          Expanded(
            child: CustomPaint(
              painter: AppDottedLineWidget(
                color: AppColors.appDarkGrey,
                isDottedLineVertical: true,
                dashHeight: 2,
              ),
            ),
          ),
      ],
    );
  }
}
