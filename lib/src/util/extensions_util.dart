part of craft_dynamic;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringCapitalization on String {
  String capitalizeWords() {
    var words = split(" ");
    var capitalizedWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1));
    return capitalizedWords.join(" ");
  }
}

extension ModuleIdExt on ModuleId {
  String get name => describeEnum(this);
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension FormatPhone on String {
  String formatPhone() {
    return replaceAll(RegExp('[^0-9]'), '');
  }

  String capitalizeFirstLetter() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}

extension APICall on APIService {
  Future<DynamicResponse?> getDynamicDropDownValues(
      String actionID,
      ModuleItem moduleItem,
      String formID,
      String route,
      String? merchantID) async {
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.statusCode);

    Map<String, dynamic> innerMap = {};
    innerMap.addAll({"HEADER": actionID});
    innerMap.addAll({"MerchantID": merchantID ?? moduleItem.merchantID});
    if (moduleItem.moduleId == "PAYLOAN") {
      innerMap.addAll({"INFOFIELD1": "LOANREPAYMENT"});
    }

    var request = await dioRequestBodySetUp(formID.toUpperCase(), objectMap: {
      "MerchantID": merchantID ?? moduleItem.merchantID,
      "ModuleID": moduleItem.moduleId,
      formID == ActionType.DBCALL.name ? "DynamicForm" : "PayBill": innerMap
    });
    final url = await _sharedPref.getRoute(route.toLowerCase());
    var response = await performDioRequest(request, route: url);
    AppLogger.appLogI(tag: "dynamic dropdown", message: "data::$response");
    dynamicResponse = DynamicResponse.fromJson(jsonDecode(response ?? "{}"));
    if (dynamicResponse.status != StatusCode.success.statusCode) {
      CommonUtils.showToast(dynamicResponse.message ?? "Unable to get data");
    }
    return dynamicResponse;
  }

  Future<DynamicResponse?> getDynamicLink(
      String actionID, ModuleItem moduleItem) async {
    var request = await dioRequestBodySetUp("DBCALL", objectMap: {
      "MerchantID": moduleItem.merchantID,
      "DynamicForm": {"HEADER": actionID, "DocumentName": "LOANAPPLICATION"}
    });
    final route = await _sharedPref.getRoute("other".toLowerCase());
    var response = await performDioRequest(request, route: route);
    AppLogger.appLogI(tag: "dynamic link", message: "data::$response");
    return DynamicResponse.fromJson(jsonDecode(response ?? "{}"));
  }

  Future<DynamicResponse?> fetchLoansDocument(ModuleItem moduleItem) async {
    var request = await dioRequestBodySetUp("DBCALL", objectMap: {
      "MerchantID": moduleItem.merchantID,
      "DynamicForm": {"HEADER": "GETFILEPATH", "DocumentName": "LOANPRODUCTS"}
    });
    final route = await _sharedPref.getRoute("other".toLowerCase());
    var response = await performDioRequest(request, route: route);
    AppLogger.appLogI(tag: "loans document", message: "data::$response");
    return DynamicResponse.fromJson(jsonDecode(response ?? "{}"));
  }

  Future<DynamicResponse> terminateStandingOrder(account, amount, startDate,
      frequency, endDate, String pin, siId, refrenceNo) async {
    String? res;
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "STOPSTANDINGINSTRUCTIONS";
    innerMap["ModuleID"] = "STANDINGORDERVIEWDETAILS";
    innerMap["AMOUNT"] = amount;
    innerMap["ACCOUNTID"] = account;
    innerMap["INFOFIELD3"] = siId;
    innerMap["INFOFIELD5"] = refrenceNo;
    innerMap["INFOFIELD6"] = startDate;
    innerMap["INFOFIELD7"] = frequency;
    innerMap["INFOFIELD8"] = endDate;
    innerMap["INFOFIELD10"] = "R";
    requestObj["EncryptedFields"] = {"PIN": "${CryptLib.encryptField(pin)}"};

    // encryptedPin: CryptLib.encryptField(pin);

    // innerMap["PIN"] = CryptLib.encryptField(pin);
    // "EncryptedFields":CryptLib.encryptField(pin);

    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPref.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("termination>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension Navigate on BuildContext {
  navigate(Widget widget) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  navigateAndPopAll(Widget widget) {
    Navigator.pushAndRemoveUntil(this,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  remove() {
    Navigator.of(this).pop();
  }
}
