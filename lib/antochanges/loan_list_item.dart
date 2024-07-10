class LoanListItem {
  String? status;
  String? message;
  String? formID;
  var nextFormSequence;
  var backStack;
  List<ResultsData>? resultsData;
  List<LOANINFORMATIONLIST>? lOANINFORMATIONLIST;

  LoanListItem(
      {this.status,
        this.message,
        this.formID,
        this.nextFormSequence,
        this.backStack,
        this.resultsData,
        this.lOANINFORMATIONLIST});

  LoanListItem.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    formID = json['FormID'];
    nextFormSequence = json['NextFormSequence'];
    backStack = json['BackStack'];
    if (json['ResultsData'] != null) {
      resultsData = <ResultsData>[];
      json['ResultsData'].forEach((v) {
        resultsData!.add(new ResultsData.fromJson(v));
      });
    }
    if (json['LOANINFORMATIONLIST'] != null) {
      lOANINFORMATIONLIST = <LOANINFORMATIONLIST>[];
      json['LOANINFORMATIONLIST'].forEach((v) {
        lOANINFORMATIONLIST!.add(new LOANINFORMATIONLIST.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['FormID'] = this.formID;
    data['NextFormSequence'] = this.nextFormSequence;
    data['BackStack'] = this.backStack;
    if (this.resultsData != null) {
      data['ResultsData'] = this.resultsData!.map((v) => v.toJson()).toList();
    }
    if (this.lOANINFORMATIONLIST != null) {
      data['LOANINFORMATIONLIST'] =
          this.lOANINFORMATIONLIST!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ControlID'] = this.controlID;
    data['ControlValue'] = this.controlValue;
    return data;
  }
}

class LOANINFORMATIONLIST {
  String? loanID;
  var dispersedAmount;
  var outstandingPrincipal;
  var outstandingInterest;
  String? repaymentFrequency;
  var installmentAmount;
  String? installmentStartDate;
  String? valueDate;
  String? maturityDate;

  LOANINFORMATIONLIST(
      {this.loanID,
        this.dispersedAmount,
        this.outstandingPrincipal,
        this.outstandingInterest,
        this.repaymentFrequency,
        this.installmentAmount,
        this.installmentStartDate,
        this.valueDate,
        this.maturityDate});

  LOANINFORMATIONLIST.fromJson(Map<String, dynamic> json) {
    loanID = json['LoanID'];
    dispersedAmount = json['DispersedAmount'];
    outstandingPrincipal = json['OutstandingPrincipal'];
    outstandingInterest = json['OutstandingInterest'];
    repaymentFrequency = json['RepaymentFrequency'];
    installmentAmount = json['InstallmentAmount'];
    installmentStartDate = json['InstallmentStartDate'];
    valueDate = json['ValueDate'];
    maturityDate = json['MaturityDate'];
  }

  // {"Status":"000","Message":"Loan Informat
  // ion Created Successfully","FormID":"","NextFormSequence":0,"BackStack":1,"Res
  // ultsData":[{"ControlID":"GETLOANINFORMATIONLIST","ControlValue":"LOANINFORMAT
  // ION"}],"LOANINFORMATIONLIST":[{"LoanID":"0001000209","DispersedAmount":200000
  // .0000,"OutstandingPrincipal":11003000170.0000,"OutstandingInterest":199999.98
  // 00,"RepaymentFrequency":"M","InstallmentAmount":19009.0000,"InstallmentStartD
  // ate":"2022-01-01","ValueDate":"2021-12-01","MaturityDate":"2022-12-01"}]}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoanID'] = this.loanID;
    data['DispersedAmount'] = this.dispersedAmount;
    data['OutstandingPrincipal'] = this.outstandingPrincipal;
    data['OutstandingInterest'] = this.outstandingInterest;
    data['RepaymentFrequency'] = this.repaymentFrequency;
    data['InstallmentAmount'] = this.installmentAmount;
    data['InstallmentStartDate'] = this.installmentStartDate;
    data['ValueDate'] = this.valueDate;
    data['MaturityDate'] = this.maturityDate;
    return data;
  }
}
