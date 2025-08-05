import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_enum.dart';
import '../../utils/app_regex_constant.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class AppTextFieldFormWidget extends StatefulWidget {
  final TextEditingController textController;
  final double? textFieldHeight;
  final int phoneNumberSize;
  final int pinCodeSize;
  final double borderRadius;
  final bool isShowMaxLength;
  final Color? focusBorderColor;
  final String hintText;
  final TextStyle? hintStyle;
  final String labelText;
  final TextStyle? labelStyle;
  final bool obscureText;
  final int maxLength;
  final TextInputAction textInputAction;
  final TextFormFieldType? textFormFieldType;
  final TextAlign? textAlign;
  final TextCapitalization? textCapitalization;
  final bool? autocorrect;
  final int minLine;
  final int maxLine;
  final Function? onChange;
  final Function? onTap;
  final bool readOnly;
  final Widget? suffix;
  final bool isDateField;
  final bool isExpirationCondition;

  const AppTextFieldFormWidget({
    Key? key,
    required this.textController,
    this.textFieldHeight,
    this.phoneNumberSize = 10,
    this.pinCodeSize = 6,
    this.borderRadius = 8.0,
    this.isShowMaxLength = false,
    this.focusBorderColor,
    this.hintText = AppStrings.emptyString,
    this.hintStyle,
    this.labelText = AppStrings.emptyString,
    this.labelStyle,
    this.obscureText = false,
    this.maxLength = 100,
    this.textInputAction = TextInputAction.done,
    this.textFormFieldType,
    this.textAlign,
    this.textCapitalization,
    this.autocorrect,
    this.minLine = 1,
    this.maxLine = 1,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    this.suffix,
    this.isDateField = false,
    this.isExpirationCondition = false,
  }) : super(key: key);

  @override
  State<AppTextFieldFormWidget> createState() => _AppTextFieldFormWidgetState();
}

class _AppTextFieldFormWidgetState extends State<AppTextFieldFormWidget> {
  final _formFieldStateKey = GlobalKey<FormFieldState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: widget.isExpirationCondition
          ? DateTime.now().subtract(const Duration(days: 0))
          : DateTime(1900),
      lastDate: DateTime(9999),
    );
    if (picked != null && picked != selectedDate) {
      AppUtils.debugPrint(
          "Selected date => ${AppUtils.getDateMMDDYYYY(picked)}");
      setState(() {
        selectedDate = picked;
        widget.textController.text =
            AppUtils.getDateMMDDYYYY(selectedDate).toString();
        // widget.textController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  /// return keyboard type
  TextInputType _keyboard() {
    if (widget.textFormFieldType == TextFormFieldType.email) {
      return TextInputType.emailAddress;
    }
    if (widget.textFormFieldType == TextFormFieldType.phone) {
      return TextInputType.phone;
    }
    if (widget.textFormFieldType == TextFormFieldType.number) {
      return const TextInputType.numberWithOptions(
          decimal: false, signed: false);
    }
    if (widget.textFormFieldType == TextFormFieldType.price) {
      return const TextInputType.numberWithOptions(
          decimal: true, signed: false);
    }
    return TextInputType.text;
  }

  /// allow text based on the text field type
  List<TextInputFormatter> _inputFormatter() {
    if (widget.textFormFieldType == TextFormFieldType.name) {
      return [FilteringTextInputFormatter.deny(RegExp(regExpName))];
    }
    if (widget.textFormFieldType == TextFormFieldType.number) {
      return [FilteringTextInputFormatter.allow(RegExp(regExpNumber))];
    }
    if (widget.textFormFieldType == TextFormFieldType.phone) {
      return [
        LengthLimitingTextInputFormatter(widget.phoneNumberSize),
        FilteringTextInputFormatter.allow(RegExp(regExpPhoneNumber))
      ];
    }
    if (widget.textFormFieldType == TextFormFieldType.postalCode) {
      return [
        LengthLimitingTextInputFormatter(widget.pinCodeSize),
        FilteringTextInputFormatter.allow(RegExp(regExpPostalCode))
      ];
    }
    if (widget.textFormFieldType == TextFormFieldType.price) {
      return [
        LengthLimitingTextInputFormatter(widget.pinCodeSize),
        FilteringTextInputFormatter.allow(RegExp(regExpPrice))
      ];
    }
    return [];
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      suffix: widget.suffix,
      isDense: true,
      counter: widget.isShowMaxLength ? null : const Offstage(),
      enabledBorder: OutlineInputBorder(
        borderRadius: _getBorderRadius(),
        borderSide: BorderSide(
          width: 1.sw,
          color: AppColors.textColorOnForm,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _getBorderRadius(),
        borderSide: BorderSide(
          width: 2.sw,
          color: AppColors.red,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: _getBorderRadius(),
        borderSide: BorderSide(
          width: 1,
          color: AppColors.appThinGrey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _getBorderRadius(),
        borderSide: BorderSide(
          width: 1.sw,
          color: widget.focusBorderColor ??
              (widget.readOnly ? AppColors.appLightGrey : AppColors.appOrange),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: _getBorderRadius(),
        borderSide: BorderSide(width: 1.sw),
      ),
      hintText: widget.hintText,
      hintStyle: widget.hintStyle ??
          AppTextStyles.defaultTextStyle.copyWith(
            color: AppColors.appLightGrey,
            fontSize: 14.fs,
            fontWeight: FontWeight.w400,
          ),
      labelText: widget.labelText,
      labelStyle: widget.labelStyle ??
          AppTextStyles.defaultTextStyle.copyWith(
            color: AppColors.black,
            fontSize: 14.fs,
            fontWeight: FontWeight.w400,
          ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparent,
      height: widget.textFieldHeight ?? 50.sh,
      width: AppUtils.deviceWidth,
      alignment: Alignment.bottomCenter,
      child: TextFormField(
        key: _formFieldStateKey,
        controller: widget.textController,
        decoration: _inputDecoration(context),
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        cursorColor: AppColors.appOrange,
        style: AppTextStyles.defaultTextStyle.copyWith(
          color:
              widget.readOnly ? AppColors.appLightMediumGrey : AppColors.black,
          fontSize: 14.fs,
          fontWeight: FontWeight.w400,
        ),
        onTap: () {
          _requestFocus();
          if (widget.isDateField) _selectDate(context);
        },
        focusNode: _focusNode,
        onChanged: (value) => widget.onChange,
        readOnly: widget.readOnly,
        textAlign: widget.textAlign ?? TextAlign.left,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        autocorrect: widget.autocorrect ?? false,
        textInputAction: widget.textInputAction,
        keyboardType: _keyboard(),
        inputFormatters: _inputFormatter(),
      ),
    );
  }

  _getBorderRadius() => BorderRadius.all(Radius.circular(widget.borderRadius));

  void _requestFocus() {
    setState(() => FocusScope.of(context).requestFocus(_focusNode));
  }
}
