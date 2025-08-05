import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/app_strings.dart';
import 'localization.dart';

enum LocalizationFacadeState { initial }

class LocalizationFacade extends Cubit<LocalizationFacadeState> {
  LocalizationFacade() : super(LocalizationFacadeState.initial);

  String safeTranslate(BuildContext context, String key) =>
      Localization.of(context)?.translate(key) ?? AppStrings.emptyString;

  // String getSelectedLanguage() => AppUtils.getSelectedLanguage();
}

extension LocalizationExt on Widget {
  String safeTranslate(BuildContext context, String key) =>
      // Get translated string via the facade, which encapsulates the complexity of the Localization class.
      BlocProvider.of<LocalizationFacade>(context, listen: false)
          .safeTranslate(context, key);
}
