import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import '../craft_dynamic.dart';

class LoanPaymentScreen extends StatefulWidget {
  final String loanAccount;
  final String loanOutstandingBalance;

  const LoanPaymentScreen({
    super.key,
    required this.loanAccount,
    required this.loanOutstandingBalance,
  });

  @override
  State<LoanPaymentScreen> createState() => _LoanPaymentScreenState();
}

class _LoanPaymentScreenState extends State<LoanPaymentScreen> {
  bool _isFullPayment = true;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  List<DropdownMenuItem<String>> accounts = [];
  final _profilerepo = ProfileRepository();
  final Map<String, dynamic> innerObj = {};
  final Map<String, dynamic> requestobj = {};
  final api = APIService();
  String? selectedAccount;
  bool _isMakingPayment = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.loanOutstandingBalance;
    fetchBankAccounts();
  }

  Future<void> fetchBankAccounts() async {
    var accs = await _profilerepo.getUserBankAccounts();
    setState(() {
      accounts = accs
          .map((acc) => DropdownMenuItem<String>(
                value: acc.bankAccountId,
                child: Text(acc.bankAccountId),
              ))
          .toList();
    });
  }

  void _handlePaymentTypeChange(bool? value) {
    setState(() {
      _isFullPayment = value ?? true;
      if (_isFullPayment) {
        _amountController.text = widget.loanOutstandingBalance;
      } else {
        _amountController.clear();
      }
    });
  }

  Future<DynamicResponse> makeLoanPayment() async {
    setState(() {
      _isMakingPayment = true;
    });

    requestobj.addAll({"ModuleID": "PAYLOAN"});
    requestobj.addAll({"MerchantID": "GETCLIENTLOANACCOUNTS"});
    requestobj.addAll({"PayBill": innerObj});

    DynamicResponse response = await api.dynamicRequest(
        formID: "PAYBILL", requestObj: requestobj, webHeader: "account");

    setState(() {
      _isMakingPayment = false;
    });

    if (response.status != "000") {
      AlertUtil.showAlertDialog(context, response.message ?? "");
    } else {
      CoolAlert.show(
        backgroundColor: const Color(0xff293178),
        confirmBtnColor: const Color(0xff293178),
        onConfirmBtnTap: () {
          Navigator.pop(context);
          _clearFields();
        },
        title: "${response.message}!",
        context: context,
        type: CoolAlertType.success,
        text: "Loan payment was successful.",
      );
    }
    return response;
  }

  void _clearFields() {
    setState(() {
      _amountController.clear();
      _remarksController.clear();
      selectedAccount = null;
      _isFullPayment = true;
      _amountController.text = widget.loanOutstandingBalance;
    });
  }

  Future<void> insertInnerObjects() async {
    innerObj.addAll({
      "INFOFIELD6": "LOANPAYOFF",
      "INFOFIELD3": "",
      "INFOFIELD4": "",
      "INFOFIELD5": "",
      "ACCOUNTID": widget.loanAccount,
      "BANKACCOUNTID": selectedAccount,
      "MerchantID": "GETCLIENTLOANACCOUNTS",
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Repayment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Loan Account",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.loanAccount,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Outstanding Balance",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.loanOutstandingBalance,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Select Your Payment Account",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      hint: const Text(
                        "Select Account",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      items: accounts,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAccount = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a payment account';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select Payment Type:',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Full'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Radio<bool>(
                                    activeColor: const Color(0xff293178),
                                    fillColor: WidgetStateColor.resolveWith(
                                        (states) => const Color(0xff293178)),
                                    value: true,
                                    groupValue: _isFullPayment,
                                    onChanged: _handlePaymentTypeChange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Partial'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Radio<bool>(
                                    activeColor: const Color(0xff293178),
                                    fillColor: WidgetStateColor.resolveWith(
                                        (states) => const Color(0xff293178)),
                                    value: false,
                                    groupValue: _isFullPayment,
                                    onChanged: _handlePaymentTypeChange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (!_isFullPayment && (value == null || value.isEmpty)) {
                        return 'Please enter an amount to pay';
                      }
                      if (_isFullPayment) {
                        innerObj['AMOUNT'] = widget.loanOutstandingBalance;
                      } else {
                        innerObj['AMOUNT'] = value;
                      }
                      return null;
                    },
                    controller: _amountController,
                    enabled: !_isFullPayment,
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount To Pay',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _remarksController,
                    decoration: const InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        innerObj['INFOFIELD2'] = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "PIN"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "PIN required*";
                      }
                      requestobj["EncryptedFields"] = {
                        "PIN": CryptLib.encryptField(value)
                      };
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isMakingPayment
                      ? LoadUtil()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await insertInnerObjects();
                              makeLoanPayment().then((value) {
                                if (value.status ==
                                    StatusCode.success.statusCode) {
                                  DynamicPostCall.processDynamicResponse(
                                      DynamicData(
                                          actionType: ActionType.PAYBILL,
                                          dynamicResponse: value),
                                      context,
                                      "");
                                }
                              });
                            }
                          },
                          child: const Text('Proceed to Pay'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
