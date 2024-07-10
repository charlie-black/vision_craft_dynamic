import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

abstract class IMenuUtil {
  factory IMenuUtil(MenuType menuType, ModuleItem moduleItem) {
    switch (menuType) {
      case MenuType.Vertical:
        return VerticalPlainMenuItem(moduleItem: moduleItem);
      case MenuType.Horizontal:
        return HorizontalPlainMenuItem(moduleItem: moduleItem);
      default:
        return DefaultMenuItem(moduleItem: moduleItem);
    }
  }

  Widget getMenuItem();
}

class DefaultMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  DefaultMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => VerticalModule(moduleItem: moduleItem);
}

class VerticalPlainMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  VerticalPlainMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => VerticalModule(moduleItem: moduleItem);
}

class HorizontalPlainMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  HorizontalPlainMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => HorizontalModule(
        moduleItem: moduleItem,
      );
}
