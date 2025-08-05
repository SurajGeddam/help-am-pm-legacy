import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_utils.dart';

class TypeOfPaymentWidget extends StatelessWidget {
  final List<KeyValueModel> list;
  final Function onSelect;

  const TypeOfPaymentWidget({
    Key? key,
    required this.list,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.sh,
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (BuildContext ctx, int index) {
            KeyValueModel obj = list[index];
            return GestureDetector(
              onTap: () => onSelect(obj),
              child: SizedBox(
                width: (AppUtils.deviceWidth - 0) / 2,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(width: 0.5.sw, color: AppColors.black),
                  ),
                  padding: EdgeInsets.only(left: 12.sh),
                  margin: EdgeInsets.only(
                    top: 12.sh,
                    left: (index == 0) ? 20.sw : 10.sw,
                    right: (index == 0) ? 0.sw : 20.sw,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        obj.isSelected
                            ? AppAssets.checkBoxIconSvg
                            : AppAssets.emptyCheckBoxIconSvg,
                        height: 16.sh,
                        width: 16.sw,
                      ),
                      SizedBox(width: 8.sw),
                      Text(
                        obj.value,
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 14.fs,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
