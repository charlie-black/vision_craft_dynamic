import 'dart:convert';

import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

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
  TextEditingController _amountController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  List<String> bankAccounts = [];
  final _profilerepo = ProfileRepository();
  final Map<String, dynamic> innerObj = {};
  final Map<String, dynamic> requestobj = {};
  final api = APIService();
  String? selectedAccount;
  bool _isMakingPayment = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> fetchLoanAccounts() async {
    api.getLoanAccounts();
    final response = await http.get(Uri.parse('https://your_api_endpoint'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> dataList = data.map((item) => item.toString()).toList();

      setState(() {
        bankAccounts = dataList;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.loanOutstandingBalance;
    fetchLoanAccounts();
  }

  void _handlePaymentTypeChange(bool? value) {
    setState(() {
      _isFullPayment = value!;
      if (_isFullPayment) {
        _amountController.text = widget.loanOutstandingBalance;
      } else {
        _amountController.clear();
      }
    });
  }

  makeLoanPayment() async {
    requestobj.addAll({"ModuleID": "PAYLOAN"});
    requestobj.addAll({"MerchantID": "GETCLIENTLOANACCOUNTS"});
    requestobj.addAll({"PayBill": innerObj});

    var response = await api.dynamicRequest(
        formID: "PAYBILL", requestObj: requestobj, webHeader: "account");

    if (response.status != "000") {
      setState(() {
        _isMakingPayment = false;
      });
      AlertUtil.showAlertDialog(context, response.message ?? "");
    } else {
      setState(() {
        _isMakingPayment = false;
      });
      Fluttertoast.showToast(
          msg: "Loan Payment was successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  Future<void> insertInnerObjects() async {
    innerObj.addAll({
      "INFOFIELD6": "LOANPAYOFF",
    });
    innerObj.addAll({
      "INFOFIELD3": "",
    });
    innerObj.addAll({
      "INFOFIELD4": "",
    });
    innerObj.addAll({
      "INFOFIELD5": "",
    });
    innerObj.addAll({
      "ACCOUNTID": widget.loanAccount,
    });
    innerObj.addAll({
      "BANKACCOUNTID": selectedAccount,
    });
    innerObj.addAll({"MerchantID": "GETCLIENTLOANACCOUNTS"});
  }

  @override
  void dispose() {
    _amountController.dispose();
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
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Loan Account",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              widget.loanAccount,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select Your Payment Account",
                      style: TextStyle(color: APIService.appPrimaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: bankAccounts[0], // Set the default value
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAccount = newValue!;
                        });
                      },
                      items:
                          bankAccounts.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select Payment Type:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1.0),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Full'),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: _isFullPayment,
                                onChanged: _handlePaymentTypeChange,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Partial'),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: _isFullPayment,
                                onChanged: _handlePaymentTypeChange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value != null && value != "") {
                        innerObj.addAll({'AMOUNT': value});
                      }
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
                      if (value != null && value != "") {
                        innerObj.addAll({'INFOFIELD2': value});
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "PIN"),
                    validator: (value) {
                      if (value == null || value == "") {
                        return "PIN required*";
                      }
                      requestobj.addAll({
                        "EncryptedFields": {"PIN": CryptLib.encryptField(value)}
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _isMakingPayment == true
                      ? LoadUtil()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isMakingPayment = true;
                              });
                              insertInnerObjects().then(makeLoanPayment());
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
