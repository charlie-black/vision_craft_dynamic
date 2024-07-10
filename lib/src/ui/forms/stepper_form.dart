// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class StepperFormWidget extends StatefulWidget {
  ModuleItem moduleItem;
  List<FormItem> formItems;

  StepperFormWidget(
      {required this.moduleItem, required this.formItems, super.key});

  @override
  State<StatefulWidget> createState() => _StepperFormWidgetState();
}

class _StepperFormWidgetState extends State<StepperFormWidget> {
  int _index = 0;
  List<FormItem> stepControls = [];
  List<GlobalKey<FormState>> formKeys = [];
  List<Step> steps = [];
  int stepperLength = 0;

  @override
  void initState() {
    stepControls = widget.formItems
        .where((formItem) => formItem.controlType == ViewType.STEP.name)
        .toList();
    stepperLength = stepControls.length - 1;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getSteps() {
    steps.clear();
    stepControls.asMap().forEach((key, step) {
      formKeys.add(GlobalKey<FormState>());
      steps.add(Step(
          title: Text(step.controlText ?? ""),
          isActive: _index >= key,
          state: _index >= key ? StepState.complete : StepState.disabled,
          content: StepForm(
            formKey: formKeys[key],
            formItems: widget.formItems,
            formItem: step,
            moduleItem: widget.moduleItem,
            currentIndex: _index,
            stepperLength: stepperLength,
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    getSteps();
    return WillPopScope(
        onWillPop: () async {
          if (Provider.of<PluginState>(context, listen: false)
              .loadingNetworkData) {
            CommonUtils.showToast("Please wait...");
            return false;
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: Text(widget.moduleItem.moduleName),
            ),
            body: Stepper(
                currentStep: _index,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return _index == stepperLength
                      ? const SizedBox()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            OutlinedButton(
                                onPressed: details.onStepContinue,
                                child: const Text("NEXT")),
                            OutlinedButton(
                                onPressed: details.onStepCancel,
                                child: const Text("CANCEL")),
                          ],
                        );
                },
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  if (_index < stepperLength) {
                    final validator = formKeys[_index].currentState?.validate();
                    if (validator!) {
                      setState(() {
                        _index += 1;
                      });
                    } else {
                      Vibration.vibrate();
                    }
                  }
                },
                onStepTapped: (int index) {
                  setState(() {
                    _index = index;
                  });
                },
                steps: steps)));
  }

  bool getIsActive(int currentIndex, int index) {
    if (currentIndex == index) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    Provider.of<PluginState>(context, listen: false).setRequestState(false);
    super.dispose();
  }
}

class StepForm extends StatelessWidget {
  final formKey;
  List<dynamic>? jsonDisplay, formFields;
  List<FormItem> formItems;
  ModuleItem moduleItem;
  FormItem formItem;
  int stepperLength, currentIndex;

  StepForm(
      {required this.formKey,
      required this.formItems,
      required this.formItem,
      required this.moduleItem,
      required this.stepperLength,
      required this.currentIndex,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<FormItem> stepForms = formItems
        .where(
          (item) => item.linkedToControl == formItem.controlId,
        )
        .toList();

    return WillPopScope(
      onWillPop: () async {
        Provider.of<PluginState>(context, listen: false).setRequestState(false);
        return true;
      },
      child: DynamicForm(
        formkey: formKey,
        moduleItem: moduleItem,
        forms: formItems,
        jsonDisplay: jsonDisplay,
        formFields: formFields,
      ),
    );
  }
}
