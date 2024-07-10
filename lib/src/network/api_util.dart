import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/connection_error_screen.dart';
import 'package:flutter/foundation.dart';

import '../../craft_dynamic.dart';

final _initRepository = InitRepository();

class APIUtil {
  static Future<String?> handleDioError(
      dynamic e, String rawResponse, String? response) async {
    Map<String, dynamic>? rawRes;

    if (e is FormatException) {
      try {
        rawRes = jsonDecode(rawResponse);
        if (rawRes?["Status"] == StatusCode.token.name) {
          CommonUtils.showToast("Please try again!");
          // await _initRepository.getAppToken();
        }
      } catch (e) {
        AppLogger.appLogE(
            tag: "DIO:FORMATRESOLVE::ERROR", message: e.toString());
      }
    } else if (e is SocketException) {
      CommonUtils.showToast("Please check your internet connection");
    }
    return rawRes.toString();
  }

  static verifyConnection() {
    if (!kIsWeb) {
      if (connectionState.value == ConnectivityResult.none) {
        CommonUtils.getxNavigate(widget: const ConnectionErrorScreen());
        return false;
      }
      return true;
    }
    return true;
  }
}
