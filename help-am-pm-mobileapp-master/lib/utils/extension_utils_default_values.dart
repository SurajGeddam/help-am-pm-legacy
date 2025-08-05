import 'app_strings.dart';

extension UnwrapOrDefaultString on String? {
  String onEmpty() {
    return this ?? AppStrings.emptyString;
  }
}

extension UnwrapOrDefaultFalse on bool? {
  bool orFalse() {
    return this ?? false;
  }
}

extension UnwrapOrDefaultInt on int? {
  int orZero() {
    return this ?? 0;
  }
}
