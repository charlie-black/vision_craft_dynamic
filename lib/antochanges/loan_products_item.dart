class LoanProducts {
  String? status;
  String? message;
  String? formID;
  int? nextFormSequence;
  int? backStack;
  List<ResultsData>? resultsData;
  List<LOANPRODUCTS>? lOANPRODUCTS;

  LoanProducts(
      {this.status,
        this.message,
        this.formID,
        this.nextFormSequence,
        this.backStack,
        this.resultsData,
        this.lOANPRODUCTS});

  LoanProducts.fromJson(Map<String, dynamic> json) {
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
    if (json['LOANPRODUCTS'] != null) {
      lOANPRODUCTS = <LOANPRODUCTS>[];
      json['LOANPRODUCTS'].forEach((v) {
        lOANPRODUCTS!.add(new LOANPRODUCTS.fromJson(v));
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
    if (this.lOANPRODUCTS != null) {
      data['LOANPRODUCTS'] = this.lOANPRODUCTS!.map((v) => v.toJson()).toList();
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

class LOANPRODUCTS {
  String? loanProductID;
  String? loanProductName;

  LOANPRODUCTS({this.loanProductID, this.loanProductName});

  LOANPRODUCTS.fromJson(Map<String, dynamic> json) {
    loanProductID = json['Loan Product ID'];
    loanProductName = json['Loan Product Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Loan Product ID'] = this.loanProductID;
    data['Loan Product Name'] = this.loanProductName;
    return data;
  }
}
