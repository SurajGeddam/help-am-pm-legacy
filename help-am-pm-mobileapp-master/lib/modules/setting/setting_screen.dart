import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core_components/common_widgets/app_loading_widget.dart';
import 'package:helpampm/core_components/common_widgets/app_scaffold_widget.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../core/services/bloc/loading_indicator_bloc.dart';
import '../../core_components/common_screens/loading_indicator_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';
import '../profile/bloc/provider_profile_cubit/provider_profile_cubit.dart';
import '../profile/bloc/provider_profile_cubit/provider_profile_state.dart';
import '../profile/model/provider_profile_model.dart';
import 'bloc/notification_setting_cubit.dart';
import 'bloc/notification_setting_state.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = "/SettingScreen";

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late NotificationSettingBloc notificationSettingBloc;
  late LoadingIndicatorBloc loadingIndicatorBloc;
  late ProfileCubit profileCubit;

  @override
  void initState() {
    notificationSettingBloc = NotificationSettingBloc();
    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);

    profileCubit = BlocProvider.of<ProfileCubit>(context, listen: false);
    profileCubit.fetchProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppScaffoldWidget(
          appTitle: AppStrings.settings,
          child:
              BlocListener<NotificationSettingBloc, NotificationSettingState>(
            bloc: notificationSettingBloc,
            listener: (ctx, state) {
              if (state is NotificationSettingLoadingState) {
                loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingStarted);
              } else if (state is NotificationSettingLoadedState) {
                loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingFinished);
                profileCubit.fetchProfile();
                AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
              } else if (state is NotificationSettingErrorState) {
                loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingFinished);
                AppUtils.showSnackBar(state.errorMessage,
                    bgColor: state.bgColor);
              }
            },
            child: BlocBuilder<ProfileCubit, ProfileState>(
                bloc: profileCubit,
                builder: (ctx, state) {
                  if (state is ProfileLoadedState) {
                    ProfileModel profileModel = state.providerProfile;
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        rowWidget(AppConstants.sms, AppStrings.sms,
                            profileModel.smsEnable),
                        Divider(
                          height: 1.sh,
                          thickness: 1.sh,
                          color: AppColors.dividerColor,
                        ),
                        rowWidget(AppConstants.email, AppStrings.email,
                            profileModel.emailEnable),
                        Divider(
                          height: 1.sh,
                          thickness: 1.sh,
                          color: AppColors.dividerColor,
                        ),
                      ],
                    );
                  }
                  return const AppLoadingWidget();
                }),
          ),
        ),
        BlocBuilder<LoadingIndicatorBloc, LoadingIndicatorState>(
          bloc: loadingIndicatorBloc,
          builder: (_, state) {
            if (state == LoadingIndicatorState.loading) {
              return const LoadingIndicatorScreen();
            }
            return const Offstage();
          },
        ),
      ],
    );
  }

  Widget rowWidget(String type, String title, bool value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 18.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.textMediumColorOnForm,
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: (value) {
              notificationSettingBloc.notificationSetting(
                  type: type, enabled: value);
            },
          ),
        ],
      ),
    );
  }
}
