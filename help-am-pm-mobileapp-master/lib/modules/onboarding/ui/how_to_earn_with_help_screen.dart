import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../core/services/bloc/loading_indicator_bloc.dart';
import '../../../core_components/common_screens/loading_indicator_screen.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import '../../app_drawer/bloc/logout_cubit.dart';
import 'choose_category_screen.dart';
import 'widgets/stepper_widget.dart';

class HowToEarnWithHelpScreen extends StatefulWidget {
  static const String routeName = "/HowToEarnWithHelpScreen";

  const HowToEarnWithHelpScreen({Key? key}) : super(key: key);

  @override
  State<HowToEarnWithHelpScreen> createState() =>
      _HowToEarnWithHelpScreenState();
}

class _HowToEarnWithHelpScreenState extends State<HowToEarnWithHelpScreen> {
  late LoadingIndicatorBloc loadingIndicatorBloc;
  late LogoutCubit logoutCubit;

  @override
  void initState() {
    loadingIndicatorBloc =
        BlocProvider.of<LoadingIndicatorBloc>(context, listen: false);
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutCubitState>(
      listener: (_, state) {
        if (state == LogoutCubitState.loading) {
          loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingStarted);
        } else if (state == LogoutCubitState.loaded) {
          loadingIndicatorBloc.add(LoadingIndicatorEvent.loadingFinished);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppScaffoldWidget(
            appTitle: AppStrings.howToEarnWithHelp,
            isBackShow: false,
            isLogoutShow: true,
            onLogoutPressed: () => logoutCubit.logoutApi(),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: 24.sh, bottom: 24.sh, left: 20.sw, right: 20.sw),
              physics: const ClampingScrollPhysics(),
              children: [
                SizedBox(
                  height: 180.sh,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    AppAssets.earnWithHelpClipArtSvg,
                    fit: BoxFit.fill,
                  ),
                ),
                StepperWidget(earnWithHelpList: AppMockList.earnWithHelpList),
                SizedBox(height: 24.sh),
                BottomButtonWidget(
                  buttonTitle: AppStrings.continueString,
                  buttonBGColor: AppColors.black,
                  onPressed: () => Navigator.pushNamed(
                      context, ChooseCategoryScreen.routeName),
                )
              ],
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
      ),
    );
  }
}
