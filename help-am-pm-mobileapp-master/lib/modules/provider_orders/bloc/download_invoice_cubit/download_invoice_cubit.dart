import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';
import 'package:helpampm/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../utils/app_strings.dart';
import 'download_invoice_state.dart';

class DownloadInvoiceCubit extends Cubit<DownloadInvoiceState> {
  DownloadInvoiceCubit() : super(DownloadInvoiceInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<void> downloadInvoice(String quoteUniqueId) async {
    emit(InvoiceDownloadLoadingState());

    ApiResponse<String> response =
        await appRepositoryValidation.downloadInvoice(id: quoteUniqueId);
    if (response.status == ApiResponseStatus.completed) {
      PdfDocument document = PdfDocument.fromBase64String(response.data!);
      String? dir = await AppUtils.getDownloadPath();
      File file = File('$dir/$quoteUniqueId.pdf');
      List<int> bytes = await document.save();
      await file.writeAsBytes(bytes);
      emit(InvoiceDownloadLoadedState(AppStrings.savedSuccessfully));
    } else {
      emit(InvoiceDownloadErrorState(response.messageKey));
    }
  }
}
