import 'package:flutter/material.dart';
import 'package:helpampm/core_components/common_models/key_value_model.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../../../customer_booking/model/service_charge_model.dart';
import '../../../../customer_booking/ui/booking_selection_screen.dart';
import '../../../model/category_model/api/category_model.dart';
import 'choose_category_text_box_widget.dart';
import 'choose_category_text_box_with_image_widget.dart';
import 'select_time_slots_widget.dart';

class ChooseCategoryListViewWidget extends StatelessWidget {
  final List<CategoryModel> list;
  final SaveAddressReqBodyModel? addressModel;
  final KeyValueModel? categoryObj;

  const ChooseCategoryListViewWidget({
    Key? key,
    required this.list,
    this.addressModel,
    this.categoryObj,
  }) : super(key: key);

  void bottomSheetWidget(
    BuildContext ctx,
    CategoryModel obj,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: AppColors.transparent,
      builder: (ctx) => SelectTimeSlotsWidget(obj: obj),
    );
  }

  _onPressed(
    BuildContext context, {
    bool isRoleCustomer = false,
    CategoryModel? obj,
    required CategoryModel cardObj,
  }) {
    if (cardObj.timeslots?.isEmpty ?? false) {
      return;
    }
    if (isRoleCustomer) {
      cardObj.residentialService = obj?.residentialService;
      cardObj.commercialService = obj?.commercialService;
      Navigator.pushNamed(context, BookingSelectionScreen.routeName,
          arguments: ServiceChargeModel(
            categoryModel: cardObj,
            addressModel: addressModel,
          ));
    } else {
      bottomSheetWidget(context, cardObj);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRoleCustomer = AppUtils.getIsRoleCustomer();
    List<CategoryModel> newList = [];

    if (isRoleCustomer) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].name == categoryObj?.displayString) {
          newList.add(list[i]);
          break;
        }
      }
    } else {
      newList = list;
    }

    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: newList.length,
        itemBuilder: (BuildContext ctx, int index) {
          CategoryModel cardObj = newList[index];
          return Container(
            margin: EdgeInsets.only(top: 21.sh, left: 19.sw, right: 19.sw),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.sw,
                color: AppColors.appThinGrey,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 9.sh),
                  alignment: Alignment.center,
                  child: Text(
                    cardObj.name ?? AppStrings.emptyString,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      color: AppColors.lightBlackColor,
                      fontSize: 18.fs,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  height: 1.sh,
                  thickness: 1.sh,
                  color: AppColors.appThinGrey,
                ),
                isRoleCustomer
                    ? firstRowWithIcon(context, cardObj, isRoleCustomer)
                    : firstRow(context, cardObj, isRoleCustomer),

                // firstRow(context, cardObj, isRoleCustomer),
                (isRoleCustomer)
                    ? const Offstage()
                    : InkWell(
                        onTap: () {
                          CategoryModel obj = CategoryModel(
                              id: cardObj.id,
                              commercialService: true,
                              residentialService: true);
                          _onPressed(
                            context,
                            isRoleCustomer: isRoleCustomer,
                            obj: obj,
                            cardObj: cardObj,
                          );
                        },
                        child: Container(
                          height: 44.sh,
                          margin: EdgeInsets.only(
                              left: 25.sw, right: 25.sw, bottom: 21.sh),
                          decoration: BoxDecoration(
                            color: AppColors.appDarkOrange,
                            border: Border.all(
                              width: 1.sw,
                              color: AppColors.appThinGrey,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.both,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              color: AppColors.white,
                              fontSize: 14.fs,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
  }

  Widget firstRowWithIcon(
      BuildContext context, CategoryModel cardObj, bool isRoleCustomer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ChooseCategoryTextBoxWithImageWidget(
          text: AppStrings.residential,
          assetName: AppAssets.residentialIcon,
          onPressed: () {
            CategoryModel obj = CategoryModel(
              id: cardObj.id,
              commercialService: false,
              residentialService: true,
            );
            _onPressed(
              context,
              isRoleCustomer: isRoleCustomer,
              obj: obj,
              cardObj: cardObj,
            );
          },
        ),
        ChooseCategoryTextBoxWithImageWidget(
          text: AppStrings.commercial,
          assetName: AppAssets.commercialIcon,
          onPressed: () {
            CategoryModel obj = CategoryModel(
              id: cardObj.id,
              commercialService: true,
              residentialService: false,
            );
            _onPressed(
              context,
              isRoleCustomer: isRoleCustomer,
              obj: obj,
              cardObj: cardObj,
            );
          },
        ),
      ],
    );
  }

  Widget firstRow(
      BuildContext context, CategoryModel cardObj, bool isRoleCustomer) {
    return Padding(
      padding:
          EdgeInsets.only(left: 25.sw, right: 25.sw, top: 21.sh, bottom: 16.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ChooseCategoryTextBoxWidget(
            text: AppStrings.residential,
            onPressed: () {
              CategoryModel obj = CategoryModel(
                id: cardObj.id,
                commercialService: false,
                residentialService: true,
              );
              _onPressed(
                context,
                isRoleCustomer: isRoleCustomer,
                obj: obj,
                cardObj: cardObj,
              );
            },
          ),
          SizedBox(width: 20.sw),
          ChooseCategoryTextBoxWidget(
            text: AppStrings.commercial,
            onPressed: () {
              CategoryModel obj = CategoryModel(
                id: cardObj.id,
                commercialService: true,
                residentialService: false,
              );
              _onPressed(
                context,
                isRoleCustomer: isRoleCustomer,
                obj: obj,
                cardObj: cardObj,
              );
            },
          ),
        ],
      ),
    );
  }
}
