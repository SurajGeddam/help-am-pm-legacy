import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:helpampm/utils/app_colors.dart';
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
import '../../../utils/app_enum.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../customer_home/ui/customer_home_screen.dart';
import '../../feedback/ui/widgets/comment_box_widget.dart';
import '../../onboarding/model/category_model/api/category_model.dart';
import '../../onboarding/ui/widgets/choose_category_widgets/choose_category_time_slots_widget.dart';
import '../../onboarding/ui/widgets/upload_icon_widget.dart';
import '../../onboarding/ui/widgets/uploaded_image_widget.dart';
import '../bloc/new_booking_bloc/new_booking_bloc.dart';
import '../bloc/new_booking_bloc/new_booking_event.dart';
import '../bloc/new_booking_bloc/new_booking_state.dart';
import '../model/new_booking_req_body_model.dart';
import '../model/service_charge_model.dart';
import 'widgets/calendar_carousel_widget.dart';

class BookingScheduleScreen extends StatefulWidget {
  static const String routeName = "/BookingScheduleScreen";
  final ServiceChargeModel serviceChargeModel;

  const BookingScheduleScreen({
    Key? key,
    required this.serviceChargeModel,
  }) : super(key: key);

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  TextEditingController textController = TextEditingController();
  final MediaService _mediaService = getIt<MediaService>();
  late UploadFileCubit uploadFileCubit;
  late NewBookingBloc newBookingBloc;

  late DateTime currentDate;
  Color? currentDateColor;
  List<Timeslots> list = [];
  Timeslots? selectedTimeslots;

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
    uploadFileCubit = BlocProvider.of<UploadFileCubit>(context);

    currentDate = DateTime.now();
    currentDateColor = AppColors.appOrange;
    list = widget.serviceChargeModel.categoryModel?.timeslots ?? [];

    for (var element in list) {
      element.isSelected = false;
    }
  }

  @override
  void initState() {
    newBookingBloc = NewBookingBloc();
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffoldWidget(
        appTitle: AppStrings.schedule,
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
                        isScheduled: true,
                        timeslots: selectedTimeslots,
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
                          CustomerHomeScreen.routeName,
                          (Route<dynamic> route) => true));
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
                      isLoadingForUploadFile = false;
                      imageFile = null;
                      imagePath = AppStrings.emptyString;
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
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              CalendarCarouselWidget(
                currentDate: currentDate,
                currentDateColor: currentDateColor,
                minSelectedDate:
                    DateTime.now().subtract(const Duration(days: 1)),
                maxSelectedDate: DateTime(2100),
                // mini
                onDayPressed: (DateTime date, List<Event> events) {
                  setState(() {
                    currentDate = date;
                    currentDateColor = AppColors.transparent;
                  });
                  AppUtils.debugPrint("currentDate = $currentDate");
                },
              ),
              Divider(
                height: 60.sh,
                thickness: 8.sh,
                color: AppColors.grey,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20.sw, right: 20.sw, bottom: 24.sh),
                child: Text(
                  AppStrings.selectSlot,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 15.fs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sw),
                child: ChooseCategoryTimeSlotWidget(
                  categoryModel: widget.serviceChargeModel.categoryModel!,
                  isFromScheduleScreen: true,
                  onTap: (value) {
                    List<Timeslots> list =
                        widget.serviceChargeModel.categoryModel?.timeslots ??
                            [];
                    for (var i in list) {
                      i.isSelected = false;
                    }
                    value.isSelected = true;
                    setState(() => selectedTimeslots = value);
                  },
                ),
              ),
              Divider(
                height: 60.sh,
                thickness: 8.sh,
                color: AppColors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.sh, left: 20.sw),
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
                textBoxHeight: 140.sh,
              ),
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
                    isLoading
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
                                timeslots: selectedTimeslots,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
