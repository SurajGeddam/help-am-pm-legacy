import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/card_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../onboarding/ui/widgets/uploaded_image_widget.dart';
import 'credit_card_widget.dart';
import 'remove_card_msg_widget.dart';

class CreditCardListItemWidget extends StatelessWidget {
  final CardModel cardObj;

  const CreditCardListItemWidget({
    Key? key,
    required this.cardObj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sh),
      child: UploadedImageWidget(
        containerAlignment: Alignment.centerLeft,
        containerHeight: 181.sh,
        containerWidget: Stack(
          alignment: Alignment.topCenter,
          children: [
            CreditCardWidget(cardObj: cardObj),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12.sw, bottom: 12.sh),
                child: Text(
                  cardObj.cardType.toUpperCase(),
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 20.fs,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        callback: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black45,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext, Animation animation,
                Animation secondaryAnimation) {
              return GestureDetector(
                child: const RemoveCardMsgWidget(),
              );
            },
          );
        },
      ),
    );
  }
}
