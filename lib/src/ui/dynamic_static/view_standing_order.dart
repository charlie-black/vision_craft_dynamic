// ignore_for_file: must_be_immutable, unnecessary_const

import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:craft_dynamic/antochanges/so.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/delete_standing_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pinput/pinput.dart';

final _dynamicRequest = DynamicFormRequest();
final _sharedPrefs = CommonSharedPref();
final _apiService = APIService();

class ViewStandingOrder extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewStandingOrder({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewStandingOrderState();
}

class _ViewStandingOrderState extends State<ViewStandingOrder> {
  List<StandingOrder> standingOrderList = [];

  @override
  void initState() {
    // _apiService.fetchStandingOrder();
    super.initState();
  }

  getStandingOrder() => _dynamicRequest.dynamicRequest(widget.moduleItem,
      dataObj: DynamicInput.formInputValues,
      encryptedField: DynamicInput.encryptedField,
      context: context,
      listType: ListType.ViewOrderList);

  @override
  Widget build(BuildContext context) {
    AppLogger.appLogD(
        tag: "view_standing_order", message: "building screen...");

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(widget.moduleItem.moduleName),
        ),
        body: Stack(
          children: [
            FutureBuilder<SO>(
                future: _apiService.fetchStandingOrder(),
                builder: (BuildContext context, AsyncSnapshot<SO> snapshot) {
                  Widget child = Center(
                    child: CircularLoadUtil(),
                  );
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      SO? dy = snapshot.data;
                      List<SILIST>? st = dy!.sILIST;

                      st?.removeWhere((item) => item.status != "ACTIVE");

                      if (st != null && st.isNotEmpty) {
                        child = ListView.builder(
                          itemCount: st?.length,
                          itemBuilder: (context, index) {
                            return StandingOrderItem(
                              standingOrder: st[index],
                              moduleItem: widget.moduleItem,
                              refreshParent: refresh,
                            );
                          },
                        );
                      } else {
                        child = Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 122,
                                color:
                                    APIService.appPrimaryColor.withOpacity(.4),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text("No standing orders found!")
                            ],
                          ),
                        );
                      }
                    }
                  }
                  return child;
                }),
            Obx(() => isDeletingStandingOrder.value
                ? LoadUtil().frosted(
                    blur: 2,
                  )
                : const SizedBox())
          ],
        ));
  }

  Future<List<StandingOrder>?> _viewStandingOrder() async {
    List<StandingOrder>? orders = [];

    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues.addAll({"MerchantID": 'GETSILIST'});
    DynamicInput.formInputValues
        .addAll({"ModuleID": 'STANDINGORDERVIEWDETAILS'});
    DynamicInput.formInputValues.addAll({"HEADER": "VIEWSTANDINGORDER"});
    // DynamicInput.formInputValues.add({"INFOFIELD1": "TRANSFER"});
    var results = await _dynamicRequest.dynamicRequest(widget.moduleItem,
        dataObj: DynamicInput.formInputValues,
        context: context,
        listType: ListType.ViewOrderList);

    if (results?.status == StatusCode.success.statusCode) {
      var list = results?.dynamicList;
      AppLogger.appLogD(tag: "Standing orders", message: list);
      if (list != []) {
        list?.forEach((order) {
          try {
            Map<String, dynamic> orderJson = order;
            orders.add(StandingOrder.fromJson(orderJson));
          } catch (e) {
            AppLogger.appLogE(
                tag: "Add standing order error", message: e.toString());
          }
        });
      }
    }

    return orders;
  }

  void refresh() {
    setState(() {});
  }
}

class StandingOrderItem extends StatefulWidget {
  SILIST standingOrder;
  ModuleItem moduleItem;
  Function() refreshParent;

  StandingOrderItem(
      {Key? key,
      required this.standingOrder,
      required this.moduleItem,
      required this.refreshParent})
      : super(key: key);

  @override
  State<StandingOrderItem> createState() => _StandingOrderItemState();
}

class _StandingOrderItemState extends State<StandingOrderItem> {
  final TextEditingController _textEditingController = TextEditingController();
  static final TextEditingController _otpController = TextEditingController();
  static bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8.0, top: 4),
        child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: IntrinsicHeight(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowItem(
                          title: "Effective date",
                          value: widget.standingOrder.firstExecutionDate,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        // RowItem(
                        //   title: "Debit Account",
                        //   value: widget.standingOrder.creditAccountID,
                        // ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Amount",
                          value: widget.standingOrder.amount.toString(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        // RowItem(
                        //   title: "Narration",
                        //   value: widget.standingOrder.narration,
                        // ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Beneficiary",
                          value: widget.standingOrder.frequency,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Expected Executions",
                          value: widget.standingOrder.noOfExecutions.toString(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Debit Account",
                          value: widget.standingOrder.debitAccount.toString(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Credit Account",
                          value:
                              widget.standingOrder.creditAccountID.toString(),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        IconButton(
                            onPressed: () {
                              _confirmDeleteAction(context,
                                      widget.standingOrder, widget.moduleItem)
                                  .then((value) {
                                if (value) {
                                  // isDeletingStandingOrder.value = true;
                                  // _deleteStandingOrder(,
                                  //     widget.moduleItem, context);
                                }
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size.fromHeight(40))),
                            icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: APIService.appPrimaryColor,
                                    size: 34,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    "Terminate",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  )
                                ]))
                      ],
                    ))
                  ],
                )))));
  }

  // _deleteStandingOrder(
  //     SILIST standingOrder, ModuleItem moduleItem, context) async {
  //   DynamicInput.formInputValues.clear();
  //   DynamicInput.formInputValues
  //       .addAll({"INFOFIELD1": standingOrder.standingOrderID});
  //   DynamicInput.formInputValues
  //       .addAll({RequestParam.MerchantID.name: moduleItem.merchantID});
  //   DynamicInput.formInputValues
  //       .addAll({RequestParam.HEADER.name: "DELETESTANDINGORDER"});
  //
  //   await _dynamicRequest
  //       .dynamicRequest(moduleItem,
  //           dataObj: DynamicInput.formInputValues,
  //           context: context,
  //           listType: ListType.ViewOrderList)
  //       .then((value) {
  //     isDeletingStandingOrder.value = false;
  //     if (value?.status == StatusCode.success.statusCode) {
  //       CommonUtils.showToast("Standing order hidden successfully");
  //       widget.refreshParent();
  //     } else {
  //       AlertUtil.showAlertDialog(
  //         context,
  //         value?.message ?? "Unable to hide standing Order",
  //       );
  //     }
  //   });
  // }

  _confirmDeleteAction(
      BuildContext context, SILIST standingOrder, ModuleItem moduleItem) {
    return AlertUtil.showAlertDialog(
      context,
      "Confirm Termination of Standing order for credit account ${standingOrder.creditAccountID} with amount ${standingOrder.amount}",
      isConfirm: true,
      title: "Confirm",
      confirmButtonText: "Terminate",
    ).then((value) {
      if (value) {
        DeleteStandingOrder.confirmPIN(context, moduleItem, standingOrder)
            .then((value) {
          if (value.status == StatusCode.success.statusCode) {
            AlertUtil.showAlertDialog(context, value.message ?? "",
                    isInfoAlert: true, title: "Info")
                .then((value) {
              widget.refreshParent();
            });
          }
        });
        // showModalBottomDialogPIN(context, 'Enter PIN', pin, standingOrder);
      }

      // Navigator.pop(context);

      //     // .then((value) {
      //   debugPrint('terminationValue>>>> $value');
      //   debugPrint('terminationValue>>>> ${value.status}');
      // if(value.status == StatusCode.success.statusCode){
      //   AlertUtil.showAlertDialog(context, value.message.toString());
      // }
      // else{
      //   AlertUtil.showAlertDialog(context, value.message.toString());
      //
      // }
    });
    // });
  }
}

class RowItem extends StatelessWidget {
  final String title;
  String? value;

  RowItem({required this.title, this.value, super.key});

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$title:"),
            Text(value ?? "***",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ]);
}

extension ApiCall on APIService {
  Future<SO> fetchStandingOrder() async {
    String? res;
    SO so = SO();
    // DynamicResponse dynamicResponse =
    //     DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "GETSILIST";
    innerMap["ModuleID"] = "STANDINGORDERVIEWDETAILS";

    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      so = SO.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("fetch>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return so;
    }

    return so;
  }
//   if (results?.status == StatusCode.success.statusCode) {
//   var list = results?.dynamicList;
//   AppLogger.appLogD(tag: "Standing orders", message: list);
//   if (list != []) {
//   list?.forEach((order) {
//   try {
//   Map<String, dynamic> orderJson = order;
//   orders.add(StandingOrder.fromJson(orderJson));
//   } catch (e) {
//   AppLogger.appLogE(
//   tag: "Add standing order error", message: e.toString());
//   }
//   });
//   }
//   }
//
//   return orders;
// }
// Future<DynamicResponse> terminateStandingOrder() async {
//   String? res;
//   DynamicResponse dynamicResponse =
//       DynamicResponse(status: StatusCode.unknown.name);
//   Map<String, dynamic> requestObj = {};
//   Map<String, dynamic> innerMap = {};
//   innerMap["MerchantID"] = "ADDSTANDINGINSTRUCTIONS";
//   innerMap["INFOFIELD10"] = "R";
//
//   requestObj[RequestParam.Paybill.name] = innerMap;
//
//   final route =
//       await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
//   try {
//     res = await performDioRequest(
//         await dioRequestBodySetUp("PAYBILL",
//             objectMap: requestObj, isAuthenticate: false),
//         route: route);
//     dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
//     logger.d("termination>>: $res");
//   } catch (e) {
//     // CommonUtils.showToast("Unable to get promotional images");
//     AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
//     return dynamicResponse;
//   }
//
//   return dynamicResponse;
// }

// Future<DynamicResponse> viewStandingOrder() async {
//   String? res;
//   DynamicResponse dynamicResponse =
//       DynamicResponse(status: StatusCode.unknown.name);
//   Map<String, dynamic> requestObj = {};
//   Map<String, dynamic> innerMap = {};
//   innerMap["MerchantID"] = "GETSILIST";
//   innerMap["ModuleID"] = "STANDINGORDERVIEWDETAILS";
//
//   requestObj[RequestParam.Paybill.name] = innerMap;
//
//   final route =
//       await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
//   try {
//     res = await performDioRequest(
//         await dioRequestBodySetUp("PAYBILL",
//             objectMap: requestObj, isAuthenticate: false),
//         route: route);
//     dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
//     logger.d("standing>>: $res");
//   } catch (e) {
//     // CommonUtils.showToast("Unable to get promotional images");
//     AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
//     return dynamicResponse;
//   }
//
//   return dynamicResponse;
// }
// Future<List<StandingOrder>?> _viewStandingOrder() async {
//     List<StandingOrder>? orders = [];
//
//     DynamicInput.formInputValues.clear();
//     DynamicInput.formInputValues
//         .addAll({"MerchantID": ""});
//     DynamicInput.formInputValues.addAll({"HEADER": "VIEWSTANDINGORDER"});
//     // DynamicInput.formInputValues.add({"INFOFIELD1": "TRANSFER"});
//     var results = await _dynamicRequest.dynamicRequest(widget.moduleItem,
//         dataObj: DynamicInput.formInputValues,
//         context: context,
//         listType: ListType.ViewOrderList);
//
//     if (results?.status == StatusCode.success.statusCode) {
//       var list = results?.dynamicList;
//       AppLogger.appLogD(tag: "Standing orders", message: list);
//       if (list != []) {
//         list?.forEach((order) {
//           try {
//             Map<String, dynamic> orderJson = order;
//             orders.add(StandingOrder.fromJson(orderJson));
//           } catch (e) {
//             AppLogger.appLogE(
//                 tag: "Add standing order error", message: e.toString());
//           }
//         });
//       }
//     }
//
//     return orders;
//   }
}
