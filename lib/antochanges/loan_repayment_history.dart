import 'dart:convert';

import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

CommonSharedPref _sharedPrefs = CommonSharedPref();

class LoanRepaymentHistoryList extends StatefulWidget {
  const LoanRepaymentHistoryList({super.key});

  @override
  State<LoanRepaymentHistoryList> createState() =>
      _LoanRepaymentHistoryListState();
}

class _LoanRepaymentHistoryListState extends State<LoanRepaymentHistoryList> {
  final _apiServices = APIService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Repayment History'),
      ),
      body: FutureBuilder(
        future: _apiServices.getLoanRepaymentHistory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget child = Center(
            child: CircularLoadUtil(),
          );
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            child = const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else {
            if (snapshot.hasData) {
              // emailList = snapshot.data;
              // emails = emailList!.eMAILLIST!;
              child = ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         // EmailDetailsScreen(
                        //         //     emailSubscription: emails[index]),
                        //   ),
                        // );
                      },
                      child: const Column(
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Loan ID:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('emails[index].recipient!'),
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'OutstandingPrincipal:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("${'emails[index].accountNumber'},"),
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dispersed Amount:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("${'emails[index].accountNumber'},"),
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:

                                    // LoanID
                                    // ,DispersedAmount
                                    // ,OutstandingPrincipal
                                    // ,OutstandingInterest
                                    // ,RepaymentFrequency
                                    // ,InstallmentAmount
                                    // ,InstallmentStartDate
                                    // ,ValueDate
                                    // ,MaturityDate
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Outstanding Interest:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    " ${'emails[index].frequency'}",
                                  ),
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Installment Amount:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    " '{emails[index].'subscribedON'}'",
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Divider())
                        ],
                      ));
                },
              );
            } else {
              child = Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          return child;
        },
      ),
    );
  }
}

class EmailsList {}
