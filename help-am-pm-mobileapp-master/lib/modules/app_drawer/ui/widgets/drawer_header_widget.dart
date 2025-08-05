import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../login/model/login_model/auth_token_model.dart';
import '../../../profile/ui/profile_screen.dart';
import '../../bloc/user_dto_cubit.dart';
import '../../bloc/user_dto_state.dart';

class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  State<DrawerHeaderWidget> createState() => _DrawerHeaderWidget();
}

class _DrawerHeaderWidget extends State<DrawerHeaderWidget> {
  late UserDtoCubit userDtoCubit;
  String profilePicture = AppStrings.emptyString;

  @override
  void initState() {
    userDtoCubit = BlocProvider.of<UserDtoCubit>(context, listen: false);
    userDtoCubit.getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDtoCubit, UserDtoState>(
        bloc: userDtoCubit,
        builder: (ctx, state) {
          if (state is UserDtoLoadedState) {
            UserDetailsDto userDetailsDto = state.userDetailsDto;
            return Container(
              width: AppUtils.deviceWidth,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  tileMode: TileMode.repeated,
                  colors: [
                    Color(0xFFFBB034),
                    Color(0xFFFFDD00),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 68.sh,
                    width: 68.sw,
                    margin: EdgeInsets.only(left: 20.sw, right: 14.sw),
                    decoration: userDetailsDto.profileBytes.isNotEmpty
                        ? null
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textDarkColorOnForm,
                            image: userDetailsDto.profilePicture.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                        userDetailsDto.profilePicture.trim()),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                    alignment: Alignment.center,
                    child: userDetailsDto.profileBytes.isNotEmpty
                        ? SizedBox(
                            height: 68.sh,
                            width: 68.sw,
                            child: CircleAvatar(
                              radius: 68.0,
                              backgroundImage: MemoryImage(
                                AppUtils.convertImage(
                                    userDetailsDto.profileBytes),
                              ),
                              backgroundColor: AppColors.transparent,
                            ),
                          )
                        : Text(
                            userDetailsDto.name.isNotEmpty
                                ? userDetailsDto.name.substring(0, 1)
                                : userDetailsDto.name,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 20.sh),
                      children: [
                        Text(
                          userDetailsDto.name,
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 16.fs,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 6.sh),
                        Text(
                          userDetailsDto.email,
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 14.fs,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textMediumColorOnForm,
                          ),
                        ),
                        SizedBox(height: 4.sh),
                        Text(
                          userDetailsDto.phone,
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 14.fs,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textMediumColorOnForm,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, ProfileScreen.routeName),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sw),
                      child: Text(
                        AppStrings.edit,
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 16.fs,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const AppLoadingWidget();
        });
  }
}
