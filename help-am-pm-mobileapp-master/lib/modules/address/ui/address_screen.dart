import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/google_search/google_search.dart';
import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/data_not_available_widget.dart';
import '../../../utils/app_strings.dart';
import '../bloc/address_cubit/address_cubit.dart';
import '../bloc/address_cubit/address_state.dart';
import '../model/save_address_model/request_body/save_address_req_body_model.dart';
import 'save_new_address_screen.dart';
import 'widgets/address_card_widget.dart';
import 'widgets/header_row_widget.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/AddressScreen";
  final bool isFromChangeLocation;

  const AddressScreen({
    Key? key,
    this.isFromChangeLocation = false,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late AddressCubit addressCubit;
  List<SaveAddressReqBodyModel> addressList = [];

  void onPressSaveAddress(
      {SaveAddressReqBodyModel? addressModel,
      bool isForNewAddress = false}) async {
    if (isForNewAddress) {
      await Navigator.pushNamed(context, GoogleSearchScreen.routeName);
    } else {
      await Navigator.pushNamed(context, SaveNewAddressScreen.routeName,
          arguments: {
            "address": addressModel,
            "isForUpdateAddress": true,
          });
    }
  }

  void onSelect(SaveAddressReqBodyModel obj) {
    setState(() {
      for (var e in addressList) {
        e.isDefault = false;
      }
      obj.isDefault = true;
    });
  }

  @override
  void initState() {
    addressCubit = BlocProvider.of<AddressCubit>(context, listen: false);
    addressCubit.fetchAddress();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.savedAddress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderRowWidget(
            text1: AppStrings.savedAddress,
            text2: AppStrings.addNewAddress,
            onPressed: () => onPressSaveAddress(isForNewAddress: true),
          ),
          BlocBuilder<AddressCubit, AddressState>(
              bloc: addressCubit,
              builder: (context, state) {
                if (state is AddressLoadedState) {
                  addressList = state.list;
                  return addressList.isEmpty
                      ? const Expanded(child: DataNotAvailableWidget())
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: addressList.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              SaveAddressReqBodyModel obj = addressList[index];
                              return AddressCardWidget(
                                isFromChangeLocation:
                                    widget.isFromChangeLocation,
                                address: obj,
                                onSelect: (obj) => onSelect(obj),
                                onPressed: () => widget.isFromChangeLocation
                                    ? Navigator.pop(context, obj)
                                    : onPressSaveAddress(addressModel: obj),
                              );
                            },
                          ),
                        );
                } else if (state is AddressErrorState) {
                  return AppErrorMessageWidget(
                    errorMessage: state.errorMessage,
                  );
                }
                return const Expanded(child: AppLoadingWidget());
              })
        ],
      ),
    );
  }
}
