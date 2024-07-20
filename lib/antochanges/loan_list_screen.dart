import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

import '../src/util/widget_util.dart';

CommonSharedPref _sharedPrefs = CommonSharedPref();

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  final _apiServices = APIService();

  @override
  void initState() {
    _apiServices.getLoanInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Information'),
      ),
      body: FutureBuilder<DynamicResponse>(
        future: _apiServices.getLoanInfo(),
        builder:
            (BuildContext context, AsyncSnapshot<DynamicResponse> snapshot) {
          Widget child = Center(
            child: CircularLoadUtil(),
          );
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            child = Center(child: CircularLoadUtil());
          } else {
            if (snapshot.hasData) {
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
                                        "$key:xx",
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

class EmailsList {}
