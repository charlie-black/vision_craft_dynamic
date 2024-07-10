import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:craft_dynamic/craft_dynamic.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<ConnectivityResult> connectionStatusController =
      StreamController<ConnectivityResult>();

  Future<void> initialize() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    connectionStatusController.add(result);

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      AppLogger.appLogD(
          tag: "connection changed", message: "connection state has changed");
      connectionState.value = result;
      connectionStatusController.add(result);
    });
  }

  void dispose() {
    connectionStatusController.close();
  }
}
