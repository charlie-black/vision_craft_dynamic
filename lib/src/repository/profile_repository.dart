part of craft_dynamic;

class ProfileRepository {
  final _bankRepository = BankAccountRepository();
  final _sharedPref = CommonSharedPref();
  final _services = APIService();

  Future<bool> checkAppActivationStatus() =>
      _sharedPref.getAppActivationStatus();

  Future<List<BankAccount>> getUserBankAccounts() async =>
      await _bankRepository.getAllBankAccounts() ?? [];

  getUserInfo(UserAccountData key) => _sharedPref.getUserAccountInfo(key);

  Future<DynamicResponse?> checkAccountBalance(String bankAccountID) async {
    return await _services.checkAccountBalance(
        bankAccountID: bankAccountID, merchantID: "BALANCE", moduleID: "HOME");
  }

  Future<DynamicResponse?> getAccountSummary({merchantID}) async {
    return await _services.getAccountSummary(
        merchantID: merchantID ?? "BALANCE", moduleID: "HOME");
  }

  //Clear balance
  String getActualBalanceText(DynamicResponse dynamicResponse) =>
      dynamicResponse.resultsData
          ?.firstWhere((e) => e["ControlID"] == "BALTEXT")["ControlValue"] ??
      "Not available";

  // Available balance
  String getAvailableBalance(DynamicResponse dynamicResponse) {
    var availableBal = dynamicResponse.resultsData
        ?.firstWhereOrNull((e) => e["ControlID"] == "TOTALBALTEXT");
    AppLogger.appLogD(
        tag: "profile_repository", message: "available--->$availableBal");
    if (availableBal != null) {
      return availableBal["ControlValue"];
    }
    return "";
  }

  getAllAccountBalancesAndSaveInAppState() async {
    accountsAndBalances.clear();
    if (showAccountBalanceInDropdowns.value) {
      var accounts = await _bankRepository.getAllBankAccounts() ?? [];
      for (var account in accounts) {
        var accountBalance = await checkAccountBalance(account.bankAccountId);
        if (accountBalance != null &&
            accountBalance.status == StatusCode.success.statusCode) {
          accountsAndBalances.addAll({
            account.bankAccountId: {
              "CLEARBALANCE": getActualBalanceText(accountBalance),
              "AVAILABLEBALANCE": getAvailableBalance(accountBalance)
            }
          });
        }
      }
      return;
    } else {
      accountsAndBalances.clear();
      return;
    }
  }

  Future<DynamicResponse?> checkMiniStatement(String bankAccountID,
      {merchantID = "MINISTATEMENT"}) {
    return _services.checkMiniStatement(
        bankAccountID: bankAccountID,
        merchantID: merchantID,
        moduleID: merchantID);
  }
}
