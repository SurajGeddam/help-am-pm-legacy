import 'package:flutter/material.dart';

import '../common_widgets/app_scaffold_widget.dart';

class UndefinedScreen extends StatelessWidget {
  static const String routeName = "/UndefinedScreen";
  final String? name;

  const UndefinedScreen({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isBackShow: true,
      child: name != null
          ? Center(child: Text('Route for $name is not undefined'))
          : const Center(child: Text('Undefined Screen')),
    );
  }
}
