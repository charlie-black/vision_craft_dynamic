part of craft_dynamic;

class Constants {
  static var uuid = const Uuid();

  static var publicKey =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqO5uXE1g0Dviu35LYowEwUPUGPy31pHO5dPeBUXmSOYPl4wqcSpjQT0Us5BuZDGJI1hOxFxdhzf0STfQueK9l4EjqDJuDTQPoJcJxxzyPO2Qd3fWLh4Mh1eoqT7nEbK12Zvxy663+xP3pb0VqjVgAI8wI8CA2GHzhBACFtANu7N2z6hsCudM9t4tmFY4NtHlNbSBQQa5bnkcNu57SUPk23Vw1Em/6W6a4X9rxyxRqERiZgywuDvgLWEOYt9rlhBBwN8u+jOlxyqPux+yOLTp0z6h1fmc9hAENOw2amWNjngaUP6f6lmU4PrNg30msbzNk9f3SuTuUEsz5QLBOGbLuQIDAQABMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqO5uXE1g0Dviu35LYowEwUPUGPy31pHO5dPeBUXmSOYPl4wqcSpjQT0Us5BuZDGJI1hOxFxdhzf0STfQueK9l4EjqDJuDTQPoJcJxxzyPO2Qd3fWLh4Mh1eoqT7nEbK12Zvxy663+xP3pb0VqjVgAI8wI8CA2GHzhBACFtANu7N2z6hsCudM9t4tmFY4NtHlNbSBQQa5bnkcNu57SUPk23Vw1Em/6W6a4X9rxyxRqERiZgywuDvgLWEOYt9rlhBBwN8u+jOlxyqPux+yOLTp0z6h1fmc9hAENOw2amWNjngaUP6f6lmU4PrNg30msbzNk9f3SuTuUEsz5QLBOGbLuQIDAQAB";

  var version = "";

  static String logKeyValue = "KBSB&er3bflx9%";
  static String staticIV = "84jfkfndl3ybdfkf";

  Constants() {
    getPackageName();
  }

  void getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.packageName;
  }

  static getImei() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    if (Platform.isAndroid) {
      return androidInfo.serialNumber;
    } else if (Platform.isIOS) {
      return iosInfo.identifierForVendor;
    }
  }

  static String getHostPlatform() {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        return "IOS";
      } else {
        return "ANDROID";
      }
    }
    return "WEB";
  }

  static getUniqueID() {
    return uuid.v1();
  }
}
