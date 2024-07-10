import 'package:craft_dynamic/craft_dynamic.dart';

class SO {
  String? status;
  String? message;
  String? formID;
  var nextFormSequence;
  var backStack;
  List<ResultsData>? resultsData;
  List<SILIST>? sILIST;

  SO(
      {this.status,
      this.message,
      this.formID,
      this.nextFormSequence,
      this.backStack,
      this.resultsData,
      this.sILIST});

  SO.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    formID = json['FormID'];
    nextFormSequence = json['NextFormSequence'];
    backStack = json['BackStack'];
    if (json['ResultsData'] != null) {
      resultsData = <ResultsData>[];
      json['ResultsData'].forEach((v) {
        resultsData!.add(ResultsData.fromJson(v));
      });
    }
    if (json['SILIST'] != null) {
      sILIST = <SILIST>[];
      json['SILIST'].forEach((v) {
        try {
          AppLogger.appLogD(tag: "so", message: "adding item");
          sILIST!.add(SILIST.fromJson(v));
        } catch (e) {
          AppLogger.appLogD(tag: "so error", message: e);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Status'] = status;
    data['Message'] = message;
    data['FormID'] = formID;
    data['NextFormSequence'] = nextFormSequence;
    data['BackStack'] = backStack;
    if (resultsData != null) {
      data['ResultsData'] = resultsData!.map((v) => v.toJson()).toList();
    }
    if (sILIST != null) {
      data['SILIST'] = sILIST!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultsData {
  String? controlID;
  String? controlValue;

  ResultsData({this.controlID, this.controlValue});

  ResultsData.fromJson(Map<String, dynamic> json) {
    controlID = json['ControlID'];
    controlValue = json['ControlValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ControlID'] = controlID;
    data['ControlValue'] = controlValue;
    return data;
  }
}

class SILIST {
  var amount;
  String? frequency;
  String? noOfExecutions;
  String? firstExecutionDate;
  String? lastExecutionDate;
  String? creditAccountID;
  String? status;
  String? siID;
  String? reference;
  String? debitAccount;

  SILIST(
      {this.amount,
      this.frequency,
      this.noOfExecutions,
      this.firstExecutionDate,
      this.lastExecutionDate,
      this.creditAccountID,
      this.status,
      this.reference,
      this.siID,
      this.debitAccount});

  SILIST.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    frequency = json['Frequency'];
    noOfExecutions = json['No Of Executions'];
    firstExecutionDate = json['First Execution Date'];
    lastExecutionDate = json['Last Execution Date'];
    creditAccountID = json['Credit AccountID'];
    status = json['Status'];
    reference = json['ReferenceNo'];
    siID = json['SIID'];
    debitAccount = json["Debit AccountID"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Amount'] = amount;
    data['Frequency'] = frequency;
    data['No Of Executions'] = noOfExecutions;
    data['First Execution Date'] = firstExecutionDate;
    data['Last Execution Date'] = lastExecutionDate;
    data['Credit AccountID'] = creditAccountID;
    data['Status'] = status;
    return data;
  }
}
