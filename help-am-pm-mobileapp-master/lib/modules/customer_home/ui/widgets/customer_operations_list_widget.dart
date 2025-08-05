import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core/services/bloc/loading_indicator_bloc.dart';
import '../../../../core/services/bloc/location_cubit.dart';
import '../../../../core/services/location/location_alert_widget.dart';
import '../../../../core/services/location/location_manager_handler.dart';
import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_mock_list.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../cutomer_location/ui/confirm_location_screen.dart';

class CustomerOperationsListWidget extends StatefulWidget {
  const CustomerOperationsListWidget({Key? key}) : super(key: key);

  @override
  State<CustomerOperationsListWidget> createState() =>
      _CustomerOperationsListWidgetState();
}

class _CustomerOperationsListWidgetState
    extends State<CustomerOperationsListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 32.sh),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 20.sw,
        runSpacing: 20.sw,
        children: AppMockList.customerOperationsList
            .map((e) => contentWidget(context: context, categoryObj: e))
            .toList(),
      ),
    );
  }

  Future<void> requestPermission(
      {required BuildContext context,
      required KeyValueModel categoryObj}) async {
    Future.delayed(Duration.zero, () {
      BlocProvider.of<LoadingIndicatorBloc>(context, listen: false)
          .add(LoadingIndicatorEvent.loadingStarted);
    });
    await LocationManagerHandler.shared
        .askForPermission(openAppSettings: true)
        .then((value) async {
      bool havePermission = value ?? false;
      if (havePermission) {
        await BlocProvider.of<LocationCubit>(context, listen: false)
            .getCurrentLocation();

        await Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.pushNamed(context, ConfirmLocationScreen.routeName,
                arguments: categoryObj);
          }
        });
      } else {
        LocationAlert().showAlert(context, isPermissionDenied: true);
      }
      await Future.delayed(Duration.zero, () {
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false)
            .add(LoadingIndicatorEvent.loadingFinished);
      });
    });
  }

  Widget contentWidget(
      {required BuildContext context, required KeyValueModel categoryObj}) {
    return GestureDetector(
      onTap: () async {
        final isLocationEnable =
            await LocationManagerHandler.shared.isLocationEnable();
        if (isLocationEnable) {
          Future.delayed(Duration.zero, () async {
            await requestPermission(context: context, categoryObj: categoryObj);
          });
        } else {
          Future.delayed(
              Duration.zero, () => LocationAlert().showAlert(context));
        }
      },
      child: Container(
        height: 148.sh,
        width: AppUtils.deviceWidth * 0.4,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(width: 1.sw, color: AppColors.appDarkGrey),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 54.sh,
              width: 54.sw,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appYellow,
              ),
              alignment: Alignment.center,
              child: Text(
                categoryObj.value,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 24.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 16.sh),
            Text(
              categoryObj.displayString,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkColorOnForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
