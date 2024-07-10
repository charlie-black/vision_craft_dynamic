part of craft_dynamic;

class DynamicForm extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final ModuleItem moduleItem;
  final List<FormItem> forms;
  final List<dynamic>? jsonDisplay, formFields;

  const DynamicForm(
      {super.key,
      required this.formkey,
      required this.moduleItem,
      required this.forms,
      this.jsonDisplay,
      this.formFields});

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  void initState() {
    super.initState();
    widget.forms
        .removeWhere((formItem) => formItem.controlType == ViewType.LIST.name);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formkey,
        child: ListView.builder(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.forms.length,
            itemBuilder: (context, index) {
              return BaseFormComponent(
                  formItem: widget.forms[index],
                  moduleItem: widget.moduleItem,
                  formItems: widget.forms,
                  formKey: widget.formkey,
                  child: IFormWidget(widget.forms[index],
                          jsonText: widget.jsonDisplay,
                          formFields: widget.formFields)
                      .render());
            }));
  }
}
