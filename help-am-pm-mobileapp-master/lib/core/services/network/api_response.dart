import 'package:dio/dio.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'dio_exception.dart';

enum ApiResponseStatus { loading, completed, error }

class ApiResponse<T> {
  late ApiResponseStatus status;
  T? data;
  String messageKey = AppStrings.emptyString;
  dynamic clientError;

  ApiResponse.loading() : status = ApiResponseStatus.loading;

  ApiResponse.completed(this.data) : status = ApiResponseStatus.completed;

  @override
  String toString() {
    return "Status: $status\n\"Message: $messageKey\ndata: $data";
  }

  ApiResponse.error(DioError error)
      : status = ApiResponseStatus.error,
        messageKey = DioExceptions.fromDioError(error).toString(),
        clientError = error;
}
