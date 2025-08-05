import 'package:flutter/material.dart';

import '../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_utils.dart';

class AppImageNoteDialog extends StatelessWidget {
  final Quotes quotes;

  const AppImageNoteDialog({
    super.key,
    required this.quotes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      insetPadding: EdgeInsets.all(20.sh),
      child: Container(
        color: AppColors.white,
        height: AppUtils.deviceHeight * 0.8,
        padding: EdgeInsets.all(20.sh),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close_rounded,
                  size: 28.sh,
                  color: AppColors.appDarkOrange,
                ),
              ),
            ),
            quotes.imagePath.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 10.sh),
                    child: Image.memory(
                      AppUtils.convertImage(quotes.imagePath),
                      fit: BoxFit.contain,
                      height: AppUtils.deviceWidth * 0.6,
                      width: double.infinity,
                    ),
                  )
                : const Offstage(),
            SizedBox(height: 10.sh),
            Expanded(
                child: SingleChildScrollView(
              child: Text(
                quotes.serviceDescription,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.justify,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
