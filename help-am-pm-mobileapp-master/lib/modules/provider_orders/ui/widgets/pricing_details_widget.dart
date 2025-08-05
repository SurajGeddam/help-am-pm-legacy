import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../utils/app_constant.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import '../../bloc/add_remove_item_bloc/add_remove_item_bloc.dart';
import '../../bloc/add_remove_item_bloc/add_remove_item_event.dart';
import '../../bloc/add_remove_item_bloc/add_remove_item_state.dart';
import '../../bloc/download_invoice_cubit/download_invoice_cubit.dart';
import '../../bloc/download_invoice_cubit/download_invoice_state.dart';
import '../../model/item_details_model.dart';
import 'add_new_item_with_price_widget.dart';

class PricingDetailsWidget extends StatefulWidget {
  final Quotes scheduleOrder;

  const PricingDetailsWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<PricingDetailsWidget> createState() => _PricingDetailsWidgetState();
}

class _PricingDetailsWidgetState extends State<PricingDetailsWidget> {
  late AddRemoveItemBloc addRemoveItemBloc;
  late DownloadInvoiceCubit downloadInvoiceCubit;

  List<ItemDetails> itemList = [];
  bool isLoading = false;

  String taxAmount = "0.00";
  String totalQuotePrice = "0.00";

  void bottomSheetWidget() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: AppColors.transparent,
        builder: (BuildContext context) {
          return AddNewItemWithPriceWidget(
            itemId: itemList.length,
            quoteUniqueId: widget.scheduleOrder.orderNumber,
            callBack: (value) => setState(() {
              ItemDetails obj = value;
              taxAmount = obj.taxAmount;
              totalQuotePrice = obj.totalQuotePrice;
              itemList.add(obj);
            }),
          );
        });
  }

  @override
  void initState() {
    downloadInvoiceCubit = DownloadInvoiceCubit();
    addRemoveItemBloc =
        BlocProvider.of<AddRemoveItemBloc>(context, listen: false);

    taxAmount = widget.scheduleOrder.taxAmount.toStringAsFixed(2);
    totalQuotePrice = widget.scheduleOrder.totalBill.toStringAsFixed(2);

    if (widget.scheduleOrder.items?.isNotEmpty ?? false) {
      List<ItemDetails>? tempList = [];
      itemList = [];

      tempList = widget.scheduleOrder.items;
      if (tempList != null) {
        itemList = tempList;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.sw, right: 20.sw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  AppStrings.pricingDetails,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              if (widget.scheduleOrder.status == AppConstants.paymentDone)
                _downloadInvoiceWidget(),
              (widget.scheduleOrder.status == AppConstants.paymentPending ||
                          widget.scheduleOrder.status ==
                              AppConstants.paymentDone) ||
                      AppUtils.getIsRoleCustomer()
                  ? const Offstage()
                  : GestureDetector(
                      onTap: () {
                        bottomSheetWidget();
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(AppStrings.addItems,
                                style: AppTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 14.fs,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textDarkColorOnForm,
                                ),
                                textAlign: TextAlign.right),
                            SizedBox(width: 6.sw),
                            Icon(Icons.add_circle_rounded,
                                color: AppColors.appGreen),
                          ]),
                    ),
            ],
          ),
        ),
        BlocListener<AddRemoveItemBloc, AddRemoveItemState>(
          bloc: addRemoveItemBloc,
          listener: (ctx, state) {
            if (state is AddRemoveItemLoadingState) {
              setState(() => isLoading = true);
            } else if (state is AddRemoveItemErrorState) {
              setState(() => isLoading = false);
              AppUtils.showSnackBar(state.errorMessage);
            } else if (state is AddRemoveItemCompleteState) {
              int index = state.itemDetails.quoteItemId;
              setState(() {
                isLoading = false;
                if (state.itemDetails.isFromDelete) {
                  ItemDetails obj = state.itemDetails;
                  taxAmount = obj.taxAmount;
                  totalQuotePrice = obj.totalQuotePrice;
                  itemList
                      .removeWhere((element) => (element.quoteItemId == index));
                }
              });
            }
          },
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: itemList.length,
            itemBuilder: (_, i) {
              return itemPriceWidget(
                  title: itemList[i].description,
                  value: itemList[i].itemPrice.toStringAsFixed(2),
                  onPressed: () {
                    addRemoveItemBloc.add(AddRemoveItemSubmittedEvent(
                      quoteItemId: itemList[i].quoteItemId,
                      quoteUniqueId: widget.scheduleOrder.orderNumber,
                      description: itemList[i].description,
                      itemPrice: itemList[i].itemPrice.toStringAsFixed(2),
                      isFromDelete: true,
                    ));
                  });
            },
          ),
        ),
        itemPriceWidget(
          title: AppStrings.serviceCallCharges,
          value: widget.scheduleOrder.serviceCharge.toStringAsFixed(2),
          isTotalPrice: false,
          isTaxAmount: true,
        ),
        itemPriceWidget(
          title: AppStrings.taxAmount,
          value: taxAmount,
          isTotalPrice: false,
          isTaxAmount: true,
        ),
        itemPriceWidget(
          title: AppStrings.totalPayment,
          value: totalQuotePrice,
          isTotalPrice: true,
        ),
      ],
    );
  }

  Widget itemPriceWidget({
    required String title,
    required String value,
    bool isTotalPrice = false,
    bool isTaxAmount = false,
    VoidCallback? onPressed,
  }) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 8.sh, left: 20.sw, right: 20.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(title,
                style: _textStyle(isTotalPrice), textAlign: TextAlign.left),
          ),
          Text("${AppConstants.dollorSign}$value",
              style: _textStyle(isTotalPrice), textAlign: TextAlign.right),
          SizedBox(width: 6.sw),
          ((isTotalPrice || isTaxAmount) ||
                  (widget.scheduleOrder.status == AppConstants.paymentPending ||
                      widget.scheduleOrder.status ==
                          AppConstants.paymentDone) ||
                  AppUtils.getIsRoleCustomer())
              ? SizedBox(width: 24.sw)
              : GestureDetector(
                  onTap: onPressed,
                  child: Icon(Icons.remove_circle_rounded,
                      color: AppColors.appRed),
                ),
        ],
      ),
    );
  }

  TextStyle _textStyle(bool isTotalPrice) {
    return isTotalPrice
        ? AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 16.fs,
            fontWeight: FontWeight.w500,
            color: AppColors.textDarkColorOnForm,
          )
        : AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 14.fs,
            fontWeight: FontWeight.w400,
            color: AppColors.textDarkColorOnForm,
          );
  }

  Widget _downloadInvoiceWidget() {
    return BlocListener<DownloadInvoiceCubit, DownloadInvoiceState>(
      bloc: downloadInvoiceCubit,
      listener: (ctx, state) {
        if (state is InvoiceDownloadLoadingState) {
          setState(() => isLoading = true);
        } else if (state is InvoiceDownloadErrorState) {
          setState(() => isLoading = false);
          AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
        } else if (state is InvoiceDownloadLoadedState) {
          setState(() => isLoading = false);
          AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
        }
      },
      child: GestureDetector(
        onTap: () => downloadInvoiceCubit
            .downloadInvoice(widget.scheduleOrder.orderNumber),
        child: Container(
          color: Colors.transparent,
          child: Icon(
            Icons.download_for_offline_sharp,
            color: AppColors.appDarkOrange,
            size: 30.sh,
          ),
        ),
      ),
    );
  }
}
