import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_strings.dart';
import '../../../../utils/app_colors.dart';
import '../../media/uoload_file_model.dart';
import '../../model/upload_file_response_model.dart';
import '../../network/api_response.dart';
import '../../repositories/app_repository_validation.dart';
import '../../service_locator.dart';
import 'upload_file_state.dart';

class UploadFileCubit extends Cubit<UploadFileState> {
  UploadFileCubit() : super(UploadFileInitialState());
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<String> upLoadFile({
    required File file,
    required UploadFileModel uploadFile,
  }) async {
    String? uploadedPath;
    emit(UploadFileLoadingState());
    ApiResponse<UploadFileResponseModel> response =
        await appRepositoryValidation.uploadFile(
      file: file,
      uploadFile: uploadFile,
    );
    if (response.status == ApiResponseStatus.completed) {
      emit(UploadFileCompleteState(
        responseModel: response.data!,
        imageFile: file,
      ));
      uploadedPath = response.data!.uploadedPath;
    } else {
      emit(UploadFileErrorState(response.messageKey, bgColor: AppColors.red));
    }
    return uploadedPath ?? AppStrings.emptyString;
  }
}
