import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/util/local_data_util.dart';
import 'package:flutter/material.dart';

class ViewBeneficiary extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewBeneficiary({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewBeneficiaryState();
}

class _ViewBeneficiaryState extends State<ViewBeneficiary> {
  final _beneficiaryRepository = BeneficiaryRepository();
  final _dynamicFormRequest = DynamicFormRequest();

  @override
  initState() {
    super.initState();
    isCallingService.value = false;
  }

  getBeneficiaries() => _beneficiaryRepository.getAllBeneficiaries();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleItem.moduleName),
      ),
      body: FutureBuilder<List<Beneficiary>>(
          future: viewBeneficiaries(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Beneficiary>> snapshot) {
            Widget widget = Center(child: CircularLoadUtil());

            if (snapshot.hasData) {
              final itemCount = snapshot.data?.length ?? 0;

              if (itemCount == 0) {
                widget = EmptyUtil();
              } else {
                widget = ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final beneficiary = snapshot.data![index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Beneficiary ${index + 1}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: APIService.appPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(beneficiary.accountAlias),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 2,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Account",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(beneficiary.accountID),
                                      ],
                                    ))
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  AlertUtil.showAlertDialog(context,
                                          "Confirm action to delete this beneficiary ${beneficiary.accountAlias}",
                                          isConfirm: true,
                                          title: "Delete",
                                          confirmButtonText: "Delete")
                                      .then((value) {
                                    if (value) {
                                      deleteBeneficiary(beneficiary, context);
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                  size: 34,
                                ))
                          ],
                        ),
                      );
                    });
              }
            }
            return widget;
          }),
    );
  }

  Future<List<Beneficiary>> viewBeneficiaries() async {
    isCallingService.value = true;
    List<Beneficiary> beneficiaries = [];
    try {
      DynamicInput.formInputValues.clear();
      DynamicInput.formInputValues
          .addAll({"MerchantID": widget.moduleItem.merchantID});

      DynamicInput.formInputValues.addAll({"HEADER": "GETBENEFICIARY"});
      DynamicInput.formInputValues.addAll({"INFOFIELD1": "TRANSFER"});
    } catch (e) {
      debugPrint("benefifciary error $e");
    }

    await _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
            dataObj: DynamicInput.formInputValues,
            context: context,
            listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;
      if (value?.status == StatusCode.success.statusCode) {
        var beneficiaryList = value?.beneficiaries;
        if (beneficiaryList != []) {
          beneficiaryList?.forEach((beneficiary) {
            beneficiaries.add(Beneficiary.fromJson(beneficiary));
          });
        }
      }
    });
    return beneficiaries;
  }

  deleteBeneficiary(Beneficiary beneficiary, context) {
    isCallingService.value = true;
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues
        .addAll({"INFOFIELD1": beneficiary.accountAlias});
    DynamicInput.formInputValues
        .addAll({"INFOFIELD2": beneficiary.merchantName});
    DynamicInput.formInputValues.addAll({"INFOFIELD4": beneficiary.accountID});
    DynamicInput.formInputValues.addAll({"INFOFIELD3": beneficiary.rowId});
    DynamicInput.formInputValues
        .addAll({"MerchantID": widget.moduleItem.merchantID});
    DynamicInput.formInputValues.addAll({"HEADER": "DELETEBENEFICIARY"});
    _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
            dataObj: DynamicInput.formInputValues,
            context: context,
            listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;

      if (value?.status == StatusCode.success.statusCode) {
        CommonUtils.showToast(
            "Beneficiary ${beneficiary.accountAlias} successfully deleted");
        setState(() {
          _beneficiaryRepository.deleteBeneficiary(beneficiary.rowId);
          var beneficiaries = value?.beneficiaries;
          if (beneficiaries != null) {
            LocalDataUtil.refreshBeneficiaries(beneficiaries);
          }
        });
      } else {
        AlertUtil.showAlertDialog(
          context,
          value?.message ?? "Error",
        );
      }
    });
  }
}
