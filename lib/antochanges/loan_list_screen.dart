import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:craft_dynamic/antochanges/loan_payment_screen.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

import '../src/util/widget_util.dart';

CommonSharedPref _sharedPrefs = CommonSharedPref();

class LoanListScreen extends StatefulWidget {
  final ModuleItem moduleItem;
  const LoanListScreen({super.key, required this.moduleItem});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  final _apiServices = APIService();
  late Future<DynamicResponse> _loanInfoFuture;
  final TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loanInfoFuture = _apiServices.getLoanInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Information'),
      ),
      body: FutureBuilder<DynamicResponse>(
        future: _loanInfoFuture,
        builder:
            (BuildContext context, AsyncSnapshot<DynamicResponse> snapshot) {
          Widget child = Center(
            child: CircularLoadUtil(),
          );

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            child = Center(child: CircularLoadUtil());
          } else if (snapshot.hasData) {
            List<dynamic>? loans = snapshot.data?.dynamicList;
            List<Map> items = [];

            if (loans != null) {
              for (var item in loans) {
                items.add(item);
              }
            }

            child = ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var mapItem = items[index];
                mapItem
                    .removeWhere((key, value) => key == null || value == null);

                String loanAccount = mapItem['Loan Account'] ?? '';
                String loanOutstandingBalance =
                    mapItem['Total Outstanding']?.toString() ?? '0';
                String loanStatus = mapItem['Loan ID'] ?? "";

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 1.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        ...mapItem.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${entry.key}:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: WidgetUtil.getTextColor(
                                      entry.value.toString(),
                                      entry.key.toString(),
                                    ),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        loanStatus == "No Active Loan found"
                            ? const SizedBox(
                                height: 1,
                                width: 1,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.navigate(LoanPaymentScreen(
                                      loanAccount: loanAccount,
                                      loanOutstandingBalance:
                                          loanOutstandingBalance,
                                      moduleItem: widget.moduleItem,
                                    ));
                                  },
                                  child: Text('Pay'),
                                ),
                              ),
                        // Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             flex: 4,
                        //             child: Container(
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: ElevatedButton(
                        //                   onPressed: () {
                        //                     context.navigate(LoanPaymentScreen(
                        //                       loanAccount: loanAccount,
                        //                       loanOutstandingBalance:
                        //                           loanOutstandingBalance,
                        //                       moduleItem: widget.moduleItem,
                        //                     ));
                        //                   },
                        //                   child: Text('Pay'),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           // Expanded(
                        //           //   flex: 4,
                        //           //   child: Container(
                        //           //     child: Padding(
                        //           //       padding: const EdgeInsets.all(8.0),
                        //           //       child: ElevatedButton(
                        //           //         onPressed: () {
                        //           //           showModalBottomSheet<void>(
                        //           //             showDragHandle: true,
                        //           //             enableDrag: true,
                        //           //             context: context,
                        //           //             builder: (BuildContext context) {
                        //           //               return ListView(
                        //           //                   shrinkWrap: true,
                        //           //                   children: [
                        //           //                     Container(
                        //           //                         padding:
                        //           //                             const EdgeInsets
                        //           //                                 .only(
                        //           //                                 left: 16,
                        //           //                                 right: 16,
                        //           //                                 top: 12,
                        //           //                                 bottom: 4),
                        //           //                         decoration:
                        //           //                             const BoxDecoration(
                        //           //                                 image:
                        //           //                                     DecorationImage(
                        //           //                           opacity: .1,
                        //           //                           image: AssetImage(
                        //           //                             'assets/launcher.png',
                        //           //                           ),
                        //           //                         )),
                        //           //                         child: Column(
                        //           //                           children: [
                        //           //                             Row(
                        //           //                               children: [
                        //           //                                 const Text(
                        //           //                                   "Enter Pin to Continue",
                        //           //                                   style: TextStyle(
                        //           //                                       fontSize:
                        //           //                                           20),
                        //           //                                 ),
                        //           //                                 const Spacer(),
                        //           //                                 TextButton(
                        //           //                                   onPressed:
                        //           //                                       () {
                        //           //                                     Navigator.of(
                        //           //                                             context)
                        //           //                                         .pop(
                        //           //                                             1);
                        //           //                                   },
                        //           //                                   child: const Row(
                        //           //                                       children: [
                        //           //                                         Icon(Icons
                        //           //                                             .close),
                        //           //                                         Text(
                        //           //                                             "Cancel")
                        //           //                                       ]),
                        //           //                                 ),
                        //           //                               ],
                        //           //                             ),
                        //           //                             const SizedBox(
                        //           //                               height: 12,
                        //           //                             ),
                        //           //                             Form(
                        //           //                                 key: _formKey,
                        //           //                                 child: Column(
                        //           //                                   children: [
                        //           //                                     TextFormField(
                        //           //                                       obscureText:
                        //           //                                           true,
                        //           //                                       keyboardType:
                        //           //                                           TextInputType.number,
                        //           //                                       decoration:
                        //           //                                           const InputDecoration(labelText: "PIN"),
                        //           //                                       validator:
                        //           //                                           (value) {
                        //           //                                         if (value == null ||
                        //           //                                             value.isEmpty) {
                        //           //                                           return "PIN required*";
                        //           //                                         }
                        //           //
                        //           //                                         return null;
                        //           //                                       },
                        //           //                                     ),
                        //           //                                     const SizedBox(
                        //           //                                         height:
                        //           //                                             16),
                        //           //                                     ElevatedButton(
                        //           //                                       onPressed:
                        //           //                                           () {
                        //           //                                         if (_formKey
                        //           //                                             .currentState!
                        //           //                                             .validate()) {
                        //           //                                           context.navigate(LoanRepaymentHistoryScreen(
                        //           //                                             moduleItem: widget.moduleItem,
                        //           //                                             encryptedPin: _pinController.text,
                        //           //                                           ));
                        //           //                                         }
                        //           //                                       },
                        //           //                                       child: Text(
                        //           //                                           'Continue'),
                        //           //                                     ),
                        //           //                                   ],
                        //           //                                 )),
                        //           //                             const SizedBox(
                        //           //                               height: 44,
                        //           //                             ),
                        //           //                             const SizedBox(
                        //           //                               height: 44,
                        //           //                             )
                        //           //                           ],
                        //           //                         ))
                        //           //                   ]);
                        //           //             },
                        //           //           );
                        //           //         },
                        //           //         child: Text('History'),
                        //           //       ),
                        //           //     ),
                        //           //   ),
                        //           // ),
                        //         ],
                        //       ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          } else {
            child = Center(
              child: Text('${snapshot.error}'),
            );
          }

          return child;
        },
      ),
    );
  }
}

class EmailsList {}
