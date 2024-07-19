// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/receipt_qr_code.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';
import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  ListWidget(
      {Key? key,
      required this.scrollable,
      this.dynamicList = const [],
      this.summary = const [],
      this.controlID,
      this.serviceParamID,
      this.moduleItem})
      : super(key: key);

  final bool scrollable;
  String? controlID, serviceParamID;
  ModuleItem? moduleItem;
  List<dynamic>? dynamicList, summary;

  List<Map> mapItems = [];
  List<Map> summaryItems = [];

  @override
  Widget build(BuildContext context) {
    // return Text(jsonTxt!.toString());
    mapItems.clear();
    summaryItems.clear();

    if (dynamicList != null) {
      for (var item in dynamicList ?? []) {
        mapItems.add(item);
      }
    }

    if (summary != null) {
      for (var item in summary ?? []) {
        summaryItems.add(item);
      }
    }

    AppLogger.appLogD(
        tag: "summary list moduleid ${moduleItem?.moduleId}",
        message: dynamicList);

    return dynamicList != null &&
            (dynamicList?.isNotEmpty ?? false) &&
            dynamicList?.first != {}
        ? Column(children: [
            summaryItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          moduleItem?.moduleId == "LOANANALYZER"
                              ? "Loan Summary"
                              : "Summary",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: summaryItems.length,
                          itemBuilder: (context, index) {
                            var mapItem = summaryItems[index];
                            mapItem.removeWhere(
                                (key, value) => key == null || value == null);
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 0.0),
                                      child: Column(
                                        children: mapItem
                                            .map((key, value) => MapEntry(
                                                key,
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 2),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "$key:",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                        Text(
                                                          value.toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: WidgetUtil
                                                                  .getTextColor(
                                                                      value
                                                                          .toString(),
                                                                      key.toString())),
                                                          softWrap: true,
                                                        )
                                                      ],
                                                    ))))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ));
                          },
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).primaryColor.withOpacity(.6),
                        )
                      ],
                    ))
                : const SizedBox(),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: mapItems.length,
              itemBuilder: (context, index) {
                var mapItem = mapItems[index];
                mapItem
                    .removeWhere((key, value) => key == null || value == null);
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Card(
                            elevation: 0,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.2))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: mapItem
                                            .map((key, value) => MapEntry(
                                                key,
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "$key",
                                                        ),
                                                        Flexible(
                                                            child: Text(
                                                          value.toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ))
                                                      ],
                                                    ))))
                                            .values
                                            .toList(),
                                      ),
                                      moduleItem?.moduleId == "EVENTPAYMENTS" &&
                                              mapItem['Status'] != "Failed"
                                          ? IconButton(
                                              onPressed: () async {
                                                final generator =
                                                    GenerateReceiptQRCode(
                                                        referenceId: mapItem[
                                                            "Reference"]);
                                                await generator
                                                    .generateAndOpenPDF();
                                              },
                                              icon: Icon(Icons.qr_code))
                                          : const SizedBox()
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    ));
              },
            ))
          ])
        : Center(
            child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyUtil(),
            ],
          ));
  }
}
