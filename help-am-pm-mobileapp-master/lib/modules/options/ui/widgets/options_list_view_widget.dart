import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/key_value_model.dart';
import 'options_screen_card_widget.dart';

class OptionListViewWidget extends StatefulWidget {
  final List<KeyValueModel> list;
  final Function callBack;

  const OptionListViewWidget({
    Key? key,
    required this.list,
    required this.callBack,
  }) : super(key: key);

  @override
  State<OptionListViewWidget> createState() => _OptionListViewWidgetState();
}

class _OptionListViewWidgetState extends State<OptionListViewWidget> {
  void onPressed(int index) {
    setState(() {
      for (int i = 0; i < widget.list.length; i++) {
        widget.list[i].isSelected = false;
      }
      widget.list[index].isSelected = true;
      widget.callBack(widget.list[index]);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 46.sh),
      width: double.infinity,
      height: 120.sh,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => onPressed(0),
            child: OptionsScreenCardWidget(
              userKey: widget.list[0].key,
              title: widget.list[0].value,
              imageIcon: widget.list[0].imageString,
              isSelected: widget.list[0].isSelected,
            ),
          ),
          GestureDetector(
            onTap: () => onPressed(1),
            child: OptionsScreenCardWidget(
              userKey: widget.list[1].key,
              title: widget.list[1].value,
              imageIcon: widget.list[1].imageString,
              isSelected: widget.list[1].isSelected,
            ),
          )
        ],
      ),
    );
  }
}
