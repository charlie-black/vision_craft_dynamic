import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:craft_dynamic/antochanges/loan_repayment_history.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class LoanAccounts extends StatefulWidget {
  @override
  _LoanAccountsState createState() => _LoanAccountsState();
}

class _LoanAccountsState extends State<LoanAccounts> {
  List<Map<String, dynamic>> sampleBankAccounts = [
    {"id": 1, "accountNumber": "123456789", "accountType": "Savings"},
    {"id": 2, "accountNumber": "987654321", "accountType": "Checking"},
    {"id": 3, "accountNumber": "456789012", "accountType": "Savings"},
    // Add more sample bank accounts as needed
  ];

  final _apiService = APIService();
  String selectedAccount= '';
  List<String> bankAccounts = [];

  Future<void> fetchData() async {
    _apiService.getLoanAccounts();
    // Replace 'your_api_endpoint' with the actual API endpoint
    final response = await http.get(Uri.parse('https://your_api_endpoint'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      List<dynamic> data = json.decode(response.body);
      List<String> dataList = data.map((item) => item.toString()).toList();

      // Set the bankAccounts list to trigger a rebuild
      setState(() {
        bankAccounts = dataList;
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Loan Accounts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display a spinner while fetching data
            if (bankAccounts.isEmpty)
              CircularProgressIndicator()
            else
            // Display the DropdownButton with the fetched bank accounts
              DropdownButton<String>(
                value: bankAccounts[0], // Set the default value
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAccount = newValue!;
                  });
                },
                items: bankAccounts
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            WidgetFactory.buildButton(context, () => {
              // _apiService.getLoanRepaymentHistory();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoanRepaymentHistoryList()))
            }, 'Proceed')
          ],
        ),
      ),
    );
  }
}
