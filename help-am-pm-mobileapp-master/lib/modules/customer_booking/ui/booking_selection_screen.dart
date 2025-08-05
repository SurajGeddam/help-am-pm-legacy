import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_utils.dart';
import 'package:intl/intl.dart';

import '../../../core_components/common_widgets/app_checkbox_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../bloc/booking_selection_cubit/booking_selection_cubit.dart';
import '../model/service_charge_model.dart';
import 'booking_now_screen.dart';
import 'booking_schedule_screen.dart';
import 'widgets/list_view_with_header_widget.dart';
import 'widgets/row_image_text_widget.dart';
import 'widgets/selection_yellow_card_widget.dart';

class BookingSelectionScreen extends StatefulWidget {
  static const String routeName = "/BookingSelectionScreen";
  final ServiceChargeModel serviceChargeModel;

  const BookingSelectionScreen({
    Key? key,
    required this.serviceChargeModel,
  }) : super(key: key);

  @override
  State<BookingSelectionScreen> createState() => _BookingSelectionScreenState();
}

class _BookingSelectionScreenState extends State<BookingSelectionScreen> {
  late BookingSelectionCubit bookingSelectionCubit;
  late ServiceChargeModel serviceCharge;
  String displayPrice = AppStrings.emptyString;
  bool isTncFlag = false;

  void init() {
    bookingSelectionCubit = BookingSelectionCubit();
    serviceCharge = bookingSelectionCubit
        .calculateTimePrice(widget.serviceChargeModel.categoryModel);

    widget.serviceChargeModel.selectedTimeSlot = serviceCharge.selectedTimeSlot;
    widget.serviceChargeModel.currencySymbol = serviceCharge.currencySymbol;
    widget.serviceChargeModel.displayPrice = serviceCharge.displayPrice;

    displayPrice =
        "${serviceCharge.currencySymbol}${serviceCharge.displayPrice.toStringAsFixed(2)}";
  }

  bool isValidateTime() {
    DateTime now = DateTime.now();

    DateFormat dateFormat = DateFormat.Hm();
    DateTime startTime = dateFormat.parse("22:00");
    startTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);

    DateTime endTime = dateFormat.parse("09:00");
    endTime = DateTime(
        now.year, now.month, now.day + 1, endTime.hour, endTime.minute);
    AppUtils.debugPrint("startTime: $startTime  endTime: $endTime");

    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkBookNowBtnValidation() {
    bool value = false;

    if (serviceCharge.displayPrice == 0.0) {
      value = true;
    } else if (isValidateTime()) {
      value = true;
    } else if (!isTncFlag) {
      value = true;
    } else {
      value = false;
    }
    return value;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              height: AppUtils.deviceHeight,
              width: AppUtils.deviceWidth,
              padding: EdgeInsets.all(20.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      RowImageTextWidget(
                        imageString: AppAssets.timeIconSvg,
                        imageColor: AppColors.appMediumGrey,
                        text: AppUtils.getDateHhMmA(DateTime.now()),
                      ),
                      RowImageTextWidget(
                        imageString: AppAssets.calenderIconSvg,
                        imageColor: AppColors.appMediumGrey,
                        text: AppUtils.getFormattedDate(DateTime.now(),
                            formatString: AppConstants.dateFormatDDMMMYY),
                      )
                    ],
                  ),
                  SelectionYellowCardWidget(displayPrice: displayPrice),
                  const Expanded(
                    child: ListViewWithHeaderWidget(
                        headerString: AppStrings.briefDisclaimer,
                        list: [
                          AppStrings.briefDisclaimerMsg0,
                          AppStrings.briefDisclaimerMsg1,
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppCheckBoxWidget(
                      padding: EdgeInsets.symmetric(horizontal: 0.sh),
                      customWidget: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: AppStrings.iAgreeTo,
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            color: AppColors.appLightGrey,
                            fontSize: 12.fs,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: AppStrings.termsAndConditions,
                              style: AppTextStyles.defaultTextStyle.copyWith(
                                color: AppColors.appOrange,
                                fontSize: 12.fs,
                                fontWeight: FontWeight.w400,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => AppUtils.launchDeepLinkURL(),
                            ),
                          ],
                        ),
                      ),
                      onTap: (value) => setState(() => isTncFlag = value)),
                  SizedBox(height: 24.sh),
                  isValidateTime()
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 8.sh),
                          child: Text(
                            AppStrings.timeLimitMsg,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 12.fs,
                              fontWeight: FontWeight.w500,
                              color: AppColors.red,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : const Offstage(),
                  BottomButtonWidget(
                    isDisable: checkBookNowBtnValidation(),
                    buttonTitle: AppStrings.bookNow,
                    buttonBGColor: AppColors.black,
                    onPressed: (serviceCharge.displayPrice == 0.0)
                        ? null
                        : () => Navigator.pushNamed(
                            context, BookingNowScreen.routeName,
                            arguments: widget.serviceChargeModel),
                  ),
                  SizedBox(height: 14.sh),
                  BottomButtonWidget(
                    isDisable: !isTncFlag,
                    buttonTitle: AppStrings.schedule,
                    isOutlineBtn: true,
                    buttonBGColor: AppColors.white,
                    onPressed: () => Navigator.pushNamed(
                        context, BookingScheduleScreen.routeName,
                        arguments: widget.serviceChargeModel),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
