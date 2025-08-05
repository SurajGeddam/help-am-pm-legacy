import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class ListViewWithHeaderWidget extends StatelessWidget {
  final String headerString;
  final List<String> list;

  const ListViewWithHeaderWidget({
    Key? key,
    required this.headerString,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          headerString,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 18.fs,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          textAlign: TextAlign.left,
          maxLines: 1,
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Padding(
                padding: EdgeInsets.only(top: 20.sh),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 16.sh,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 8.sw),
                      child: SvgPicture.asset(
                        AppAssets.dotIconSvg,
                        color: AppColors.textMediumColorOnForm,
                        fit: BoxFit.contain,
                        width: 6.sw,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        list[index],
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 14.fs,
                          fontWeight: FontWeight.w400,
                          color: AppColors.appMediumGrey,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
