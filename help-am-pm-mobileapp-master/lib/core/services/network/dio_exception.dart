import 'package:dio/dio.dart';
import 'package:helpampm/utils/app_strings.dart';

import '../../../utils/app_utils.dart';

class DioExceptions implements Exception {
  String message = "";

  DioExceptions.fromDioError(DioError dioError) {
    AppUtils.debugPrint("dioError.type => ${dioError.type}");
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = AppStrings.dioErrorTypeCancel;
        break;
      case DioExceptionType.connectionTimeout:
        message = AppStrings.dioErrorTypeConnectTimeout;
        break;
      case DioExceptionType.receiveTimeout:
        message = AppStrings.dioErrorTypeReceiveTimeout;
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = AppStrings.dioErrorTypeSendTimeout;
        break;
      case DioExceptionType.unknown:
        if (dioError.message?.contains("SocketException") ?? false) {
          message = AppStrings.dioErrorTypeSocketException;
          break;
        }
        message = AppStrings.dioErrorTypeOther;
        break;
      default:
        message = AppStrings.dioErrorTypeDefault;
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return error['message'] ?? 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        AppUtils.logout();
        return 'Session timeout';
      case 404:
        return error['message'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
