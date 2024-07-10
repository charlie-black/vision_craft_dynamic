part of craft_dynamic;

class DynamicForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: ListView.builder(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              return BaseFormComponent(
                  formItem: forms[index],
                  moduleItem: moduleItem,
                  formItems: forms,
                  formKey: formkey,
                  child: IFormWidget(forms[index],
                          jsonText: jsonDisplay, formFields: formFields)
                      .render());
            }));
  }
}
