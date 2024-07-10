import 'dart:convert';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../antochanges/so.dart';

final _sharedPrefs = CommonSharedPref();

class DeleteStandingOrder {
  static confirmPIN(
    context,
    ModuleItem moduleItem,
    SILIST standingOrder,
  ) {
    return showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => ModalBottomSheet(
        moduleItem: moduleItem,
        standingOrder: standingOrder,
      ),
    );
  }
}

class ModalBottomSheet extends StatefulWidget {
  ModalBottomSheet({
    super.key,
    required this.moduleItem,
    required this.standingOrder,
    this.formItem,
    this.preCallData,
  });

  final ModuleItem moduleItem;
  final SILIST standingOrder;
  FormItem? formItem;
  PreCallData? preCallData;

  @override
  State<StatefulWidget> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  static final formKey = GlobalKey<FormState>();
  static final _dynamicRequest = DynamicFormRequest();
  static final otpController = TextEditingController();
  static final TextEditingController _otpController = TextEditingController();
  static bool isLoading = false;
  final _apiService = APIService();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    otpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            opacity: .1,
            image: AssetImage(
              'assets/launcher.png',
            ),
          )),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
          child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(1);
                    },
                    child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.close), Text("Cancel")]),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your PIN to confirm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 4,
                  obscureText: true,
                  autofocus: true,
                  defaultPinTheme: PinTheme(
                      height: 44,
                      width: 44,
                      padding: const EdgeInsets.all(4),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: APIService.appPrimaryColor))),
                  controller: otpController,
                  onCompleted: (pin) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                isLoading
                    ? LoadUtil()
                    : SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            _apiService
                                .terminateStandingOrder(
                              widget.standingOrder.creditAccountID,
                              widget.standingOrder.amount,
                              widget.standingOrder.firstExecutionDate,
                              widget.standingOrder.frequency,
                              widget.standingOrder.lastExecutionDate,
                              otpController.text,
                              widget.standingOrder.siID,
                              widget.standingOrder.reference,
                            )
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              String? message = value.message;
                              // Navigator.pop(context);

                              if (value.status ==
                                  StatusCode.success.statusCode) {
                                otpController.clear();
                                Navigator.of(context).pop(value);
                              } else if (value.status ==
                                  StatusCode.failure.statusCode) {
                                otpController.clear();
                                AlertUtil.showAlertDialog(context,
                                    value.message ?? "Invalid Credentials",
                                    title: "Error");
                              } else {
                                otpController.clear();
                                AlertUtil.showAlertDialog(
                                    context, message ?? "",
                                    isInfoAlert: true, title: "Info");
                              }
                            });
                          },
                          child: const Text("Proceed"),
                        ))
              ])),
        ));
  }
}
