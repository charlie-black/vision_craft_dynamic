# craft_dynamic

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Code Examples

### Fetching Dynamic Widgets

The following example demonstrates how to fetch and display dynamic widgets (modules) in a grid layout.

```dart
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class ModuleScreen extends StatefulWidget {
  final ModuleItem moduleItem;

  const ModuleScreen({Key key, required this.moduleItem}) : super(key: key);

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  List<ModuleItem> modules = [];
  final moduleRepo = ModuleRepository();

  @override
  void initState() {
    super.initState();
    getModules();
  }

  getModules() async {
    var list = await moduleRepo.getModulesById(widget.moduleItem.moduleId);
    setState(() {
      modules = list ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: modules.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, index) {
          return ModuleItemWidget(moduleItem: modules[index]);
        },
      ),
    );
  }
}
```

### Fetching Dynamic Forms

The following example demonstrates how to fetch and display dynamic forms.

```dart
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class DynamicEventPaymentFormScreen extends StatefulWidget {
  final ModuleItem moduleItem;
  const DynamicEventPaymentFormScreen({super.key, required this.moduleItem});

  @override
  State<DynamicEventPaymentFormScreen> createState() =>
      _DynamicEventPaymentFormScreenState();
}

class _DynamicEventPaymentFormScreenState
    extends State<DynamicEventPaymentFormScreen> {
  FormItem? recentList;
  List<FormItem> formControls = [];
  final formRepo = FormsRepository();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getFormControls();
  }

  final dynamicRes = DynamicResponse(status: "000");
  getFormControls() async {
    var list = await formRepo.getFormsByModuleIdAndFormSequence(
        widget.moduleItem.moduleId, 1);

    list?.forEach((item) {
      AppLogger.appLogD(tag: "control--->", message: item.controlType);
    });
    setState(() {
      formControls = list ?? [];
      recentList =
          list?.firstWhere((formItem) => formItem.controlType == "LIST");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicWidget(
      key: _formKey,
      moduleItem: widget.moduleItem,
      nextFormSequence: 1,
    );
  }
}

```

### Fetching Dynamic AppBar

The following example demonstrates how to fetch and display a dynamic AppBar with actions.

```dart
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class DynamicAppBar extends StatefulWidget {
  final ModuleItem moduleItem;

  const DynamicAppBar({Key key, required this.moduleItem}) : super(key: key);

  @override
  State<DynamicAppBar> createState() => _DynamicAppBarState();
}

class _DynamicAppBarState extends State<DynamicAppBar> {
  FormItem? recentList;
  List<FormItem> formControls = [];
  final formRepo = FormsRepository();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getFormControls();
  }

  final dynamicRes = DynamicResponse(status: "000");

  getFormControls() async {
    var list = await formRepo.getFormsByModuleIdAndFormSequence(widget.moduleItem.moduleId, 1);
    setState(() {
      formControls = list ?? [];
      recentList = list?.firstWhere((formItem) => formItem.controlType == "LIST");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleItem.moduleName),
        actions: recentList != null
            ? [
                IconButton(
                    onPressed: () {
                      CommonUtils.navigateToRoute(
                          context: context,
                          widget: ListDataScreen(
                              widget: DynamicListWidget(
                                      moduleItem: widget.moduleItem,
                                      formItem: recentList)
                                  .render(),
                              title: widget.moduleItem.moduleName));
                    },
                    icon: Icon(Icons.list))
              ]
            : null,
      ),
      body: Container(),
    );
  }
}
```
### Fetching Dynamic AppBar

The following example demonstrates how to fetch and display a dynamic Bottom Navigation bar with actions.

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class BottomNavigationSample extends StatefulWidget {
  const BottomNavigationSample({super.key});

  @override
  State<BottomNavigationSample> createState() => _BottomNavigationSampleState();
}

class _BottomNavigationSampleState extends State<BottomNavigationSample> {
  List<BottomNavigationBarItem> tabItems = [];
  int _currentIndex = 2;
  List<ModuleItem> tabMenus = [];
  String _currentModuleID = "HOME";
  bool _isLoadingHome = true;
  List<ModuleItem> tabModules = [];
  final _moduleRepo = ModuleRepository();
  final _homeRepo = HomeRepository();

  Future<List<ModuleItem>> loadHome({moduleID}) async {
    _isLoadingHome = true;
    tabModules =
        await _moduleRepo.getModulesById(moduleID ?? _currentModuleID) ?? [];

    _isLoadingHome = false;
    return tabModules;
  }

  addTabItems() async {
    tabMenus.clear();
    tabItems.clear();
    tabMenus = await _homeRepo.getTabModules() ?? [];

    setState(() {
      tabMenus.asMap().forEach((index, tab) {
        AppLogger.appLogD(
            tag: "home tabs display order for ${tab.moduleName}",
            message: tab.displayOrder);
        if (index <= 4) {
          tabItems.add(
            BottomNavigationBarItem(
              icon: CachedNetworkImage(
                imageUrl: _currentIndex == index
                    ? tab.moduleUrl ?? ""
                    : tab.moduleUrl2 ?? "",
                height: 24,
                width: 24,
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: APIService.appPrimaryColor,
                ),
                fit: BoxFit.contain,
              ),
              label: tab.moduleName,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: tabItems.length >= 2
          ? BottomNavigationBar(
              elevation: 0,
              selectedItemColor: APIService.appSecondaryColor,
              unselectedItemColor: const Color.fromARGB(255, 165, 151, 151),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).primaryColor,
              currentIndex: _currentIndex,
              items: tabItems,
              onTap: (index) {
                _currentIndex = index;
                bool isTabDisabled = tabMenus[index].isDisabled ?? false;
                if (isTabDisabled == false) {
                  _currentModuleID = tabMenus[index].moduleId;
                  loadHome(moduleID: _currentModuleID);
                  addTabItems();
                } else {
                  CommonUtils.showToast("Coming soon");
                }
              },
            )
          : null,
    );
  }
}
```

Each example demonstrates a different way to fetch and display dynamic content using the `craft_dynamic` package. Adjust the code to fit your specific use case and UI requirements.