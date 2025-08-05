import 'dart:ui';

import '../../../../utils/app_colors.dart';

abstract class DownloadInvoiceState {}

class DownloadInvoiceInitialState extends DownloadInvoiceState {}

class InvoiceDownloadLoadingState extends DownloadInvoiceState {}

class InvoiceDownloadLoadedState extends DownloadInvoiceState {
  final String message;
  final Color bgColor;

  InvoiceDownloadLoadedState(this.message, {this.bgColor = AppColors.green});
}

class InvoiceDownloadErrorState extends DownloadInvoiceState {
  final String errorMessage;
  final Color bgColor;

  InvoiceDownloadErrorState(this.errorMessage,
      {this.bgColor = AppColors.black});
}
