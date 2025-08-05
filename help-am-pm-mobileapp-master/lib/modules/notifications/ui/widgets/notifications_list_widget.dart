import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../core_components/common_models/notification_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';

class NotificationsListWidget extends StatelessWidget {
  final List<NotificationModel> notificationListObj;

  const NotificationsListWidget({
    Key? key,
    required this.notificationListObj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notificationListObj.length,
      itemBuilder: (BuildContext ctx, int index) {
        NotificationModel notificationObj = notificationListObj[index];
        return Container(
          padding: EdgeInsets.only(
              left: 20.sw, right: 20.sw, top: (index == 0) ? 20.sh : 0.sh),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  /*CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 24.r,
                    backgroundImage:
                        NetworkImage(notificationObj.notificationPic!),
                    child: notificationObj.isRead
                        ? const Offstage()
                        : Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 14.sh,
                              width: 14.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                color: AppColors.appOrange,
                              ),
                            ),
                          ),
                  ),*/
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notificationObj.title,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 14.fs,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 4.sh),
                          Text(
                            notificationObj.description,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 14.fs,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textColorOnForm,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                  Text(
                    notificationObj.delayTime,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 12.fs,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 36.sh,
                thickness: 1.sh,
                color: AppColors.dividerColor,
              )
            ],
          ),
        );
      },
    );
  }
}
