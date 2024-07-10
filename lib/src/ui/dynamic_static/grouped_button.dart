// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';

import '/src/providers/group_button_provider.dart';
import '../../../craft_dynamic.dart';

class GroupButtonWidget extends StatefulWidget {
  List<String>? buttons;

  GroupButtonWidget({super.key, this.buttons});

  @override
  State<GroupButtonWidget> createState() => _GroupButtonWidgetState();
}

class _GroupButtonWidgetState extends State<GroupButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buttons != null
        ? Consumer<GroupButtonModel>(
            builder: (context, selectedItem, child) => GroupButton(
                onSelected: (value, index, isSelected) {
                  selectedItem.setSelectedItem(value.toString());
                },
                buttons: widget.buttons!,
                options: GroupButtonOptions(
                  borderRadius: BorderRadius.circular(8),
                  buttonWidth: 70,
                  buttonHeight: 44,
                )))
        : NullWidget().render();
  }
}
