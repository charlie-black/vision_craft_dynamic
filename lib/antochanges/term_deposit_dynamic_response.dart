


class TermDepositDynamicResponse {
  final String status;
  final String message;
  final String formID;
  final int nextFormSequence;
  final List<TermDepositData> data;
  final int backStack;

  TermDepositDynamicResponse({
    required this.status,
    required this.message,
    required this.formID,
    required this.nextFormSequence,
    required this.data,
    required this.backStack,
  });

  factory TermDepositDynamicResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['Data'] as List;
    List<TermDepositData> dataItems = dataList.map((i) => TermDepositData.fromJson(i)).toList();

    return TermDepositDynamicResponse(
      status: json['Status'],
      message: json['Message'],
      formID: json['FormID'],
      nextFormSequence: json['NextFormSequence'],
      data: dataItems,
      backStack: json['BackStack'],
    );
  }
}

class TermDepositData {
  final String branchName;
  final String accountId;
  final String accountName;
  final String receiptId;
  final String serialId;
  final String currencyId;
  final double amount;
  final double interestRate;
  final String term;
  final String startDate;
  final String matureDate;

  TermDepositData({
    required this.branchName,
    required this.accountId,
    required this.accountName,
    required this.receiptId,
    required this.serialId,
    required this.currencyId,
    required this.amount,
    required this.interestRate,
    required this.term,
    required this.startDate,
    required this.matureDate,
  });

  factory TermDepositData.fromJson(Map<String, dynamic> json) {
    return TermDepositData(
      branchName: json['Branch Name'],
      accountId: json['Account ID'],
      accountName: json['Account Name'],
      receiptId: json['Receipt ID'],
      serialId: json['Serial ID'],
      currencyId: json['Currency ID'],
      amount: json['Amount'],
      interestRate: json['Interest Rate'],
      term: json['Term'],
      startDate: json['Start Date'],
      matureDate: json['Mature Date'],
    );
  }
}
