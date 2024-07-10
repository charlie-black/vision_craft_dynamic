// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/util/local_data_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../../craft_dynamic.dart';

class RequestStatusScreen extends StatefulWidget {
  RequestStatusScreen({Key? key, required this.postDynamic, this.moduleItem})
      : super(key: key);

  PostDynamic postDynamic;
  ModuleItem? moduleItem;

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen>
    with SingleTickerProviderStateMixin {
  final _sharedPref = CommonSharedPref();
  StatusCode statusCode = StatusCode.success;
  late var _controller;

  @override
  void initState() {
    Vibration.vibrate(duration: 500);
    super.initState();
    statusCode = StatusCode.values.firstWhere(
        (statusCode) => statusCode.statusCode == widget.postDynamic.status);
    _isChangePinCheck();
    _checkAddBenefiary();
    _setUpAnimationController();
    _isChangeBankType();
    _isChangeLanguage();
  }

  _setUpAnimationController() {
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 5000), () {
          if (mounted) {
            _controller.forward(from: 0.0);
          }
        });
      }
    });
  }

  _checkAddBenefiary() async {
    var beneficiaries = widget.postDynamic.beneficiaries ?? [];
    if (beneficiaries.isNotEmpty) {
      var beneficiaries = widget.postDynamic.beneficiaries;
      if (beneficiaries != null && beneficiaries.isNotEmpty) {
        LocalDataUtil.refreshBeneficiaries(beneficiaries);
      }
    }
  }

  _isChangePinCheck() async {
    if (widget.moduleItem?.moduleId == ModuleId.PIN.name) {
      await _sharedPref.setBio(false);
    }
  }

  _isChangeBankType() async {
    if (widget.postDynamic.status == changeBankType) {
      var bankID = widget.postDynamic.formID ?? "";
      await _sharedPref.setBankID(bankID.isEmpty ? null : bankID);
    }
  }

  _isChangeLanguage() async {
    if (widget.postDynamic.status == changeLanguage) {
      await Hive.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    var message = widget.postDynamic.message;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: WillPopScope(
            onWillPop: () async {
              closeOrLogout();
              return true;
            },
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 18),
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color:
                                Theme.of(context).primaryColor.withOpacity(.1)),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    closeOrLogout();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: APIService.appPrimaryColor,
                                    size: 34,
                                  )),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Column(
                              children: [
                                Lottie.asset(getAvatarType(statusCode),
                                    height: 88,
                                    width: 88,
                                    controller: _controller, onLoaded: (comp) {
                                  _controller
                                    ..duration = comp.duration
                                    ..forward();
                                }),
                                const SizedBox(
                                  height: 44,
                                ),
                                Center(
                                    child: Text(
                                  message ??
                                      widget.postDynamic.notifyText ??
                                      "Please try again later!",
                                  style: const TextStyle(
                                      fontSize: 14, height: 1.5),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 44,
                            ),
                            SizedBox(
                                width: 200,
                                child: WidgetFactory.buildButton(
                                    context, closeOrLogout, "Done".tr())),
                          ],
                        ))),
              ),
            )));
  }

  String getAvatarType(StatusCode statusCode) {
    switch (statusCode) {
      case StatusCode.success:
        return "packages/craft_dynamic/assets/lottie/success.json";

      case StatusCode.failure:
        return "packages/craft_dynamic/assets/lottie/error.json";
      case StatusCode.token:
        break;
      case StatusCode.changeLanguage:
        break;
      case StatusCode.changePin:
        break;
      case StatusCode.unknown:
        break;
      case StatusCode.otp:
        break;
      case StatusCode.changeBankType:
        break;
      case StatusCode.deviceMismatch:
        break;
      case StatusCode.setsecurityquestions:
        break;
      case StatusCode.logout:
        break;
    }
    return "packages/craft_dynamic/assets/lottie/information.json";
  }

  closeOrLogout() {
    widget.moduleItem != null &&
                widget.moduleItem?.moduleId == ModuleId.PIN.name ||
            widget.moduleItem?.moduleId == ModuleId.LANGUAGEPREFERENCE.name ||
            widget.postDynamic.status == StatusCode.changeBankType.statusCode ||
            widget.moduleItem?.moduleId == ModuleId.FORGOTPIN.name ||
            widget.postDynamic.status == StatusCode.logout.statusCode
        ? logout()
        : closePage();
  }

  void logout() async {
    Widget? logoutScreen =
        Provider.of<PluginState>(context, listen: false).logoutScreen;
    if (widget.moduleItem?.moduleId == ModuleId.LANGUAGEPREFERENCE.name) {
      await _sharedPref.setTempLanguage(widget.postDynamic.languageID ?? "ENG");
    }
    if (logoutScreen != null) {
      CommonUtils.getXRouteAndPopAll(widget: logoutScreen);
    }
  }

  void closePage() {
    int no = widget.postDynamic.backstack ?? 0;
    for (int i = 0; i <= no; i++) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
