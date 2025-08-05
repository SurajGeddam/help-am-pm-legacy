import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_strings.dart';
import '../../bloc/delete_cubit.dart';
import 'alert_dialog_for_delete_accout_widget.dart';

class HelpSecondWidget extends StatefulWidget {
  const HelpSecondWidget({Key? key}) : super(key: key);

  @override
  State<HelpSecondWidget> createState() => _HelpSecondWidgetState();
}

class _HelpSecondWidgetState extends State<HelpSecondWidget> {
  late List<KeyValueModel> drawerList;
  late DeleteAccountCubit deleteAccountCubit;

  @override
  void initState() {
    deleteAccountCubit = DeleteAccountCubit();
    super.initState();
  }

  void showAlert(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return AlertDialogForDeleteWidget(
          onPressedCancel: () => Navigator.pop(context),
          onPressedOk: () => {
            deleteAccountCubit.deleteAccountAPI().then((value) {
              AppUtils.logout();
            })
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAlert(context),
      child: Container(
        height: 60.sh,
        width: AppUtils.deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.sw),
        alignment: Alignment.centerLeft,
        child: Text(
          AppStrings.deleteMyAccount,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 16.fs,
            fontWeight: FontWeight.w400,
            color: AppColors.red,
          ),
        ),
      ),
    );
  }
}
