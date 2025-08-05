import 'package:flutter/material.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';

class InviteScreen extends StatelessWidget {
  static const String routeName = "/InviteScreen";

  const InviteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffoldWidget(
      child: Center(
        child: Text("SavedCardScreen"),
      ),
    );
  }
}
