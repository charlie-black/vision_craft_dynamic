// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
part of craft_dynamic;

var classname = "dynamic_components";

class DynamicInput {
  static Map<String?, dynamic> formInputValues = {};
  static Map<String?, dynamic> encryptedField = {};

  clearDynamicInput() {
    formInputValues.clear();
    encryptedField.clear();
  }
}

class BaseFormComponent extends StatelessWidget {
  const BaseFormComponent(
      {super.key,
      required this.child,
      required this.formItem,
      required this.moduleItem,
      required this.formItems,
      required this.formKey});

  final Widget child;
  final FormItem formItem;
  final ModuleItem moduleItem;
  final List<FormItem> formItems;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseFormInheritedComponent(
          widget: child,
          formItem: formItem,
          moduleItem: moduleItem,
          formItems: formItems,
          formKey: formKey,
        ),
        formItem.controlType == ViewType.HIDDEN.name ||
                formItem.controlType == ViewType.CONTAINER.name ||
                formItem.controlType == ViewType.RBUTTON.name ||
                formItem.controlType == ViewType.TAB.name ||
                formItem.controlType == ViewType.LIST.name ||
                formItem.controlType == ViewType.TITLE.name ||
                formItem.controlType == ViewType.SELECTEDTEXT.name ||
                formItem.controlType == ViewType.FORM.name ||
                formItem.controlType == ViewType.IMAGE.name ||
                formItem.controlType == ViewType.TEXTVIEW.name ||
                formItem.controlType == ViewType.HORIZONTALTEXT.name
            ? const SizedBox()
            : const SizedBox(
                height: 24,
              )
      ],
    );
  }
}

class BaseFormInheritedComponent extends InheritedWidget {
  final FormItem formItem;
  final ModuleItem moduleItem;
  final List<FormItem> formItems;
  final GlobalKey<FormState> formKey;
  final Widget widget;
  List<dynamic>? jsonText;
  final String? eventName;

  BaseFormInheritedComponent(
      {super.key,
      required this.widget,
      required this.formItem,
      required this.moduleItem,
      required this.formItems,
      required this.formKey,
      this.eventName,
      this.jsonText})
      : super(child: widget);

  static BaseFormInheritedComponent? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BaseFormInheritedComponent>();
  }

  @override
  bool updateShouldNotify(covariant BaseFormInheritedComponent oldWidget) {
    return oldWidget.formItem != formItem;
  }
}

class DynamicTextFormField extends StatefulWidget implements IFormWidget {
  Function? func;
  bool isEnabled;
  String? customText;
  TextEditingController? controller;
  List<dynamic>? formFields;

  DynamicTextFormField(
      {super.key,
      this.isEnabled = true,
      this.func,
      this.customText,
      this.controller,
      this.formFields});

  @override
  Widget render() {
    return DynamicTextFormField(
      formFields: formFields,
    );
  }

  @override
  State<DynamicTextFormField> createState() => _DynamicTextFormFieldState();
}

class _DynamicTextFormFieldState extends State<DynamicTextFormField> {
  var controller = TextEditingController();
  var inputType = TextInputType.text;
  bool isObscured = false;
  IconButton? suffixIcon;
  FormItem? formItem;
  ModuleItem? moduleItem;
  String? initialValue;
  String? eventName;
  String linkedToControlText = "";

  @override
  void initState() {
    super.initState();
    if (widget.customText != null) {
      controller.text = widget.customText!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
    eventName = BaseFormInheritedComponent.of(context)?.eventName;
  }

  updateControllerText(String value) {
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = formItem?.isEnabled ?? true;
    AppLogger.appLogD(
        tag: "textformfield", message: "controlid-->${formItem?.controlId}");

    return Consumer<PluginState>(builder: (context, state, child) {
      controller.clear();
      isObscured = formItem?.controlFormat == ControlFormat.PinNumber.name ||
              formItem?.controlFormat == ControlFormat.PIN.name
          ? true
          : false;

      var textFieldParams = WidgetUtil.checkControlFormat(
          formItem!.controlFormat!,
          context: context,
          isObscure: isObscured,
          refreshParent: refreshParent,
          isTodayInitialDate: moduleItem?.moduleId == "STANDINGORDERADD");
      inputType = formItem?.controlFormat == ControlFormat.PinNumber.name ||
              formItem?.controlFormat == ControlFormat.PIN.name
          ? TextInputType.number
          : textFieldParams['inputType'];
      var formFieldValue = widget.formFields?.firstWhereOrNull((formField) =>
              formField[FormFieldProp.ControlID.name].toLowerCase() ==
              formItem?.controlId?.toLowerCase()) ??
          "";

      if (formFieldValue.isNotEmpty) {
        controller.text = controller.text.isEmpty
            ? formFieldValue[FormFieldProp.ControlValue.name]
            : controller.text;
      }

      if (formItem?.linkedToRowID != null) {
        AppLogger.appLogD(
            tag: "all dynamic dropdown data ${formItem?.linkedToRowID}",
            message: state.dynamicDropDownData);
        linkedToControlText = state.dynamicDropDownData[formItem?.linkedToRowID]
                ?[formItem?.controlId] ??
            "";
      }

      if (linkedToControlText.isNotEmpty) {
        setInitialText(linkedToControlText);
      }

      var properties = TextFormFieldProperties(
          isEnabled:
              (formFieldValue.isNotEmpty || linkedToControlText.isNotEmpty) &&
                      isEnabled == true
                  ? false
                  : true,
          isObscured: isObscured ? state.obscureText : false,
          controller: controller,
          textInputType: inputType,
          maxLength: formItem?.maxLength,
          maxLines: formItem?.maxLines,
          inputDecoration: InputDecoration(
              // border: const OutlineInputBorder(),
              labelText: formItem?.controlText,
              suffixIcon: textFieldParams['suffixIcon'],
              contentPadding: formItem?.verticalPadding != null
                  ? EdgeInsets.symmetric(
                      vertical: formItem?.verticalPadding ?? 18, horizontal: 14)
                  : null),
          isAmount: formItem?.controlFormat == ControlFormat.Amount.name);

      return WidgetFactory.buildTextField(
          context,
          properties,
          formItem?.controlFormat?.toUpperCase() == ControlFormat.EMAIL.name
              ? validateEmail
              : validator);
    });
  }

  String? validator(String? value) {
    var formattedValue = value.toString().replaceAll(',', '');
    if (formItem!.isMandatory! && value!.isEmpty) {
      return 'Input required*';
    }

    if (formItem?.controlId == "STARTDATE" ||
        formItem?.controlId == "ENDDATE") {
      startenddate.addAll({formItem?.controlId: value});
    }

    if (inputType == TextInputType.number &&
        formItem?.controlFormat == ControlFormat.Amount.name) {
      if (formItem?.maxValue != null) {
        if (formItem!.maxValue!.isNotEmpty) {
          if (double.parse(formattedValue) >
              double.parse(formItem!.maxValue!)) {
            return "Maximum accepted is ${formItem!.maxValue}";
          }
          if (formItem?.minValue != null) {
            if (double.parse(formattedValue) <
                double.parse(formItem!.minValue!)) {
              return "Minimum required is ${formItem?.minValue}";
            }
          }
        }
      }
    }
    if (isObscured) {
      Provider.of<PluginState>(context, listen: false).addEncryptedFields({
        "${formItem?.serviceParamId}":
            CryptLib.encryptField(formattedValue.replaceAll(" ", ""))
      });
    } else {
      Provider.of<PluginState>(context, listen: false)
          .addFormInput({"${formItem?.serviceParamId}": "$value"});
    }
    return null;
  }

  void setInitialText(String? initialText) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.text = initialText ?? "";
    });
  }

  void refreshParent(bool status, {newText}) {
    setState(() {
      status;
      controller.text = DateFormat('yyyy-MM-dd').format(newText);
    });
  }

  String? validateEmail(String? value) {
    if (formItem!.isMandatory! && value!.isEmpty) {
      return 'Input required*';
    }

    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    Provider.of<PluginState>(context, listen: false)
        .addFormInput({"${formItem?.serviceParamId}": value});

    return null;
  }
}

class HiddenWidget implements IFormWidget {
  final _sharedPref = CommonSharedPref();
  List<dynamic>? formFields;
  FormItem? formItem;
  List<Widget> children = [];

  HiddenWidget({this.formFields, this.formItem});

  @override
  Widget render() {
    AppLogger.appLogD(
        tag: "hidden widget",
        message:
            "values--> control id:${formItem?.controlId} ${formItem?.serviceParamId} ${formItem?.controlValue}");

    return Builder(builder: (context) {
      String controlValue = "";

      if (formItem?.controlFormat == ControlFormat.OWNNUMBER.name) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _sharedPref.getCustomerMobile().then((value) {
            if (value != null && value.toString().isNotEmpty) {
              Provider.of<PluginState>(context, listen: false)
                  .addFormInput({"${formItem?.serviceParamId}": value});
            }
          });
        });
      } else {
        if (formFields != null) {
          formFields?.forEach((formField) {
            if (formField[FormFieldProp.ControlID.name] ==
                formItem?.controlId) {
              controlValue = formField[FormFieldProp.ControlValue.name] ?? "";
              if (controlValue.isNotEmpty) {
                children.add(SizedBox(
                  height: 0,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none),
                    validator: (value) {
                      AppLogger.appLogD(
                          tag: "hidden widget",
                          message: formItem?.serviceParamId);
                      Provider.of<PluginState>(context, listen: false)
                          .addFormInput(
                              {formItem?.serviceParamId: controlValue});
                    },
                  ),
                ));
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AppLogger.appLogD(
                      tag: "hidden component",
                      message: "${formItem?.serviceParamId} $controlValue");
                  Provider.of<PluginState>(context, listen: false).addFormInput(
                      {"${formItem?.serviceParamId}": controlValue});
                });
              }
            }
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppLogger.appLogD(
                tag: "hidden widget",
                message: "adding values to hidden widget");
          });
          children.add(SizedBox(
            height: 0,
            child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none),
              validator: (value) {
                AppLogger.appLogD(
                    tag: "hidden widget", message: formItem?.serviceParamId);
                Provider.of<PluginState>(context, listen: false).addFormInput(
                    {formItem?.serviceParamId: formItem?.controlValue});
              },
            ),
          ));
        }
      }

      return Column(
        children: children,
      );
    });
  }
}

class DynamicButton extends StatefulWidget implements IFormWidget {
  const DynamicButton({super.key});

  @override
  Widget render() {
    return const DynamicButton();
  }

  @override
  State<DynamicButton> createState() => _DynamicButtonState();
}

class _DynamicButtonState extends State<DynamicButton> {
  final _dynamicRequest = DynamicFormRequest();
  final _moduleRepository = ModuleRepository();
  FormItem? formItem;
  ModuleItem? moduleItem;
  var formKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
    formKey = BaseFormInheritedComponent.of(context)?.formKey;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 34),
          child: Consumer<PluginState>(builder: (context, state, child) {
            return state.loadingNetworkData
                ? LoadUtil()
                : WidgetFactory.buildButton(context, onClick,
                    formItem?.controlText?.capitalizeFirstLetter() ?? "Submit");
          }));
    });
  }

  onClick() {
    if (formItem?.controlId == "CLOSE") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return;
    }

    if (formItem?.controlFormat == ControlFormat.OPENFORM.name) {
      getModule(formItem?.actionId ?? "").then((module) {
        CommonUtils.navigateToRoute(
            context: context,
            widget: DynamicWidget(
              moduleItem: module,
            ));
      });
      return;
    }

    if (formKey?.currentState?.validate()!) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (formItem?.controlFormat == ControlFormat.NEXT.name) {
        Provider.of<PluginState>(context, listen: false).setDeleteForm(false);
        CommonUtils.navigateToRoute(
            context: context,
            widget: DynamicWidget(
              moduleItem: moduleItem,
              nextFormSequence: 2,
            ));
        return;
      } else {
        if (startenddate.isNotEmpty) {
          String? validate = validateStartAndEndDate();
          if (validate != null) {
            AlertUtil.showAlertDialog(context, validate,
                isInfoAlert: true, title: "Info");
            return;
          }
        }

        Provider.of<PluginState>(context, listen: false).setRequestState(true);
        _dynamicRequest
            .dynamicRequest(moduleItem,
                formItem: formItem,
                dataObj: Provider.of<PluginState>(context, listen: false)
                    .formInputValues,
                encryptedField: Provider.of<PluginState>(context, listen: false)
                    .encryptedFields,
                context: context,
                tappedButton: true)
            .then((value) {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          if (value?.status != StatusCode.unknown.statusCode) {
            AppLogger.appLogD(
                tag: "DYNAMIC BUTTON POST CALL",
                message: "Current status is --->${value?.message}");
            DynamicPostCall.processDynamicResponse(
                value!.dynamicData!, context, formItem!.controlId!,
                moduleItem: moduleItem);
            Provider.of<PluginState>(context, listen: false)
                .clearDynamicInput();
          }
        });
      }
    } else {
      CommonUtils.vibrate();
    }
  }

  String? validateStartAndEndDate() {
    try {
      var start = startenddate["STARTDATE"];
      var end = startenddate["ENDDATE"];

      if (start != null && end != null) {
        DateTime startDate = DateTime.parse(start);
        DateTime endDate = DateTime.parse(end);

        int differenceInDays = endDate.difference(startDate).inDays;

        if (endDate.isBefore(startDate)) {
          return "Invalid Dates Seleted!\nEnd date cannot be before start date";
        }
        if (selectedDateFrequency.value == 2 && differenceInDays < 7) {
          return "Frequency selected as \nWeekly but invalid date range selected";
        }
        if (selectedDateFrequency.value == 3 && differenceInDays < 26) {
          return "Frequency selected as \nMonthly but invalid date range selected";
        }
      }
    } catch (e) {
      AppLogger.appLogD(tag: "dynamic_components", message: e);
    }

    return null;
  }

  getModule(String moduleID) => _moduleRepository.getModuleById(moduleID);
}

class ImageDynamicDropDown extends StatefulWidget implements IFormWidget {
  const ImageDynamicDropDown({super.key});

  @override
  State<ImageDynamicDropDown> createState() => _ImageDynamicDropDownState();

  @override
  Widget render() => const ImageDynamicDropDown();
}

class _ImageDynamicDropDownState extends State<ImageDynamicDropDown> {
  final _apiService = APIService();
  Map<String, dynamic> extraFieldMap = {};
  List<dynamic> dropdownItems = [];

  FormItem? formItem;
  ModuleItem? moduleItem;
  String? _currentValue;

  Future<DynamicResponse?> getDropDownData(
    String actionID,
    ModuleItem moduleItem, {
    formID = "DBCALL",
    route = "other",
    merchantID,
  }) =>
      _apiService.getDynamicDropDownValues(
        actionID,
        moduleItem,
        formID ?? "DBCALL",
        route ?? "other",
        merchantID,
      );

  @override
  initState() {
    AppLogger.appLogD(
        tag: "images dropdown", message: "getting images for dropdown");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

    return FutureBuilder<DynamicResponse?>(
        future: getDropDownData(
          formItem?.actionId ?? "",
          moduleItem!,
          formID: formItem?.formID,
          route: formItem?.route,
          merchantID: formItem?.merchantID,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<DynamicResponse?> snapshot) {
          Widget child = DropdownButtonFormField2(
            value: _currentValue,
            decoration: InputDecoration(
                prefixIcon: ThreeLoadUtil(
              size: 24,
            )),
            hint: Text(
              formItem?.controlText ?? "",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExpanded: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            items: const [],
          );
          if (snapshot.hasData) {
            dropdownItems = snapshot.data?.dynamicList ?? [];
            if (dropdownItems.isEmpty) {
              child = DropdownButtonFormField2(
                value: _currentValue,
                hint: Text(
                  snapshot.data?.message ?? formItem?.controlText ?? "",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                items: const [],
              );
            } else {
              AppLogger.appLogD(
                  tag: "dropdown items", message: dropdownItems.first);
              _currentValue = formItem?.hasInitialValue ?? true
                  ? dropdownItems.first[formItem?.controlId]["Value"]
                  : null;
              var dropdownPicks = dropdownItems.asMap().entries.map((item) {
                Map<String, dynamic> jsonvalue =
                    item.value[formItem?.controlId] ?? {};
                var image = jsonvalue["ImageUrl"];
                var label = jsonvalue["Description"];
                var value = jsonvalue["Value"];

                return DropdownMenuItem(
                    value: value ?? formItem?.controlText,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CachedNetworkImage(
                              imageUrl: image ?? formItem?.controlText,
                              placeholder: (context, url) => PulseLoadUtil(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Text(
                              label ?? formItem?.controlText,
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        )));
              }).toList();
              dropdownPicks.toSet().toList();
              if (dropdownPicks.isNotEmpty &&
                  (formItem?.hasInitialValue ?? true)) {
                addInitialValueToLinkedField(context, dropdownItems.first);
              }
              child = DropdownButtonFormField(
                value: _currentValue,
                items: dropdownPicks,
                isExpanded: true,
                decoration: InputDecoration(labelText: formItem?.controlText),
                onChanged: (value) {},
                validator: (value) {
                  String? input = value.toString();
                  if ((formItem?.isMandatory ?? false) && input == "null") {
                    return 'Input required*';
                  }
                  debugPrint("value in dropdown is $value");
                  Provider.of<PluginState>(context, listen: false)
                      .addFormInput({"${formItem?.serviceParamId}": value});
                  return null;
                },
              );
            }
          }

          return child;
        });
  }

  getValueFromList(value) => dropdownItems
      .firstWhereOrNull((element) => element[formItem?.controlId] == value);

  void addInitialValueToLinkedField(BuildContext context, var initialValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Provider.of<PluginState>(context, listen: false)
            .dynamicDropDownData
            .isEmpty) {
          Provider.of<PluginState>(context, listen: false)
              .addDynamicDropDownData(
                  {formItem?.controlId.toString() ?? "": initialValue});
        }
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    });
  }
}

class DynamicDropDown extends StatefulWidget implements IFormWidget {
  List<dynamic>? formFields;
  DynamicDropDown({super.key, this.formFields});

  @override
  State<DynamicDropDown> createState() => _DynamicDropDownState();

  @override
  Widget render() => DynamicDropDown(
        formFields: formFields,
      );
}

class _DynamicDropDownState extends State<DynamicDropDown> {
  final _apiService = APIService();
  FormItem? formItem;
  ModuleItem? moduleItem;
  String? _currentValue;
  Map<String, dynamic> extraFieldMap = {};
  List<dynamic> dropdownItems = [];

  Future<DynamicResponse?> getDropDownData(
      String actionID, ModuleItem moduleItem,
      {formID = "DBCALL", route = "other", merchantID}) async {
    Map<String, dynamic> innermap = {};
    AppLogger.appLogD(tag: "form field Data innit", message: widget.formFields);

    if (widget.formFields != null) {
      for (var field in widget.formFields ?? []) {
        innermap.addAll(field);
      }
    }

    return await _apiService.getDynamicDropDownValues(
      actionID,
      moduleItem,
      formID,
      route,
      merchantID,
      extra: innermap,
    );
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PluginState>(context, listen: false).clearDynamicDropDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

    return FutureBuilder<DynamicResponse?>(
        future: getDropDownData(formItem?.actionId ?? "", moduleItem!,
            formID: formItem?.formID,
            route: formItem?.route,
            merchantID: formItem?.merchantID),
        builder:
            (BuildContext context, AsyncSnapshot<DynamicResponse?> snapshot) {
          Widget child = DropdownButtonFormField2(
            value: _currentValue,
            decoration: InputDecoration(
                prefixIcon: ThreeLoadUtil(
              size: 24,
            )),
            hint: Text(
              formItem?.controlText ?? "",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExpanded: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            items: const [],
          );
          if (snapshot.hasData) {
            dropdownItems = snapshot.data?.dynamicList ?? [];
            List<dynamic> filteredDropdownItems = [];

            child = Consumer2<PluginState, DropDownState>(
                builder: (context, state, dropdownState, child) {
              Widget secondChild = const SizedBox();

              if (formItem?.linkedToRowID != null &&
                  formItem?.linkedToRowID != "") {
                var linkedMap = state
                    .dynamicDropDownData[formItem?.linkedToRowID]?.values
                    .toList();
                var currentSelected = linkedMap?[0];

                // dropdownItems.removeWhere(
                //     (map) => map[formItem?.linkedToRowID] != currentSelected);

                filteredDropdownItems = dropdownItems
                    .where((map) =>
                        map[formItem?.linkedToRowID] == currentSelected)
                    .toList();
                filteredDropdownItems = removeDuplicateDropdownItems(
                    filteredDropdownItems, formItem?.controlId ?? "");

                AppLogger.appLogD(
                    tag:
                        "linked property on dynamic dropdown ${formItem?.controlId}",
                    message: currentSelected);
              }

              AppLogger.appLogD(
                  tag: "unfiltered dropdown data--> @${formItem?.controlId}",
                  message: dropdownItems);

              AppLogger.appLogD(
                  tag: "filtered dropdown data--> @${formItem?.controlId}",
                  message: filteredDropdownItems);

              if (dropdownItems.isEmpty) {
                secondChild = DropdownButtonFormField2(
                  value: _currentValue,
                  hint: Text(
                    snapshot.data?.message ?? formItem?.controlText ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  isExpanded: true,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  items: const [],
                );
              } else {
                addLoanAccounts(dropdownItems);

                var dropdownPicks = formItem?.linkedToRowID != null &&
                        formItem?.linkedToRowID != ""
                    ? filteredDropdownItems.asMap().entries.map((item) {
                        return DropdownMenuItem(
                          value: item.value[formItem?.controlId] ??
                              formItem?.controlText,
                          child: Text(
                            item.value[formItem?.controlId] ??
                                formItem?.controlText,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      }).toList()
                    : dropdownItems.asMap().entries.map((item) {
                        return DropdownMenuItem(
                          value: item.value[formItem?.controlId] ??
                              formItem?.controlText,
                          child: Text(
                            item.value[formItem?.controlId] ??
                                formItem?.controlText,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      }).toList();
                dropdownPicks.toSet().toList();

                if (dropdownPicks.isNotEmpty &&
                    (formItem?.hasInitialValue ?? true)) {
                  addInitialValueToLinkedField(
                      context, dropdownPicks.first.value);
                }

                // _currentValue = dropdownPicks.isNotEmpty
                //     ? dropdownPicks.first.value.toString()
                //     : null;

                secondChild = DropdownButtonFormField(
                  value:
                      dropdownPicks.any((item) => item.value == _currentValue)
                          ? _currentValue
                          : null,
                  decoration: InputDecoration(labelText: formItem?.controlText),
                  isExpanded: true,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  onChanged: (value) {
                    AppLogger.appLogD(
                        tag: 'Selected the dropdown innit', message: value);
                    setState(() {
                      _currentValue = value.toString();
                    });

                    if (formItem?.linkedToRowID == null ||
                        formItem?.linkedToRowID == "") {
                      state.clearAllFields();
                      dropdownState.clearAllSelections();
                    }

                    state.addDynamicDropDownData(
                        {formItem?.controlId ?? "": getValueFromList(value)});
                  },
                  validator: (value) {
                    String? input = value.toString();
                    if ((formItem?.isMandatory ?? false) && input == "null") {
                      return 'Input required*';
                    }
                    Provider.of<PluginState>(context, listen: false)
                        .addFormInput({
                      "${formItem?.serviceParamId}":
                          getValueFromList(value)[formItem?.controlId ?? ""]
                    });
                    return null;
                  },
                  items: dropdownPicks,
                );
              }
              return secondChild;
            });
          }
          return child;
        });
  }

  void clearState() {}

  List<dynamic> removeDuplicateDropdownItems(
      List<dynamic> list, String controlID) {
    Set<dynamic> uniqueKeys =
        list.map((donation) => donation[controlID]).toSet();
    return list
        .where((donation) => uniqueKeys.remove(donation[controlID]))
        .toList();
  }

  addLoanAccounts(List<dynamic> accounts) {
    if (formItem?.controlId == ControlID.LOANACCOUNT.name) {
      try {
        if (accounts.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            for (var account in accounts) {
              Provider.of<DropDownState>(context, listen: false)
                  .addCurrentRepaymentAccounts({
                formItem?.controlId ?? "": account[formItem?.controlId]
              });
            }
          });
        }
      } catch (e) {
        AppLogger.appLogD(tag: "dynamic_components", message: e);
      }
    }
  }

  getValueFromList(value) => dropdownItems
      .firstWhereOrNull((element) => element[formItem?.controlId] == value);

  void addInitialValueToLinkedField(BuildContext context, var initialValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Provider.of<PluginState>(context, listen: false)
            .dynamicDropDownData
            .isEmpty) {
          Provider.of<PluginState>(context, listen: false)
              .addDynamicDropDownData(
                  {formItem?.controlId ?? "": initialValue});
        }
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    });
  }
}

class DropDown extends StatefulWidget implements IFormWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();

  @override
  Widget render() => const DropDown();
}

class _DropDownState extends State<DropDown> {
  final _userCodeRepository = UserCodeRepository();
  List<UserCode> userCodes = [];
  Map<String, dynamic> extraFieldMap = {};
  Map<String, dynamic> relationIDMap = {};
  Map<String, dynamic> dropdownItems = {};

  FormItem? formItem;
  ModuleItem? moduleItem;
  String? _currentValue;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PluginState>(context, listen: false).clearDynamicDropDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      formItem = BaseFormInheritedComponent.of(context)?.formItem;
      moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      {
        return FutureBuilder<Map<String, dynamic>?>(
            future: getDropDownValues(formItem!, moduleItem!, null),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>?> snapshot) {
              AppLogger.appLogD(
                  tag: "dropdown", message: "getting dropdown data...");
              Widget child = DropdownButtonFormField2(
                value: _currentValue,
                hint: Text(
                  formItem!.controlText!,
                  style: const TextStyle(color: Colors.black),
                ),
                isExpanded: true,
                items: const [],
              );
              AppLogger.appLogD(
                  tag: "dropdown",
                  message: "snapshot has data...${snapshot.data}");
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                AppLogger.appLogD(
                    tag: "dropdown", message: "snapshot has data...");
                var data = snapshot.data ?? {};
                dropdownItems = data;
                AppLogger.appLogD(
                    tag: "dropdown data::controlid${formItem?.controlId}",
                    message: dropdownItems);

                child =
                    Consumer<DropDownState>(builder: (context, state, child) {
                  dropdownItems = removeAllLoanAccounts(
                      dropdownItems, state.currentRepaymentAccounts);
                  Map<String, dynamic> temprelmap = {};
                  Map<String, dynamic> tempdropdownitems = {};
                  Map<String, dynamic> dropdownmenu = {};

                  if (isBillerName(formItem?.controlId ?? "")) {
                    AppLogger.appLogD(
                        tag: "dropdown data::controlid${formItem?.controlId}",
                        message: dropdownItems);
                    relationIDMap.forEach((key, value) {
                      if (value == state.currentRelationID) {
                        temprelmap.addAll({key: value});
                      }
                    });
                    AppLogger.appLogD(
                        tag:
                            "Dropdown RelationID Map after ${formItem?.controlId}",
                        message: temprelmap);
                    dropdownItems.forEach((key, value) {
                      if (temprelmap.containsKey(key)) {
                        debugPrint("adding with key --$key");
                        tempdropdownitems.addAll({key: value});
                      }
                    });
                    if (tempdropdownitems.entries.isNotEmpty) {
                      _currentValue = tempdropdownitems.entries.first.key;
                    }
                  }

                  dropdownmenu = isBillerName(formItem?.controlId ?? "")
                      ? tempdropdownitems.isNotEmpty
                          ? tempdropdownitems
                          : {}
                      : dropdownItems;

                  var dropdownPicks = dropdownmenu.entries.map((item) {
                    return DropdownMenuItem(
                      value: item.key,
                      child: Text(
                        item.value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList();
                  dropdownPicks.toSet().toList();

                  if (dropdownPicks.isNotEmpty &&
                      (formItem?.hasInitialValue ?? true)) {
                    addInitialValueToLinkedField(context,
                        getFirstSubcodeID(dropdownItems.entries.first));
                  }

                  if (!isToAccountField(formItem?.controlId ?? "") &&
                      !isBillerName(formItem?.controlId ?? "") &&
                      (_currentValue?.isEmpty ?? true)) {
                    _currentValue = formItem?.hasInitialValue ?? true
                        ? dropdownItems.isNotEmpty
                            ? dropdownItems.entries.first.key
                            : null
                        : null;
                  }

                  if (isToAccountField(formItem?.controlId ?? "")) {
                    var dropdowns = dropdownPicks.firstWhereOrNull((item) =>
                        item.value ==
                        state.currentSelections?[ControlID.BANKACCOUNTID.name]);
                    dropdownPicks.remove(dropdowns);

                    if (_currentValue ==
                        state
                            .currentSelections?[ControlID.BANKACCOUNTID.name]) {
                      _currentValue = formItem?.hasInitialValue ?? true
                          ? dropdownPicks.isNotEmpty
                              ? "${dropdownPicks[0].value}"
                              : null
                          : null;
                    }
                  }

                  return DropdownButtonFormField(
                    value: _currentValue,
                    decoration:
                        InputDecoration(labelText: formItem?.controlText),
                    isExpanded: true,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    onChanged: ((value) async {
                      AppLogger.appLogD(
                          tag: 'dropdown component event elected',
                          message: value);
                      setState(() {
                        _currentValue = value.toString();
                      });
                      Provider.of<PluginState>(context, listen: false)
                          .addDynamicDropDownData({
                        formItem?.controlId ?? "": {
                          formItem?.controlId ?? "": getValueFromList(value)
                        }
                      });
                      state.addCurrentDropDownValue(
                          {formItem?.controlId: value});
                      if (isBillerType(formItem?.controlId ?? "")) {
                        var relationid = await _userCodeRepository
                            .getRelationIDBySubcodeID(value.toString());
                        // var relationid = getRelationIDValue(value);
                        AppLogger.appLogD(
                            tag: "dropdown relation id:", message: relationid);
                        state.addCurrentRelationID(relationid);
                      }
                      if (isFromAccountField(formItem?.controlId ?? "")) {
                        state.setCurrentSelections(
                            {formItem?.controlId: _currentValue});
                      }
                    }),
                    validator: (value) {
                      AppLogger.appLogD(
                          tag: 'dropdown component validator value-->',
                          message: value);
                      String? input = value.toString();
                      if ((formItem?.isMandatory ?? false) && input == "null") {
                        return 'Input required*';
                      }

                      dropdownSelection.addAll({
                        formItem?.serviceParamId:
                            getValueFromKey(value.toString())
                      });

                      addDateFrequencyToState(value.toString());
                      Provider.of<PluginState>(context, listen: false)
                          .addFormInput({"${formItem?.serviceParamId}": value});
                      return null;
                    },
                    items: dropdownPicks,
                  );
                });
              }
              return child;
            });
      }
    });
  }

  addDateFrequencyToState(String frequency) {
    if (formItem?.controlId == ControlID.FREQUENCY.name) {
      try {
        selectedDateFrequency.value = int.parse(frequency);
      } catch (e) {
        AppLogger.appLogD(tag: "dynamic_components", message: e);
      }
    }
  }

  String? getValueFromKey(String? value) =>
      dropdownItems.keys.firstWhereIndexedOrNull(
          (index, element) => dropdownItems[element] == value);

  String getFirstSubcodeID(MapEntry entry) => entry.key;

  getValueFromList(value) => extraFieldMap[value];

  getRelationIDValue(value) => relationIDMap[value];

  Future<BankAccount?> getAccountBranch(String accountID) async {
    final bankRepo = BankAccountRepository();
    return bankRepo.getBankAccount(accountID);
  }

  bool isToAccountField(String controlID) =>
      controlID.toLowerCase() == ControlID.TOACCOUNTID.name.toLowerCase()
          ? true
          : false;

  bool isBillerType(String controlID) =>
      controlID.toLowerCase() == ControlID.BILLERTYPE.name.toLowerCase()
          ? true
          : false;

  bool isBillerName(String controlID) =>
      controlID.toLowerCase() == ControlID.BILLERNAME.name.toLowerCase()
          ? true
          : false;

  bool isFromAccountField(String controlID) =>
      controlID.toLowerCase() == ControlID.BANKACCOUNTID.name.toLowerCase()
          ? true
          : false;

  Map<String, dynamic> removeAllLoanAccounts(Map<String, dynamic> dropdownItems,
      Map<String?, dynamic> allLoanAccounts) {
    Map<String, dynamic> items = dropdownItems;
    if (isFromAccountField(formItem?.controlId ?? "")) {
      AppLogger.appLogD(
          tag: "dynamic_components",
          message: "removing all loan accounts from From Account Dropdown");

      try {
        if (items.isNotEmpty) {
          var loanAccounts = allLoanAccounts.entries.toList();

          for (var account in loanAccounts) {
            items.removeWhere((key, value) => key == account.value);
          }
        }
      } catch (e) {
        AppLogger.appLogD(tag: "dynamic_components", message: e);
      }
    }
    return items;
  }

  void addInitialValueToLinkedField(BuildContext context, var initialValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Provider.of<PluginState>(context, listen: false)
                    .dynamicDropDownData[formItem?.rowID?.toString()] ==
                {} ||
            Provider.of<DropDownState>(context, listen: false)
                    .currentDropDownValue[formItem?.controlId?.toString()] ==
                null) {
          Map<String, dynamic> map = {};

          map.addAll(
              {formItem?.controlId ?? "": getValueFromList(initialValue)});
          if (isFromAccountField(formItem?.controlId ?? "")) {
            Provider.of<DropDownState>(context, listen: false)
                .setCurrentSelections({formItem?.controlId: _currentValue});
          }
          Provider.of<PluginState>(context, listen: false)
              .addDynamicDropDownData({formItem?.controlId ?? "": map});
          Provider.of<DropDownState>(context, listen: false)
              .addCurrentDropDownValue({formItem?.controlId: initialValue});
          if (isBillerType(formItem?.controlId ?? "")) {
            Provider.of<DropDownState>(context, listen: false)
                .addCurrentRelationID(getRelationIDValue(initialValue));
          }
        }
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    });
  }

  Future<Map<String, dynamic>?>? getDropDownValues(FormItem formItem,
      ModuleItem moduleItem, String? currentRelationID) async {
    if (formItem.controlFormat != ControlFormat.SELECTBANKACCOUNT.name ||
        formItem.controlFormat != ControlFormat.SELECTBENEFICIARY.name) {
      try {
        userCodes =
            await _userCodeRepository.getUserCodesById(formItem.dataSourceId);
        extraFieldMap = userCodes.fold<Map<String, dynamic>>(
            {}, (acc, curr) => acc..[curr.subCodeId] = curr.extraField);
        relationIDMap = userCodes.fold<Map<String, dynamic>>(
            {}, (acc, curr) => acc..[curr.subCodeId] = curr.relationId);
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    }
    return await IDropDownAdapter(formItem, moduleItem, currentRelationID)
        .getDropDownItems();
  }
}

class DynamicLabelWidget implements IFormWidget {
  DynamicResponse? dynamicResponse;
  final _dynamicRequest = DynamicFormRequest();

  getDynamicLabel(
          BuildContext context, FormItem? formItem, ModuleItem moduleItem) =>
      _dynamicRequest.dynamicRequest(
        moduleItem,
        formItem: formItem,
        dataObj:
            Provider.of<PluginState>(context, listen: false).formInputValues,
        encryptedField:
            Provider.of<PluginState>(context, listen: false).encryptedFields,
        isList: true,
        context: context,
      );

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      AppLogger.appLogD(tag: "dynamic_components", message: "show label...");

      return formItem?.controlFormat == ControlFormat.LISTDATA.name
          ? FutureBuilder<DynamicResponse?>(
              future: getDynamicLabel(context, formItem, moduleItem!),
              builder: (BuildContext context,
                  AsyncSnapshot<DynamicResponse?> snapshot) {
                Widget child = Text(formItem?.controlText ?? "");
                if (snapshot.hasData) {
                  var dynamicResponse = snapshot.data;
                  DynamicPostCall.processDynamicResponse(
                      dynamicResponse!.dynamicData!,
                      context,
                      formItem?.controlId);

                  child = DynamicTextViewWidget(
                          jsonText: dynamicResponse.dynamicList)
                      .render();
                }
                return child;
              })
          : Text(
              formItem?.controlText ?? "",
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).primaryColor),
            );
    });
  }
}

class DynamicTextViewWidget implements IFormWidget {
  List<dynamic>? jsonText;
  List<LinkedHashMap> mapItems = [];

  DynamicTextViewWidget({
    this.jsonText,
  });

  @override
  Widget render() {
    jsonText?.forEach((item) {
      mapItems.add(item);
    });

    return mapItems.isNotEmpty
        ? Builder(builder: (BuildContext context) {
            return Column(children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mapItems.length,
                itemBuilder: (context, index) {
                  var mapItem = mapItems[index];
                  mapItem.removeWhere((key, value) =>
                      key == null || value == null || value == "");

                  return Material(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          side: BorderSide(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.4))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          children: mapItem
                              .map((key, value) => MapEntry(
                                  key,
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "$key",
                                          ),
                                          Flexible(
                                              child: Text(
                                            value.toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ))
                                        ],
                                      ))))
                              .values
                              .toList(),
                        ),
                      ));
                },
              ),
              const SizedBox(
                height: 18,
              )
            ]);
          })
        : const SizedBox();
  }
}

class DynamicQRScanner implements IFormWidget {
  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
      return Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              context.navigate(QRScanner(
                moduleItem: moduleItem!,
                formItem: formItem!,
                context: context,
              ));
            },
            child: Image.asset(
              "packages/craft_dynamic/assets/images/qr-code.png",
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "QR Code quick scan",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("Tap on the above image to start scanning"),
          const SizedBox(
            height: 44,
          ),
          Consumer<PluginState>(
            builder: (context, state, child) =>
                state.scanvalidationloading ? LoadUtil() : const SizedBox(),
          )
        ],
      );
    });
  }
}

class DynamicPhonePickerFormWidget extends StatefulWidget
    implements IFormWidget {
  const DynamicPhonePickerFormWidget({super.key});

  @override
  State<DynamicPhonePickerFormWidget> createState() =>
      _DynamicPhonePickerFormWidgetState();

  @override
  Widget render() {
    return const DynamicPhonePickerFormWidget();
  }
}

class _DynamicPhonePickerFormWidgetState
    extends State<DynamicPhonePickerFormWidget> {
  String? code;
  String pickedcontact = "";

  var controller = TextEditingController();
  PhoneNumber inputNumber = PhoneNumber(isoCode: APIService.countryIsoCode);

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;
    AppLogger.appLogD(
        tag: "phone input::leading digit", message: formItem?.leadingDigits);
    AppLogger.appLogD(
        tag: "phone input::max digits", message: formItem?.maxLength);

    return InternationalPhoneNumberInput(
      maxLength: formItem?.maxLength ?? 11,
      onInputChanged: (PhoneNumber number) {
        inputNumber = number;
      },
      selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          setSelectorButtonAsPrefixIcon: true,
          leadingPadding: 14),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      initialValue: inputNumber,
      textFieldController: controller,
      inputDecoration: InputDecoration(
          labelText: formItem?.controlText,
          suffixIcon: IconButton(
              onPressed: pickPhoneContact,
              icon:
                  Icon(Icons.contacts, color: Theme.of(context).primaryColor))),
      validator: (value) {
        var input = value?.replaceAll(" ", "");
        var leadingDigits = formItem?.leadingDigits ?? [];
        if (input?.length != 9) {
          return "Invalid mobile";
        } else if (leadingDigits.isNotEmpty &&
            (!leadingDigits.contains(value?[0]))) {
          return "Mobile must start with $leadingDigits";
        } else if (input == "") {
          return "Enter your mobile";
        } else {
          var number = pickedcontact.isNotEmpty
              ? "${APIService.countryCode}$pickedcontact"
              : inputNumber.phoneNumber?.replaceAll("+", "");
          Provider.of<PluginState>(context, listen: false)
              .addFormInput({"${formItem?.serviceParamId}": number});
        }

        return null;
      },
      countries: (formItem?.countries?.isNotEmpty ?? false)
          ? formItem?.countries
          : null,
    );
  }

  pickPhoneContact() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    var phone = formatPhone(contact.phoneNumber?.number ?? "")
        .replaceAll(RegExp(r'^0'), '')
        .replaceAll(" ", "");
    setState(() {
      pickedcontact = phone;
      controller.text = phone;
    });
  }

  String formatPhone(String phone) {
    return phone.replaceAll(RegExp(r'\+\d{1,3}'), '');
  }
}

class DynamicListWidget implements IFormWidget {
  final _dynamicRequest = DynamicFormRequest();
  DynamicResponse? dynamicResponse;
  FormItem? formItem, inheritedFormItem;
  ModuleItem? moduleItem, inheritedModuleItem;

  DynamicListWidget({this.moduleItem, this.formItem});

  getDynamicList(context, formItem, module) => _dynamicRequest.dynamicRequest(
        module,
        formItem: formItem,
        dataObj:
            Provider.of<PluginState>(context, listen: false).formInputValues,
        encryptedField:
            Provider.of<PluginState>(context, listen: false).encryptedFields,
        isList: true,
        context: context,
      );

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      inheritedFormItem = BaseFormInheritedComponent.of(context)?.formItem;
      inheritedModuleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      Provider.of<PluginState>(context, listen: false).addFormInput({
        RequestParam.HEADER.name:
            inheritedFormItem?.actionId ?? formItem?.actionId
      });

      return isEmptyList()
          ? const Center(
              child: Text("Nothing was found!"),
            )
          : FutureBuilder<DynamicResponse?>(
              future: getDynamicList(
                  context, formItem, inheritedModuleItem ?? moduleItem),
              builder: (BuildContext context,
                  AsyncSnapshot<DynamicResponse?> snapshot) {
                Widget child = Center(
                  child: CircularLoadUtil(),
                );
                if (snapshot.hasData) {
                  dynamicResponse = snapshot.data;
                  // DynamicPostCall.processDynamicResponse(
                  //     dynamicResponse?.dynamicData,
                  //     context,
                  //     formItem?.controlId);

                  child = ListWidget(
                    dynamicList: dynamicResponse?.dynamicList,
                    summary: dynamicResponse?.summary,
                    scrollable: false,
                    controlID: formItem?.controlId,
                    moduleItem: moduleItem,
                    serviceParamID: formItem?.serviceParamId,
                  );
                }
                return child;
              });
    });
  }

  bool isEmptyList() {
    if (formItem?.controlFormat != null &&
            formItem!.controlFormat!.isNotEmpty ||
        formItem?.actionId == null ||
        formItem?.actionId == "") {
      return false;
    }
    return true;
  }
}

class DynamicHyperLink implements IFormWidget {
  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      if (formItem?.controlValue != null) {
        CommonUtils.openUrl(Uri.parse(formItem!.controlValue!));
        Navigator.pop(context);
      }
      return const Visibility(visible: false, child: SizedBox());
    });
  }
}

class DynamicImageUpload extends StatefulWidget implements IFormWidget {
  const DynamicImageUpload({super.key});

  @override
  State<DynamicImageUpload> createState() => _DynamicImageUpload();

  @override
  Widget render() {
    return const DynamicImageUpload();
  }
}

class _DynamicImageUpload extends State<DynamicImageUpload> {
  String? imageFile;
  FormItem? formItem;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context,
            AsyncSnapshot<List<CameraDescription>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            child = InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    imageFile = photo?.path;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formItem!.controlText!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      width: double.infinity,
                      height: 177,
                      child: imageFile == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 34,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Tap to take picture")
                                ])
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(imageFile!),
                                fit: BoxFit.fitWidth,
                              )),
                    )
                  ],
                ));
          }
          return child;
        });
  }
}

class DynamicLinkedContainer extends StatefulWidget implements IFormWidget {
  const DynamicLinkedContainer({super.key});

  @override
  State<StatefulWidget> createState() => _DynamicLinkedContainerState();

  @override
  Widget render() {
    return const DynamicLinkedContainer();
  }
}

class _DynamicLinkedContainerState extends State<DynamicLinkedContainer> {
  String? controlFormat;
  List<String> buttons = [];
  List<Widget> widgets = [];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;
    var formItems = BaseFormInheritedComponent.of(context)?.formItems;

    if (formItem?.controlFormat == ControlFormat.HorizontalScroll.name) {
      for (var item in formItems!) {
        if (item.controlType == ViewType.SELECTEDTEXT.name) {
          buttons.add(item.controlText!);
        }
        if (item.controlType == ViewType.TEXT.name) {
          widgets.add(const SizedBox(
            height: 15,
          ));
          widgets.add(Consumer<GroupButtonModel>(
              builder: (context, selectedItem, child) {
            _controller.text = selectedItem.selectedItem;
            return WidgetFactory.buildTextField(
                context,
                TextFormFieldProperties(
                    controller: _controller,
                    textInputType: TextInputType.name,
                    inputDecoration:
                        InputDecoration(hintText: formItem?.controlText)),
                (string) {
              Provider.of<PluginState>(context, listen: false).addFormInput(
                  {"${formItem?.serviceParamId}": _controller.text});

              return null;
            });
          }));
          widgets.add(const SizedBox(
            height: 8,
          ));
        }
      }
    }
    if (buttons.isNotEmpty) {
      widgets.add(GroupButtonWidget(
        buttons: buttons,
      ));
    }
    widgets = widgets.reversed.toList();
    return ChangeNotifierProvider(
        create: (context) => GroupButtonModel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ));
  }
}

class DynamicCheckBox extends StatefulWidget implements IFormWidget {
  const DynamicCheckBox({super.key});

  @override
  State<StatefulWidget> createState() => _DynamicCheckBoxState();

  @override
  Widget render() => const DynamicCheckBox();
}

class _DynamicCheckBoxState extends State<DynamicCheckBox> {
  FormItem? formItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    return CheckboxFormField(
        title: Text(formItem?.controlText ?? ""),
        validator: (value) {
          validate(value);
          return null;
        });
  }

  validate(value) {
    Provider.of<PluginState>(context, listen: false)
        .addFormInput({"${formItem?.serviceParamId}": "$value"});
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key,
      required Widget title,
      required FormFieldValidator<bool> validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                controlAffinity: ListTileControlAffinity.platform,
              );
            });
}

class DynamicHorizontalText extends StatefulWidget implements IFormWidget {
  const DynamicHorizontalText({super.key, required this.input});

  final Map<String?, dynamic> input;

  @override
  State<StatefulWidget> createState() => _DynamicHorizontalText();

  @override
  Widget render() => DynamicHorizontalText(
        input: input,
      );
}

class _DynamicHorizontalText extends State<DynamicHorizontalText> {
  String customerName = "";
  final _profile = ProfileRepository();

  @override
  void initState() {
    AppLogger.appLogD(tag: "$classname all input", message: " ${widget.input}");
    super.initState();
    setCustomerName();
  }

  setCustomerName() async {
    customerName = await getCustomerName() ?? "";
    setState(() {});
  }

  Future<String?> getCustomerName() async {
    return await _profile.getUserInfo(UserAccountData.FirstName) +
        " " +
        await _profile.getUserInfo(UserAccountData.LastName);
  }

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;
    var formInput = widget.input[formItem?.controlId];

    if (formItem?.controlId == ControlID.FROMNAME.name) {
      formInput = customerName;
    }

    AppLogger.appLogD(
        tag: "$classname@${formItem?.controlId}", message: "input $formInput");

    AppLogger.appLogD(
        tag: "$classname@${formItem?.controlId}",
        message: "dropdown selection $dropdownSelection");

    return formInput == null
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 5, child: Text("${formItem?.controlText}:" ?? "")),
                Expanded(
                    flex: 5,
                    child: Text(
                      dropdownSelection[formItem?.controlId] ??
                          getStringValue(
                              formItem?.controlText ?? "", formInput) ??
                          "****",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                      softWrap: true,
                    ))
              ],
            ));
  }

  String getStringValue(String key, String value) {
    if (key.toLowerCase() == "frequency") {
      if (value == "1") {
        return "Daily";
      } else if (value == "2") {
        return "Weekly";
      } else if (value == "3") {
        return "Monthly";
      }
    }
    return value;
  }
}

class TextLink extends StatefulWidget implements IFormWidget {
  const TextLink({super.key});

  @override
  State<TextLink> createState() => _TextLinkState();

  @override
  Widget render() => const TextLink();
}

class _TextLinkState extends State<TextLink> {
  final _api = APIService();

  @override
  Widget build(BuildContext context) {
    var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return FutureBuilder<DynamicResponse?>(
        future: _api.getDynamicLink(formItem?.actionId ?? "", moduleItem!),
        builder:
            (BuildContext context, AsyncSnapshot<DynamicResponse?> snapshot) {
          Widget child = SizedBox(
            height: 28,
            child: CircularLoadUtil(),
          );
          if (snapshot.hasData) {
            String url = snapshot.data?.otherText ?? "";
            if (url.isNotEmpty) {
              child = Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        context.navigate(ViewPDFScreen(
                            moduleItem: moduleItem,
                            documentUrl: snapshot.data?.otherText ?? ""));
                      },
                      child: Text(formItem?.controlText ?? "Link")));
            } else {
              child = const SizedBox();
            }
          }
          return child;
        });
  }
}

class NullWidget implements IFormWidget {
  @override
  Widget render() {
    return const Visibility(
      visible: false,
      child: SizedBox(),
    );
  }
}
