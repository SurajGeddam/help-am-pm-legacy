import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class OSDetailsComponentWidget extends StatelessWidget {
  final Quotes? quotes;

  const OSDetailsComponentWidget({
    Key? key,
    this.quotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<KeyValueModel> list = [
      KeyValueModel(
        key: "0",
        displayString: AppStrings.yourServiceHasBeenGenerated
            .replaceAll("SERVICE", quotes!.categoryName),
        value:
            "${AppUtils.getDatedMMM(quotes!.createdAt)}, ${AppUtils.getDateHhMmA(quotes!.createdAt)}",
        bgColor: AppColors.grassGreen,
      ),
      KeyValueModel(
        key: "1",
        displayString: AppStrings.providerNameIsOnTheWay
            .replaceAll("PROVIDER", quotes!.providerName),
        value: "",
        bgColor: AppColors.appYellow,
      )
    ];

    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 26.sh, horizontal: 16.sh),
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, int index) {
          KeyValueModel obj = list[index];
          return Padding(
            padding: EdgeInsets.only(
              top: index != 0 ? 36.sh : 0.sh,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  elevation: 6.0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      AppAssets.rightSvgIcon,
                      height: 16.sh,
                      width: 16.sw,
                      color: obj.bgColor,
                    ),
                  ),
                ),
                SizedBox(width: 16.sw),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        obj.displayString,
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 12.fs,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (obj.value.isNotEmpty) SizedBox(height: 4.sh),
                      if (obj.value.isNotEmpty)
                        Text(
                          obj.value,
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 12.fs,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appDarkGrey,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
