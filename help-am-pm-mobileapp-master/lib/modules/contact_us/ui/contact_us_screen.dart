import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../contact_us_cubit/contact_us_cubit.dart';
import '../contact_us_cubit/contact_us_state.dart';
import '../model/contact_us_model.dart';

class ContactUsScreen extends StatelessWidget {
  static const String routeName = "/ContactUsScreen";

  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactUsCubit, ContactUsState>(
        bloc: ContactUsCubit(),
        builder: (ctx, state) {
          if (state is ContactUsErrorState) {
            return AppErrorMessageWidget(
              errorMessage: state.errorMessage,
              textColor: state.bgColor,
            );
          } else if (state is ContactUsLoadedState) {
            List<ContactUsModel> contactUsList = state.contactUsModelList;
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: contactUsList.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (BuildContext ctx, int index) {
                  ContactUsModel contactUsObj = contactUsList[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 60.sh,
                        width: AppUtils.deviceWidth,
                        padding: EdgeInsets.symmetric(horizontal: 20.sw),
                        child: GestureDetector(
                          onTap: () async => await AppUtils.makePhoneCall(
                              contactUsObj.helpPhone),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                AppAssets.contactUsIconSvg,
                                height: 20.sh,
                                fit: BoxFit.cover,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 12.sw),
                              Text(
                                AppStrings.talkToUs,
                                style: AppTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 16.fs,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60.sh,
                        width: AppUtils.deviceWidth,
                        padding: EdgeInsets.symmetric(horizontal: 20.sw),
                        child: GestureDetector(
                          onTap: () async => await AppUtils.sendEmail(
                              contactUsObj.helpEmail, '', ''),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                AppAssets.emailSvgIcon,
                                height: 20.sh,
                                fit: BoxFit.cover,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 12.sw),
                              Text(
                                AppStrings.sendEmailToUs,
                                style: AppTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 16.fs,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
          return const AppLoadingWidget();
        });
  }
}
