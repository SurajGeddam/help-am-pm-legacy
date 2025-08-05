import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../model/common/policy_type_model.dart';

class AppDropdownWidget<T> extends StatefulWidget {
  final List<PolicyTypeModel> list;
  final Function? onSelect;

  const AppDropdownWidget({
    super.key,
    required this.list,
    this.onSelect,
  });

  @override
  State<AppDropdownWidget<T>> createState() => _AppDropdownWidgetState<T>();
}

class _AppDropdownWidgetState<T> extends State<AppDropdownWidget<T>> {
  PolicyTypeModel? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<PolicyTypeModel>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 0,
      isExpanded: true,
      style: AppTextStyles.defaultTextStyle.copyWith(
        color: AppColors.black,
        fontSize: 14.fs,
        fontWeight: FontWeight.w400,
      ),
      isDense: false,
      onChanged: (PolicyTypeModel? value) {
        widget.onSelect!(value);
        setState(() => dropdownValue = value!);
      },
      items: widget.list
          .map<DropdownMenuItem<PolicyTypeModel>>((PolicyTypeModel value) {
        return DropdownMenuItem<PolicyTypeModel>(
          value: value,
          child: Text(
            value.name,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: AppColors.black,
              fontSize: 14.fs,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        );
      }).toList(),
    );
  }
}
