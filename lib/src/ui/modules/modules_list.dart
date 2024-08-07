// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ModulesListWidget extends StatefulWidget {
  Orientation orientation;
  ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  ModulesListWidget({
    super.key,
    required this.orientation,
    required this.moduleItem,
    this.favouriteModule,
  });

  @override
  State<ModulesListWidget> createState() => _ModulesListWidgetState();
}

class _ModulesListWidgetState extends State<ModulesListWidget> {
  final _moduleRepository = ModuleRepository();

  Future<List<ModuleItem>?> getModules() async {
    List<ModuleItem>? modules = await _moduleRepository.getModulesById(
        widget.favouriteModule == null
            ? widget.moduleItem!.moduleId
            : widget.favouriteModule!.moduleID);

    return modules;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicState>(builder: (context, state, child) {
      BlockSpacing? blockSpacing = widget.moduleItem?.blockSpacing;

      return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: Text(widget.favouriteModule == null
                ? widget.moduleItem?.moduleName ?? ""
                : widget.favouriteModule!.moduleName),
          ),
          body: FutureBuilder<List<ModuleItem>?>(
            future: getModules(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ModuleItem>?> snapshot) {
              Widget child = const Center(child: Text("Please wait..."));
              if (snapshot.connectionState == ConnectionState.waiting) {
                child = const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                child = const Center(child: Text("Error loading modules."));
              } else if (snapshot.hasData) {
                var modules = snapshot.data?.toList();
                modules?.removeWhere((module) => module.isHidden == true);

                if (modules != null && modules.isNotEmpty) {
                  child = ListView.builder(
                    itemCount: modules.length,
                    itemBuilder: (BuildContext context, int index) {
                      var module = modules[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: APIService.appPrimaryColor),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListTile(
                            onTap: () {
                              ModuleUtil.onItemClick(module, context);
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                imageUrl: module.moduleUrl ?? "",
                                height: 30,
                                width: 30, // Added width constraint
                                fit: BoxFit.cover,
                                placeholder: (context, url) => SpinKitPulse(
                                  color: APIService.appPrimaryColor,
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: APIService.appPrimaryColor,
                            ),
                            title: Text(
                              module.moduleName,
                              style:
                              TextStyle(color: APIService.appPrimaryColor),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  child = const Center(child: Text("No modules available."));
                }
              }
              return child;
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
