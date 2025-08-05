import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/*showGeneralDialog(
context: context,
barrierDismissible: true,
barrierLabel: MaterialLocalizations.of(context)
.modalBarrierDismissLabel,
barrierColor: Colors.black45,
transitionDuration: const Duration(milliseconds: 200),
pageBuilder: (BuildContext buildContext,
    Animation animation,
Animation secondaryAnimation) {
child: child});*/

class ShowGeneralDialogWidget extends StatelessWidget {
  const ShowGeneralDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        height: MediaQuery.of(context).size.height - 80,
        padding: const EdgeInsets.all(20),
        color: AppColors.white,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: AppColors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
