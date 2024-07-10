part of craft_dynamic;

abstract class IDropDownAdapter {
  factory IDropDownAdapter(
      FormItem formItem, ModuleItem moduleItem, String? currentRelationID) {
    switch (EnumFormatter.getControlFormat(formItem.controlFormat!)) {
      case ControlFormat.SELECTBANKACCOUNT:
        return _BankAccountDropDown(formItem: formItem);

      case ControlFormat.SELECTBENEFICIARY:
        return _BeneficiaryDropDown(merchantID: moduleItem.merchantID);

      default:
        return _UserCodeDropDown(
            dataSourceID: formItem.dataSourceId,
            formItem: formItem,
            currentRelationID: currentRelationID);
    }
  }
  Future<Map<String, dynamic>?>? getDropDownItems();
}

class _UserCodeDropDown implements IDropDownAdapter {
  _UserCodeDropDown({this.dataSourceID, this.formItem, this.currentRelationID});

  String? dataSourceID;
  FormItem? formItem;
  String? currentRelationID;
  final _userCodeRepository = UserCodeRepository();

  @override
  Future<Map<String, dynamic>?>? getDropDownItems() async {
    var userCodes = await _userCodeRepository.getUserCodesById(dataSourceID);
    AppLogger.appLogD(
        tag: "drodpdown_adapter::usercodes before",
        message: userCodes.toString());
    if (isBillerName(formItem?.controlId ?? "") && currentRelationID != null) {
      userCodes = await _userCodeRepository.getUserCodesByIdAndRelationID(
          dataSourceID, currentRelationID);
      AppLogger.appLogD(
          tag: "drodpdown_adapter::usercodes after",
          message: userCodes.toString());
    }
    AppLogger.appLogD(
        tag: "dropdown adapter::datasourceid @$dataSourceID",
        message: userCodes);

    return userCodes.fold<Map<String, dynamic>>(
        {}, (acc, curr) => acc..[curr.subCodeId] = curr.description!);
  }

  bool isBillerName(String controlID) =>
      controlID.toLowerCase() == ControlID.BILLERNAME.name.toLowerCase()
          ? true
          : false;
}

class _BankAccountDropDown implements IDropDownAdapter {
  _BankAccountDropDown({required this.formItem});

  final FormItem formItem;
  final _bankAccountRepository = BankAccountRepository();

  @override
  Future<Map<String, dynamic>?>? getDropDownItems() async {
    var bankAccounts = await _bankAccountRepository.getAllBankAccounts();
    bool? isTransactional = formItem.isTransactional;
    String? dataSourceID = formItem.dataSourceId;

    AppLogger.appLogD(
        tag: "Is transactional ${formItem.controlText}",
        message: isTransactional);

    AppLogger.appLogD(
        tag: "data source id ${formItem.dataSourceId}",
        message: formItem.dataSourceId);

    if (isTransactional != null && isTransactional) {
      bankAccounts?.removeWhere((account) => account.isTransactional == false);
    }

    if (dataSourceID != null) {
      bankAccounts?.removeWhere((acc) => acc.productID != dataSourceID);
    }

    AppLogger.appLogD(
        tag: "total bank accounts ${formItem.controlText}",
        message: bankAccounts?.length);

    Map<String, dynamic>? accounts =
        bankAccounts?.fold<Map<String, dynamic>>({}, (acc, curr) {
      String balance = "";

      try {
        balance = accountsAndBalances.isNotEmpty
            ? "(${StringUtil.formatNumberWithThousandsSeparator(accountsAndBalances[curr.bankAccountId]["CLEARBALANCE"] ?? "Balance unavailable")})"
            : "";
        AppLogger.appLogD(
            tag: "acconts dropdown adapter", message: "balance $balance");
      } catch (e) {
        AppLogger.appLogD(tag: "acconts dropdown adapter", message: e);
      }

      return acc
        ..[curr.bankAccountId] = curr.aliasName.isEmpty
            ? "${curr.bankAccountId} $balance"
            : formItem.controlId == ControlID.CLEARBANKACCOUNTID.name
                ? "${curr.bankAccountId} $balance"
                : "${curr.aliasName} $balance";
    });

    AppLogger.appLogD(
        tag: "accounts dropdown adapter",
        message: "accounts found --> $accounts");
    return accounts;
  }
}

class _BeneficiaryDropDown implements IDropDownAdapter {
  _BeneficiaryDropDown({this.merchantID});

  String? merchantID;
  final _beneficiaryRepository = BeneficiaryRepository();
  final _sharedPref = CommonSharedPref();

  @override
  Future<Map<String, dynamic>?>? getDropDownItems() async {
    var customerNo = await _sharedPref.getCustomerMobile();
    var beneficiaries =
        await _beneficiaryRepository.getBeneficiariesByMerchantID(merchantID!);

    if (merchantID == "MOBILETOPUP" || merchantID == "MMONEY") {
      beneficiaries?.add(Beneficiary(
          merchantID: merchantID ?? "",
          merchantName: "global",
          accountID: customerNo,
          accountAlias: "Own Number",
          rowId: 0));
    }

    return beneficiaries?.fold<Map<String, dynamic>>(
        {}, (acc, curr) => acc..[curr.accountID] = curr.accountAlias);
  }
}
