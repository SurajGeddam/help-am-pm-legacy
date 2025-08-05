import 'package:flutter/material.dart';
import 'package:helpampm/core_components/common_models/card_model.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import 'add_payment_screen.dart';
import 'widgets/credit_card_list_item_widget.dart';

class CardListScreen extends StatelessWidget {
  static const String routeName = "/CardListScreen";

  const CardListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
        appTitle: AppStrings.managePayment,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppMockList.cardList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  CardModel obj = AppMockList.cardList[index];
                  return CreditCardListItemWidget(cardObj: obj);
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
                child: BottomButtonWidget(
                  buttonTitle: AppStrings.addNewCard,
                  buttonBGColor: AppColors.black,
                  onPressed: () =>
                      Navigator.pushNamed(context, AddPaymentScreen.routeName),
                ),
              ),
            ),
          ],
        ));
  }
}
