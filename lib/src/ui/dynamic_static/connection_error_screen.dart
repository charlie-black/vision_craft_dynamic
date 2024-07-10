import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../craft_dynamic.dart';

class ConnectionErrorScreen extends StatelessWidget {
  const ConnectionErrorScreen({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
      child: WillPopScope(
          onWillPop: () async {
            if (connectionState.value == ConnectivityResult.none) {
              return false;
            }
            return true;
          }, // Always return false to prevent back button navigation
          child: Scaffold(
              body: SafeArea(
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 117,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Something went wrong",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Make sure wifi or cellular data is turned\non and try again."
                          .tr,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 44,
                    ),
                    SizedBox(
                        width: 200,
                        child: WidgetFactory.buildButton(context, () {
                          Navigator.of(context).pop();
                        }, "Close"))
                  ],
                )),
          ))));
}
