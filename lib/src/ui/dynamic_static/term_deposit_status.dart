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
        builder:
            (BuildContext context, AsyncSnapshot<TermDepositDynamicResponse> snapshot) {
          Widget child = Center(
            child: CircularLoadUtil(),
          );
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            child = Center(child: CircularLoadUtil());
          } else {
            if (snapshot.hasData) {
              if (snapshot.data?.status != StatusCode.success.statusCode) {
                _showAlert(context, snapshot.data?.message ?? "");
              }

              List<dynamic>? loans = snapshot.data?.data.responseValue.responseData;
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
                  mapItem.removeWhere(
                          (key, value) => key == null || value == null);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 0.0),
                    child: Column(
                      children: mapItem
                          .map((key, value) => MapEntry(
                          key,
                          Container(
                              padding:
                              const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$key:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                        Theme.of(context).primaryColor),
                                  ),
                                  Flexible(
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: WidgetUtil.getTextColor(
                                                value.toString(),
                                                key.toString())),
                                        textAlign: TextAlign.right,
                                      ))
                                ],
                              ))))
                          .values
                          .toList(),
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
          }

          return child;
        },
      ),
    );
  }
}
