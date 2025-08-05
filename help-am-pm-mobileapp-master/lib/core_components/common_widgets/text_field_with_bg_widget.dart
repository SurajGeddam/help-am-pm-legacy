import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../core/services/model/country_code_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_enum.dart';
import '../../utils/app_regex_constant.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class TextFieldWithBgWidget extends StatefulWidget {
  final String? bgImage;
  final Color? bgColor;
  final String? textFieldIcon;
  final String? hintText;
  final TextEditingController? textController;
  final TextInputAction? textInputAction;
  final bool isObscureText;
  final int maxLength;
  final TextFormFieldType? textFormFieldType;
  final int phoneNumberSize;
  final bool isDropdownButton;
  final List<CountryCodeModel>? countyCodeList;
  final Function? onSelectCountryCode;

  const TextFieldWithBgWidget({
    Key? key,
    this.bgImage,
    this.bgColor,
    this.textFieldIcon,
    this.hintText,
    this.textController,
    this.textInputAction,
    this.isObscureText = false,
    this.maxLength = 100,
    this.textFormFieldType,
    this.phoneNumberSize = 10,
    this.isDropdownButton = false,
    this.countyCodeList,
    this.onSelectCountryCode,
  }) : super(key: key);

  @override
  State<TextFieldWithBgWidget> createState() => _TextFieldWithBgWidgetState();
}

class _TextFieldWithBgWidgetState extends State<TextFieldWithBgWidget> {
  bool isObscureText = false;
  String countryDialCode = AppStrings.emptyString;

  @override
  void initState() {
    isObscureText = widget.isObscureText;
    countryDialCode =
        widget.countyCodeList?.first.dialCode ?? AppStrings.emptyString;
    super.initState();
  }

  /// return keyboard type
  TextInputType _keyboard() {
    if (widget.textFormFieldType == TextFormFieldType.email) {
      return TextInputType.emailAddress;
    }
    if (widget.textFormFieldType == TextFormFieldType.phone) {
      return TextInputType.phone;
    }
    if (widget.textFormFieldType == TextFormFieldType.price) {
      return const TextInputType.numberWithOptions(
          decimal: true, signed: false);
    }
    return TextInputType.text;
  }

  /// allow text based on the text field type
  List<TextInputFormatter> _inputFormatter() {
    if (widget.textFormFieldType == TextFormFieldType.phone) {
      return [
        LengthLimitingTextInputFormatter(widget.phoneNumberSize),
        FilteringTextInputFormatter.allow(RegExp(regExpPhoneNumber))
      ];
    }
    if (widget.textFormFieldType == TextFormFieldType.employer) {
      return [FilteringTextInputFormatter.allow(RegExp(regExpEmployer))];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 48.sh,
          width: AppUtils.deviceWidth,
          child: SvgPicture.asset(
            widget.bgImage ?? AppAssets.cornerSubtractFilledSvg,
            color: widget.bgColor ?? AppColors.appGrey,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 29.sw, right: 20.sw),
          height: 48.sh,
          width: AppUtils.deviceWidth,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              (widget.isDropdownButton && countryDialCode.isNotEmpty)
                  ? SizedBox(
                      height: 60,
                      child: DropdownButton<String>(
                        hint: const Text(AppStrings.countryCode),
                        value: countryDialCode,
                        onChanged: (String? value) {
                          widget.onSelectCountryCode!(value);
                          setState(() => countryDialCode = value!);
                        },
                        items: widget.countyCodeList
                            ?.map((CountryCodeModel value) {
                          return DropdownMenuItem<String>(
                            value: value.dialCode,
                            child:
                                Text(value.dialCode ?? AppStrings.emptyString),
                          );
                        }).toList(),
                      ),
                    )
                  : SvgPicture.asset(
                      widget.textFieldIcon ?? AppAssets.emailSvgIcon,
                      color: AppColors.appDarkGrey,
                      width: 16.sw,
                      fit: BoxFit.contain,
                    ),
              SizedBox(width: 10.sw),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextField(
                    textCapitalization:
                        (widget.textFormFieldType == TextFormFieldType.employer)
                            ? TextCapitalization.characters
                            : TextCapitalization.none,
                    keyboardType: _keyboard(),
                    inputFormatters: _inputFormatter(),
                    maxLength: widget.maxLength,
                    obscureText: isObscureText,
                    controller: widget.textController,
                    textInputAction: widget.textInputAction,
                    textAlign: widget.isDropdownButton
                        ? TextAlign.right
                        : TextAlign.left,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 14.fs,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      counter: const Offstage(),
                      hintText: widget.hintText ?? AppStrings.emptyString,
                      hintStyle: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 12.fs,
                        color: AppColors.appDarkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 12.fs,
                        color: AppColors.appDarkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              widget.isObscureText
                  ? IconButton(
                      icon: Icon(
                        isObscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.appDarkGrey,
                      ),
                      onPressed: () {
                        setState(() => isObscureText = !isObscureText);
                      },
                    )
                  : const Offstage(),
            ],
          ),
        )
      ],
    );
  }
}
