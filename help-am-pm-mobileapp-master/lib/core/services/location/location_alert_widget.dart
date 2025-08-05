import 'package:flutter/material.dart';
import 'alert_dialog_for_location_denied_widget.dart';
import 'alert_dialog_for_location_enable_widget.dart';

class LocationAlert {
  void showAlert(BuildContext? context, {bool isPermissionDenied = false}) {
    showGeneralDialog(
      context: context!,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return isPermissionDenied
            ? AlertDialogForLocationDeniedWidget(
                onPressedOk: () => Navigator.pop(context))
            : AlertDialogForLocationEnableWidget(
                onPressedOk: () => Navigator.pop(context));
      },
    );
  }
}
