import 'dart:convert';

class TermDepositDynamicResponse {
  String status;
  String message;
  String formID;
  int nextFormSequence;
  Data data;
  int backStack;

  TermDepositDynamicResponse({
    required this.status,
    required this.message,
    required this.formID,
    required this.nextFormSequence,
    required this.data,
    required this.backStack,
  });

  factory TermDepositDynamicResponse.fromJson(Map<String, dynamic> json) {
    return TermDepositDynamicResponse(
      status: json['Status'],
      message: json['Message'],
      formID: json['FormID'],
      nextFormSequence: json['NextFormSequence'],
      data: Data.fromJson(json['Data']),
      backStack: json['BackStack'],
    );
  }
}

class Data {
  String response;
  String message;
  ResponseValue responseValue;

  Data({
    required this.response,
    required this.message,
    required this.responseValue,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      response: json['response'],
      message: json['message'],
      responseValue: ResponseValue.fromJson(json['responseValue']),
    );
  }
}

class ResponseValue {
  List<Status> status;
  List<ResponseData> responseData;

  ResponseValue({
    required this.status,
    required this.responseData,
  });

  factory ResponseValue.fromJson(Map<String, dynamic> json) {
    return ResponseValue(
      status: List<Status>.from(json['Status'].map((x) => Status.fromJson(x))),
      responseData: List<ResponseData>.from(
          json['ResponseData'].map((x) => ResponseData.fromJson(x))),
    );
  }
}

class Status {
  String responseCode;
  String responseMessage;

  Status({
    required this.responseCode,
    required this.responseMessage,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      responseCode: json['ResponseCode'],
      responseMessage: json['ResponseMessage'],
    );
  }
}

class ResponseData {
  String ourBranchID;
  String branchName;
  String clientID;
  String clientName;
  String productID;
  String productName;
  String accountID;
  String accountName;
  dynamic shortName;
  String address1;
  dynamic address2;
  String cityID;
  String countryID;
  String countryName;
  dynamic phone1;
  dynamic phone2;
  dynamic fax;
  dynamic mobile;
  dynamic emailID;
  dynamic contactPerson;
  String accountClassID;
  String accountOfficerID;
  dynamic comments;
  String acStatus;
  String receiptid;
  int serialid;
  String currencyid;
  double amount;
  double interestrate;
  int term;
  DateTime startdate;
  DateTime maturedate;

  ResponseData({
    required this.ourBranchID,
    required this.branchName,
    required this.clientID,
    required this.clientName,
    required this.productID,
    required this.productName,
    required this.accountID,
    required this.accountName,
    required this.shortName,
    required this.address1,
    required this.address2,
    required this.cityID,
    required this.countryID,
    required this.countryName,
    required this.phone1,
    required this.phone2,
    required this.fax,
    required this.mobile,
    required this.emailID,
    required this.contactPerson,
    required this.accountClassID,
    required this.accountOfficerID,
    required this.comments,
    required this.acStatus,
    required this.receiptid,
    required this.serialid,
    required this.currencyid,
    required this.amount,
    required this.interestrate,
    required this.term,
    required this.startdate,
    required this.maturedate,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      ourBranchID: json['OurBranchID'],
      branchName: json['BranchName'],
      clientID: json['ClientID'],
      clientName: json['ClientName'],
      productID: json['ProductID'],
      productName: json['ProductName'],
      accountID: json['AccountID'],
      accountName: json['AccountName'],
      shortName: json['ShortName'],
      address1: json['Address1'],
      address2: json['Address2'],
      cityID: json['CityID'],
      countryID: json['CountryID'],
      countryName: json['CountryName'],
      phone1: json['Phone1'],
      phone2: json['Phone2'],
      fax: json['Fax'],
      mobile: json['Mobile'],
      emailID: json['EmailID'],
      contactPerson: json['ContactPerson'],
      accountClassID: json['AccountClassID'],
      accountOfficerID: json['AccountOfficerID'],
      comments: json['Comments'],
      acStatus: json['ACStatus'],
      receiptid: json['receiptid'],
      serialid: json['serialid'],
      currencyid: json['currencyid'],
      amount: json['amount'].toDouble(),
      interestrate: json['interestrate'].toDouble(),
      term: json['term'],
      startdate: DateTime.parse(json['startdate']),
      maturedate: DateTime.parse(json['maturedate']),
    );
  }
}
