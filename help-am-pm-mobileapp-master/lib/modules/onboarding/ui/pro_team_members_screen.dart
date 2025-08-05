import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import '../../provider_home/ui/provider_home_screen.dart';
import 'widgets/horizontal_stepper_widget.dart';
import 'widgets/pro_team_member_form_widgets/pro_team_member_form_widget.dart';
import 'widgets/pro_team_member_form_widgets/uploaded_doc_submitted_widget.dart';

class ProTeamMembersScreen extends StatefulWidget {
  static const String routeName = "/ProTeamMembersScreen";

  const ProTeamMembersScreen({Key? key}) : super(key: key);

  @override
  State<ProTeamMembersScreen> createState() => _ProTeamMembersScreenState();
}

class _ProTeamMembersScreenState extends State<ProTeamMembersScreen> {
  setData() {
    for (int i = 0; i < AppMockList.userInputDetailList.length; i++) {
      AppMockList.userInputDetailList[i].isSelected = true;
      if (InputFormType.proTeamMembers.code ==
          AppMockList.userInputDetailList[i].key) {
        break;
      }
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        appTitle: AppStrings.proTeamMembers,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(left: 20.sh, right: 20.sw, top: 20.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    AppStrings.companyProTeamMemberInformation,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 16.fs,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 29.sh),
                  HorizontalStepperWidget(
                    userInputDetailList: AppMockList.userInputDetailList,
                  ),
                  SizedBox(height: 29.sh),
                  const Expanded(child: ProTeamMemberFormWidget()),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
                child: BottomButtonWidget(
                  buttonTitle: AppStrings.next,
                  buttonBGColor: AppColors.black,
                  onPressed: () => {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  ProviderHomeScreen.routeName,
                                  (Route<dynamic> route) => false),
                          child: const UploadedDocSubmittedWidget(),
                        );
                      },
                    )
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
