import 'package:flutter/material.dart';

import '../../../../core_components/common_widgets/app_custom_top_widget.dart';
import '../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import 'os_top_text_widget.dart';

class PSTopWidget extends StatelessWidget {
  final bool isProviderReached;
  final Quotes? quotes;

  const PSTopWidget({
    Key? key,
    this.isProviderReached = false,
    this.quotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 1.0],
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          tileMode: TileMode.repeated,
          colors: [
            Color(0xFFFBB034),
            Color(0xFFFFDD00),
          ],
        ),
      ),
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
            top: 56.sh, left: 20.sw, right: 20.sw, bottom: 56.sh),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const AppCustomTopWidget(),
            Expanded(
              child: OSTopTextWidget(
                isProviderReached: isProviderReached,
                quotes: quotes,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
