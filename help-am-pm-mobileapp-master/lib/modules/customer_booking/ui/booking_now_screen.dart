import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/upload_file_bloc/upload_file_cubit.dart';
import '../../../core/services/bloc/upload_file_bloc/upload_file_state.dart';
import '../../../core/services/media/media_service.dart';
import '../../../core/services/media/uoload_file_model.dart';
import '../../../core/services/service_locator.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../core_components/common_widgets/upload_pic_dialog_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../feedback/ui/widgets/comment_box_widget.dart';
import '../../onboarding/ui/widgets/upload_icon_widget.dart';
import '../../onboarding/ui/widgets/uploaded_image_widget.dart';
import '../../searching_provider/model/search_provider_req_body_model.dart';
import '../../searching_provider/ui/searching_provider_screen.dart';
import '../bloc/new_booking_bloc/new_booking_bloc.dart';
import '../bloc/new_booking_bloc/new_booking_event.dart';
import '../bloc/new_booking_bloc/new_booking_state.dart';
import '../model/new_booking_req_body_model.dart';
import '../model/service_charge_model.dart';

class BookingNowScreen extends StatefulWidget {
  static const String routeName = "/BookingNowScreen";
  final ServiceChargeModel serviceChargeModel;

  const BookingNowScreen({
    Key? key,
    required this.serviceChargeModel,
  }) : super(key: key);

  @override
  State<BookingNowScreen> createState() => _BookingNowScreenState();
}

class _BookingNowScreenState extends State<BookingNowScreen> {
  TextEditingController textController = TextEditingController();
  final MediaService _mediaService = getIt<MediaService>();
  late UploadFileCubit uploadFileCubit;
  late NewBookingBloc newBookingBloc;

  late DateTime currentDate;
  File? imageFile;
  String imagePath = AppStrings.emptyString;

  bool isLoading = false;
  bool isLoadingForUploadFile = false;

  Widget uploadFileWidget() {
    return GestureDetector(
      onTap: () => {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return UploadPicDialogWidget(
              onCloseBtn: () => Navigator.pop(context),
              onSelected: (AppImageSource appImageSource) {
                AppUtils.debugPrint("Selected : $appImageSource");
                Navigator.pop(context);
                _getImage(appImageSource);
              },
            );
          },
        )
      },
      child: UploadIconWidget(
        bgImageString: AppAssets.linedBoxSvg,
        textColor: AppColors.appOrange,
      ),
    );
  }

  Future _getImage(AppImageSource appImageSource) async {
    final pickedImageFile = await _mediaService
        .uploadImage(context, appImageSource, shouldCompress: false);
    if (pickedImageFile != null) {
      await uploadFileCubit
          .upLoadFile(
            file: pickedImageFile,
            uploadFile: UploadFileModel(
                fileName: AppUtils.getUploadFileName(pickedImageFile.path),
                purpose: FileUploadPurpose.customerOrder.name,
                replace: true),
          )
          .then((value) => setState(() => imageFile = pickedImageFile));
    }
  }

  void setData() {
    newBookingBloc = NewBookingBloc();
    uploadFileCubit = BlocProvider.of<UploadFileCubit>(context);

    currentDate = DateTime.now();
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
        scaffoldBgColor: AppColors.white,
        appTitle: AppStrings.bookNow,
        child: MultiBlocListener(
          listeners: [
            BlocListener<NewBookingBloc, NewBookingState>(
              bloc: newBookingBloc,
              listener: (ctx, state) {
                if (state is NewBookingLoadingState) {
                  setState(() => isLoading = true);
                } else if (state is NewBookingValidState) {
                  newBookingBloc.add(
                    NewBookingSubmittedEvent(
                      sendObj: NewBookingReqBodyModel(
                        categoryName:
                            widget.serviceChargeModel.categoryModel?.name ??
                                AppStrings.emptyString,
                        address: widget.serviceChargeModel.addressModel!,
                        commercialService: widget.serviceChargeModel
                            .categoryModel?.commercialService,
                        residentialService: widget.serviceChargeModel
                            .categoryModel?.residentialService,
                        serviceDescription: textController.text,
                        imagePath: imagePath,
                        isScheduled: false,
                        timeslots: widget.serviceChargeModel.selectedTimeSlot,
                        serviceDate: AppUtils.getDateYYYYMMDD(currentDate),
                      ),
                    ),
                  );
                  setState(() => isLoading = false);
                } else if (state is NewBookingErrorState) {
                  setState(() => isLoading = false);
                  AppUtils.showSnackBar(state.errorMessage,
                      bgColor: state.bgColor);
                } else if (state is NewBookingCompleteState) {
                  AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
                  Future.delayed(
                      const Duration(seconds: 1),
                      () => Navigator.of(context).pushNamedAndRemoveUntil(
                          SearchingProviderScreen.routeName,
                          arguments: SearchProviderReqBodyModel(
                            category:
                                widget.serviceChargeModel.categoryModel?.name ??
                                    AppStrings.emptyString,
                            isResidential: widget.serviceChargeModel
                                    .categoryModel?.residentialService ??
                                false,
                            isCommercial: widget.serviceChargeModel
                                    .categoryModel?.commercialService ??
                                false,
                            latitude: widget.serviceChargeModel.addressModel
                                    ?.latitude ??
                                AppConstants.defaultLatLng.latitude,
                            longitude: widget.serviceChargeModel.addressModel
                                    ?.longitude ??
                                AppConstants.defaultLatLng.longitude,
                            altitude: widget.serviceChargeModel.addressModel
                                    ?.altitude ??
                                30.0,
                            radius: 10000,
                          ),
                          (Route<dynamic> route) => false));
                  return;
                }
              },
            ),
            BlocListener<UploadFileCubit, UploadFileState>(
                bloc: uploadFileCubit,
                listener: (ctx, state) {
                  if (state is UploadFileLoadingState) {
                    setState(() => isLoadingForUploadFile = true);
                  } else if (state is UploadFileErrorState) {
                    setState(() {
                      imageFile = null;
                      imagePath = AppStrings.emptyString;
                      isLoadingForUploadFile = false;
                    });

                    Future.delayed(
                        Duration.zero,
                        () => AppUtils.showSnackBar(state.errorMessage,
                            bgColor: state.bgColor));
                  } else if (state is UploadFileCompleteState) {
                    setState(() {
                      isLoadingForUploadFile = false;
                      imageFile = state.imageFile;
                      imagePath = state.responseModel.uploadedPath ??
                          AppStrings.emptyString;
                    });
                  }
                }),
          ],
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.sh, left: 20.sw),
                    child: Text(
                      AppStrings.jobDescription,
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 18.fs,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                    ),
                  ),
                  CommentBoxWidget(
                    textController: textController,
                    hintText: AppStrings.leaveAComment,
                    textBoxHeight: 180.sh,
                  ),
                  SizedBox(height: 24.sh),
                  Container(
                    color: AppColors.white,
                    padding: EdgeInsets.only(
                        bottom: 24.sh, top: 24.sh, left: 20.sw, right: 20.sw),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              AppStrings.addPhotoOptional,
                              style: AppTextStyles.defaultTextStyle.copyWith(
                                fontSize: 14.fs,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                            (imageFile == null)
                                ? uploadFileWidget()
                                : const Offstage(),
                          ],
                        ),
                        isLoadingForUploadFile
                            ? SizedBox(
                                height: 100.sh,
                                child: const AppLoadingWidget(),
                              )
                            : ((imageFile == null)
                                ? const Offstage()
                                : Padding(
                                    padding: EdgeInsets.only(top: 12.sh),
                                    child: UploadedImageWidget(
                                      imageFile: imageFile,
                                      callback: () => setState(() {
                                        imageFile = null;
                                        imagePath = AppStrings.emptyString;
                                      }),
                                    ),
                                  )),
                        SizedBox(height: 36.sh),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20.sh),
                  child: isLoading
                      ? SizedBox(
                          height: 48.sh,
                          child: const AppLoadingWidget(),
                        )
                      : BottomButtonWidget(
                          buttonTitle: AppStrings.submit,
                          buttonBGColor: AppColors.black,
                          onPressed: () => newBookingBloc.add(
                            NewBookingValidationEvent(
                              textController: textController.text,
                              timeslots:
                                  widget.serviceChargeModel.selectedTimeSlot,
                            ),
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
