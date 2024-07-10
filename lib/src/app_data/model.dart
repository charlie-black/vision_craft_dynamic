// ignore_for_file: constant_identifier_names

part of craft_dynamic;

class CreditCard {
  final String balance;
  final String currency;

  CreditCard({
    required this.balance,
    required this.currency,
  });

  CreditCard.fromMap(Map map)
      : this(
          balance: map['balance'],
          currency: map['currency'],
        );
}

class MenuItemData {
  final String title;
  final String icon;

  MenuItemData({required this.title, required this.icon});
}

class AppLocation {
  double longitude;
  double latitude;
  String location;

  AppLocation(
      {required this.longitude,
      required this.latitude,
      required this.location});
}

class FavouriteItem {
  String imageUrl;
  String title;

  FavouriteItem({required this.imageUrl, required this.title});
}
// {"Status":"000","Message":"Completed Successfully",
// "FormID":"STANDINGORDERVIEWDETAILS",
// "NextFormSequence":0,"BackStack":1,
// "ResultsData":[{"ControlID":"GETSILIST","ControlValue":"STANDINGORDERVIEWDETAILS"}],
// "SILIST":[{"Amount":100.0000,"Frequency":"W","No Of Executions":"1",
// "First Execution Date":"2023-11-08T00:00:00",
// "Last Execution Date":"2023-11-15T00:00:00",
// "Credit AccountID":"00011003000003",
// "Status":"ACTIVE"}]}

class DynamicResponse {
  String status = "";
  DynamicData? dynamicData;
  String? message, formID, notifyText, languageID, otherText;
  int? nextFormSequence, backstack;
  List<dynamic>? dynamicList,
      notifications,
      resultsData,
      formFields,
      display,
      receiptDetails,
      accountStatement,
      beneficiaries,
      standingOrderList,
      summary,
      loanInformationList,
      emailList;

  DynamicResponse(
      {required this.status,
      this.dynamicData,
      this.message,
      this.languageID,
      this.otherText,
      this.formID,
      this.display,
      this.nextFormSequence,
      this.backstack,
      this.dynamicList,
      this.notifications,
      this.resultsData,
      this.formFields,
      this.notifyText,
      this.receiptDetails,
      this.accountStatement,
      this.beneficiaries,
      this.standingOrderList,
      this.summary,
      this.loanInformationList,
      this.emailList});

  DynamicResponse.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    languageID = json["LanguageID"];
    otherText = json["OtherText"];
    formID = json['FormID'];
    display = json["Display"];
    nextFormSequence = json["NextFormSequence"];
    backstack = json["BackStack"];
    if (json["Notifications"] != null) {
      notifyText = json["Notifications"][0]["NotifyText"];
    }
    resultsData = json["ResultsData"];
    dynamicList = json["Data"];
    formFields = json["FormFields"];
    receiptDetails = json["ReceiptDetails"];
    accountStatement = json["AccountStatement"];
    standingOrderList = json[""];
    beneficiaries = json["Beneficiary"];
    summary = json["Summary"];
    loanInformationList = json["LOANINFORMATIONLIST"];
    emailList = json["EMAILLIST"];
  }
}

class ActivationResponse {
  String status;
  int? staticDataVersion;
  String? message,
      firstName,
      lastName,
      idNumber,
      emailID,
      imageUrl,
      lastLoginDate,
      customerID,
      phone,
      bankID,
      bankType,
      languageID,
      customerCategory;
  List<dynamic>? accounts,
      frequentAccessedModules,
      beneficiary,
      modulesToHide,
      modulesToDisable,
      pendingTransactions;

  ActivationResponse(
      {required this.status,
      this.message,
      this.firstName,
      this.lastName,
      this.idNumber,
      this.emailID,
      this.imageUrl,
      this.lastLoginDate,
      this.customerID,
      this.phone,
      this.bankID,
      this.bankType,
      this.languageID,
      this.staticDataVersion,
      this.beneficiary,
      this.accounts,
      this.frequentAccessedModules,
      this.modulesToHide,
      this.modulesToDisable,
      this.pendingTransactions,
      this.customerCategory});

  ActivationResponse.fromJson(Map<String, dynamic> json)
      : status = json["Status"],
        message = json["Message"],
        firstName = json['FirstName'],
        lastName = json["LastName"],
        idNumber = json["IDNumber"],
        emailID = json["EMailID"],
        imageUrl = json["ImageURL"],
        customerID = json["CustomerID"],
        phone = json["Phone"],
        bankID = json["BankID"],
        bankType = json["BankType"],
        languageID = json["LanguageID"],
        lastLoginDate = json["LastLoginDateTime"],
        staticDataVersion = json["StaticDataVersion"],
        beneficiary = json["Beneficiary"],
        frequentAccessedModules = json["FrequentAccessedModules"],
        modulesToHide = json["ModulesToHide"],
        modulesToDisable = json["ModulesToDisable"],
        pendingTransactions = json["PendingTrxDisplay"],
        accounts = json["Accounts"],
        customerCategory = json["CustomerCategory"];
}

class StaticResponse {
  String status;
  int? staticDataVersion, appIdleTimeout, appRateLoginCount;
  String? message;
  List<dynamic>? usercode,
      onlineAccountProduct,
      bankBranch,
      atmLocation,
      branchLocation,
      image,
      faqs;

  StaticResponse(
      {required this.status,
      this.message,
      this.staticDataVersion,
      this.appIdleTimeout,
      this.appRateLoginCount,
      this.usercode,
      this.onlineAccountProduct,
      this.bankBranch,
      this.atmLocation,
      this.branchLocation,
      this.image,
      this.faqs});

  StaticResponse.fromJson(Map<String, dynamic> json)
      : status = json["Status"],
        message = json["Message"],
        staticDataVersion = json["StaticDataVersion"],
        appIdleTimeout = json["AppIdleTimeout"],
        appRateLoginCount = json["AppRateLoginCount"],
        usercode = json["UserCode"],
        branchLocation = json["BranchLocations"],
        atmLocation = json["ATMLocations"],
        bankBranch = json["BankBranch"],
        image = json["Images"],
        faqs = json["FAQ"],
        onlineAccountProduct = json["OnlineAccountProduct"];
}

class UIResponse {
  String status;
  String? message;
  List<dynamic>? formControl, actionControl, module;

  UIResponse(
      {required this.status,
      this.message,
      this.formControl,
      this.actionControl,
      this.module});

  UIResponse.fromJson(Map<String, dynamic> json)
      : status = json["Status"],
        message = json["Message"],
        formControl = json["FormControls"],
        actionControl = json["ActionControls"],
        module = json["Modules"];
}

class PostDynamicBuilder {
  int? nextFormSequence, backstack;
  ModuleItem? moduleItem;
  List<dynamic>? list,
      jsonDisplay,
      formFields,
      notifications,
      receiptDetails,
      beneficiaries,
      summary;
  String? status, message, formID, controlID, notifyText, languageID;
  ListType? listType;
  bool returnsWidget = false,
      opensDynamicRoute = false,
      isList = false,
      tappedButton = false;
}

class PostDynamic {
  BuildContext? context;
  ModuleItem? moduleItem;
  int? nextFormSequence, backstack;
  List<dynamic>? list,
      jsonDisplay,
      formFields,
      notifications,
      receiptDetails,
      beneficiaries,
      summary;
  String? actionID, status, message, formID, controlID, notifyText, languageID;
  ListType? listType;
  bool isList, returnsWidget, opensDynamicRoute, tappedButton;

  PostDynamic(
    PostDynamicBuilder builder,
    BuildContext buildContext,
    String myActionID,
  )   : context = buildContext,
        actionID = myActionID,
        moduleItem = builder.moduleItem,
        controlID = builder.controlID,
        listType = builder.listType,
        isList = builder.isList,
        tappedButton = builder.tappedButton,
        nextFormSequence = builder.nextFormSequence,
        backstack = builder.backstack,
        list = builder.list,
        jsonDisplay = builder.jsonDisplay,
        formFields = builder.formFields,
        status = builder.status,
        message = builder.message,
        formID = builder.formID,
        returnsWidget = builder.returnsWidget,
        notifyText = builder.notifyText,
        receiptDetails = builder.receiptDetails,
        beneficiaries = builder.beneficiaries,
        opensDynamicRoute = builder.opensDynamicRoute,
        languageID = builder.languageID,
        summary = builder.summary;
}

class TextFormFieldProperties {
  final bool autofocus, isEnabled, isObscured;
  final TextEditingController controller;
  TextInputType textInputType;
  InputDecoration? inputDecoration;
  BoxDecoration? boxDecoration;
  bool isAmount;
  String initialValue;
  Function(String?)? onChange;
  TextStyle? textStyle;
  int? maxLength;
  int? maxLines;

  TextFormFieldProperties(
      {this.autofocus = false,
      this.isEnabled = false,
      this.isObscured = false,
      this.isAmount = false,
      this.initialValue = "",
      this.onChange,
      required this.controller,
      required this.textInputType,
      this.inputDecoration,
      this.boxDecoration,
      this.textStyle,
      this.maxLength,
      this.maxLines});
}

class PreCallData {
  String? formID;
  String? webheader;
  Map<String, dynamic>? requestObject;

  PreCallData({this.formID, this.webheader, this.requestObject});
}

class DynamicData {
  String? controlID;
  bool? isList, tappedButton;
  ListType? listType;
  ActionType actionType;
  DynamicResponse dynamicResponse;
  ModuleItem? moduleItem;
  PreCallData? preCallData;

  DynamicData({
    this.controlID,
    this.tappedButton,
    this.isList,
    this.listType,
    required this.actionType,
    required this.dynamicResponse,
    this.moduleItem,
    this.preCallData,
  });
}

class MenuScreenProperties {
  int? gridcount;
  double? crossAxisSpacing;
  double? mainAxisSpacing;
  double? childAspectRatio;

  MenuScreenProperties(
      {this.gridcount,
      this.crossAxisSpacing,
      this.mainAxisSpacing,
      this.childAspectRatio});
}

@JsonSerializable()
class StandingOrder {
  @JsonKey(name: 'Amount')
  double? amount;

  @JsonKey(name: 'SOID')
  String? standingOrderID;

  @JsonKey(name: 'EffectiveDate')
  String? effectiveDate;

  @JsonKey(name: 'FrequencyID')
  String? frequencyID;

  @JsonKey(name: 'LastExecutionDate')
  String? lastExecutionDate;

  @JsonKey(name: 'CreatedBy')
  String? createdBy;

  @JsonKey(name: 'RequestData')
  String? requestData;

  @JsonKey(name: 'DebitAccountID')
  String? debitAccount;

  @JsonKey(name: 'Narration')
  String? narration;

  @JsonKey(name: 'NoOfExecutions')
  int? noOfExecutions;

  StandingOrder(
      {this.amount,
      this.standingOrderID,
      this.effectiveDate,
      this.frequencyID,
      this.lastExecutionDate,
      this.createdBy,
      this.requestData,
      this.debitAccount,
      this.narration,
      this.noOfExecutions});

  factory StandingOrder.fromJson(Map<String, dynamic> json) =>
      _$StandingOrderFromJson(json);

  Map<String, dynamic> toJson() => _$StandingOrderToJson(this);
}

class ReceiptModel {
  String title;
  String? value;

  ReceiptModel({required this.title, required this.value});

  ReceiptModel.fromJson(Map<String, dynamic> json)
      : title = json["Title"],
        value = json["Value"];
}
