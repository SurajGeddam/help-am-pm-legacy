import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_mock_list.dart';
import 'stepper_first_column_widget.dart';
import 'stepper_second_column_widget.dart';

class StepperWidget extends StatelessWidget {
  final List<KeyValueModel> earnWithHelpList;

  const StepperWidget({
    Key? key,
    required this.earnWithHelpList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: earnWithHelpList.length,
      itemBuilder: (context, index) {
        KeyValueModel data = AppMockList.earnWithHelpList[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 150.sh,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StepperFirstColumnWidget(
                    earnWithHelpList: earnWithHelpList,
                    index: index,
                  ),
                  SizedBox(width: 16.sw),
                  StepperSecondColumnWidget(data: data),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
