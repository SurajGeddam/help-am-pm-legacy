import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_models/notification_model.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../bloc/notification_cubit/notification_cubit.dart';
import '../bloc/notification_cubit/notification_state.dart';
import 'widgets/notifications_list_widget.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = "/NotificationsScreen";

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationCubit notificationCubit;

  /*void setUpData() {
    Map<String, dynamic> groupByDate = <String, dynamic>{};
    List<GroupByDateModel> list = [];
    groupByDate = groupBy(
        AppMockList.notificationsList, (NotificationModel obj) => obj.header);
    groupByDate.forEach((key, value) {
      list.add(GroupByDateModel(header: key, notificationListObj: value));
    });
  }*/

  @override
  void initState() {
    notificationCubit =
        BlocProvider.of<NotificationCubit>(context, listen: false);
    notificationCubit.fetchNotifications();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.notifications,
      child: BlocConsumer<NotificationCubit, NotificationState>(
          bloc: notificationCubit,
          listener: (_, state) {
            if (state is NotificationErrorState) {
              AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
            }
          },
          builder: (_, state) {
            if (state is NotificationLoadedState) {
              List<NotificationModel> list = state.list;
              if (list.isEmpty) {
                return emptyListWidget();
              } else {
                return NotificationsListWidget(notificationListObj: list);
                /*ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: list.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    NotificationModel item = list[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.sw, vertical: 16.sh),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                item.header,
                                style: AppTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 17.fs,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.sw, vertical: 2.sh),
                                margin: EdgeInsets.symmetric(horizontal: 8.sw),
                                decoration: BoxDecoration(
                                  color: AppColors.appDarkGrey,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  item.delayTime.length.toString(),
                                  style:
                                      AppTextStyles.defaultTextStyle.copyWith(
                                    fontSize: 12.fs,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        NotificationsListWidget(
                          notificationListObj: list,
                        ),
                      ],
                    );
                  },
                );*/
              }
            }
            return const AppLoadingWidget();
          }),
    );
  }

  Widget emptyListWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.sw, right: 20.sw),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.noNewNotification,
            height: 118.sh,
            width: 118.sw,
          ),
          SizedBox(height: 26.sh),
          Text(
            AppStrings.noNewNotifications,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 18.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.appMediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
//
// class GroupByDateModel {
//   final String header;
//   final List<NotificationModel> notificationListObj;
//
//   GroupByDateModel({
//     required this.header,
//     required this.notificationListObj,
//   });
// }
