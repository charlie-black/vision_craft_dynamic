import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  Widget? widget;

  AppLifecycleObserver(this.context, this.widget);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      CommonUtils.getXRouteAndPopAll(widget: widget);
    }
  }
}
