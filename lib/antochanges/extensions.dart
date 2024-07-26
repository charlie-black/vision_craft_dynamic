import 'dart:convert';

import 'package:craft_dynamic/antochanges/loan_list_item.dart';
import 'package:craft_dynamic/antochanges/loan_products_item.dart';
import 'package:craft_dynamic/antochanges/term_deposit_dynamic_response.dart';

import '../craft_dynamic.dart';
import 'loan_list_screen.dart';

final _sharedPrefs = CommonSharedPref();

extension ApiCall on APIService {
  Future getLoanRepaymentHistory() async {
    String? res;
    EmailsList emailList = EmailsList();
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    // LoanID
    // ,DispersedAmount
    // ,OutstandingPrincipal
    // ,OutstandingInterest
    // ,RepaymentFrequency
    // ,InstallmentAmount
    // ,InstallmentStartDate
    // ,ValueDate
    // ,MaturityDate

    innerMap["MerchantID"] = "LOANREPAYMENTHISTORY";
    innerMap["ModuleID"] = "LOANHISTORY";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      // emailList = EmailsList.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("historyList>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return emailList;
    }

    return emailList;
  }

  Future getLoanProducts() async {
    String? res;
    LoanProducts loanProducts = LoanProducts();
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    // LoanID
    // ,DispersedAmount
    // ,OutstandingPrincipal
    // ,OutstandingInterest
    // ,RepaymentFrequency
    // ,InstallmentAmount
    // ,InstallmentStartDate
    // ,ValueDate
    // ,MaturityDate

    innerMap["MerchantID"] = "LOANPRODUCTS";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      loanProducts = LoanProducts.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("historyList>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return loanProducts;
    }

    return loanProducts;
  }

  Future getLoanAccounts() async {
    String? res;
    EmailsList emailList = EmailsList();
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    // LoanID
    // ,DispersedAmount
    // ,OutstandingPrincipal
    // ,OutstandingInterest
    // ,RepaymentFrequency
    // ,InstallmentAmount
    // ,InstallmentStartDate
    // ,ValueDate
    // ,MaturityDate

    innerMap["MerchantID"] = "LOANREPAYMENTHISTORY";
    innerMap["ModuleID"] = "LOANHISTORY";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      // emailList = EmailsList.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("historyList>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return emailList;
    }

    return emailList;
  }

  Future<DynamicResponse> getLoanInfo() async {
    String? res;
    LoanListItem loanListItem = LoanListItem();
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};

    innerMap["MerchantID"] = "LOANINFORMATION";
    innerMap["ModuleID"] = "LOANINFORMATION";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}"));
      logger.d("loanLisst>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }

  Future<TermDepositDynamicResponse> getTermDepositStatus() async {
    String? res;
    TermDepositDynamicResponse dynamicResponse =
    TermDepositDynamicResponse(status: StatusCode.unknown.name, message: "", formID: "", nextFormSequence: 0, data: [], backStack: 0);

    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};

    innerMap["MerchantID"] = "GETCLIENTTDACCOUNTS";
    innerMap["ModuleID"] = "TERMDEPOSITSTATUS";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route = await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);

      if (res != null && res.isNotEmpty) {
        dynamicResponse = TermDepositDynamicResponse.fromJson(jsonDecode(res));
        logger.d("termdeposit>>: $res");
      }
    } catch (e) {
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
    }

    return dynamicResponse;
  }
}
