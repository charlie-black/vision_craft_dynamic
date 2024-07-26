import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:craft_dynamic/antochanges/term_deposit_dynamic_response.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

import '../../util/widget_util.dart';

CommonSharedPref _sharedPrefs = CommonSharedPref();

class TermDepositStatus extends StatefulWidget {
  const TermDepositStatus({super.key});

  @override
  State<TermDepositStatus> createState() => _TermDepositStatusState();
}

class _TermDepositStatusState extends State<TermDepositStatus> {
  final _apiServices = APIService();

  @override
  void initState() {
    super.initState();
  }

  void _showAlert(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertUtil.showAlertDialog(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Term Deposit Status'),
      ),
      body: FutureBuilder<TermDepositDynamicResponse>(
        future: _apiServices.getTermDepositStatus(),
        builder: (BuildContext context, AsyncSnapshot<TermDepositDynamicResponse> snapshot) {
          Widget child = Center(
            child: CircularLoadUtil(),
          );
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            child = Center(child: CircularLoadUtil());
          } else {
            if (snapshot.hasData) {
              if (snapshot.data?.status != "000") {
                _showAlert(context, snapshot.data?.message ?? "");
              }

              List<TermDepositData>? deposits = snapshot.data?.data;
              List<Map<String, dynamic>> items = [];

              if (deposits != null) {
                for (var item in deposits) {
                  Map<String, dynamic> mapItem = {
                    "Branch Name": item.branchName,
                    "Account ID": item.accountId,
                    "Account Name": item.accountName,
                    "Receipt ID": item.receiptId,
                    "Serial ID": item.serialId,
                    "Currency ID": item.currencyId,
                    "Amount": item.amount,
                    "Interest Rate": item.interestRate,
                    "Term": item.term,
                    "Start Date": item.startDate,
                    "Mature Date": item.matureDate,
                  };

                  // Remove null values
                  mapItem.removeWhere((key, value) => value == null);
                  items.add(mapItem);
                }
              }

              child = ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var mapItem = items[index];

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
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              );
            } else {
              child = Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          return child;
        },
      )

    );
  }
}
