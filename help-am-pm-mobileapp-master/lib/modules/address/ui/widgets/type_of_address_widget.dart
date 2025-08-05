import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/core_components/common_models/key_value_model.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class TypeOfAddressWidget extends StatelessWidget {
  final List<KeyValueModel> list;
  final Function onSelect;

  const TypeOfAddressWidget({
    Key? key,
    required this.list,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      padding: EdgeInsets.all(20.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.typeOfAddress,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(
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
                      width: (AppUtils.deviceWidth - 40) / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            obj.isSelected
                                ? AppAssets.selectedCircleIconSvg
                                : AppAssets.circleIconSvg,
                            height: 16.sh,
                            width: 16.sw,
                            color: AppColors.appDarkGrey,
                          ),
                          SizedBox(width: 8.sw),
                          Text(
                            obj.value,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 16.fs,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
