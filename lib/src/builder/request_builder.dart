import 'package:craft_dynamic/craft_dynamic.dart';

class RequestBuilder {
  final uniqueID = Constants.getUniqueID();
  final codeBase = Constants.getHostPlatform();
  Map<String, dynamic>? latLong;
  String? bankID,
      country,
      versionNumber,
      trxSource,
      appName,
      imei,
      imsi,
      customerId;

  RequestBuilder(
      {this.bankID,
      this.country,
      this.versionNumber,
      this.trxSource,
      this.appName,
      this.imei,
      this.imsi,
      this.customerId,
      this.latLong});
}

class RequestObject {
  Map<String, dynamic>? latLong;
  String? uniqueID,
      bankID,
      country,
      versionNumber,
      trxSource,
      appName,
      codeBase,
      customerId,
      imsi,
      imei,
      sessionID;

  RequestObject(RequestBuilder requestBuilder)
      : imei = requestBuilder.imei,
        imsi = requestBuilder.imsi,
        latLong = requestBuilder.latLong,
        uniqueID = requestBuilder.uniqueID,
        bankID = requestBuilder.bankID,
        country = requestBuilder.country,
        versionNumber = requestBuilder.versionNumber,
        trxSource = requestBuilder.trxSource,
        appName = requestBuilder.appName,
        codeBase = requestBuilder.codeBase,
        customerId = requestBuilder.customerId;

  Map<String, dynamic> createRequestMap() {
    return {
      RequestParam.UNIQUEID.name: uniqueID,
      RequestParam.BankID.name: bankID,
      RequestParam.Country.name: country,
      RequestParam.VersionNumber.name: versionNumber,
      RequestParam.IMEI.name: imei,
      RequestParam.IMSI.name: imsi,
      RequestParam.TRXSOURCE.name: trxSource,
      RequestParam.APPNAME.name: appName,
      RequestParam.CODEBASE.name: codeBase,
      RequestParam.CustomerID.name: customerId,
      RequestParam.LATLON.name:
          "${latLong?["lat"] ?? "0.00"},${latLong?["long"] ?? "0.00"}"
    };
  }
}
