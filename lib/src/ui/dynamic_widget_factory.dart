part of craft_dynamic;

abstract class IFormWidget {
  factory IFormWidget(FormItem formItem, {key, jsonText, formFields}) {
    ViewType? controlType = EnumFormatter.getViewType(formItem.controlType!);
    switch (controlType) {
      case ViewType.TEXT:
        return DynamicTextFormField(formFields: formFields);

      case ViewType.DATE:
        return DynamicTextFormField();

      case ViewType.HIDDEN:
        return HiddenWidget(formFields: formFields, formItem: formItem);

      case ViewType.BUTTON:
        return const DynamicButton();

      case ViewType.DROPDOWN:
        return DropDown(
          key: key,
        );

      case ViewType.DYNAMICDROPDOWN:
        return const DynamicDropDown();

      case ViewType.IMAGEDYNAMICDROPDOWN:
        return const ImageDynamicDropDown();

      case ViewType.LABEL:
        return DynamicLabelWidget();

      case ViewType.QRSCANNER:
        return DynamicQRScanner();

      case ViewType.PHONECONTACTS:
        return const DynamicPhonePickerFormWidget();

      case ViewType.TEXTVIEW:
        return DynamicTextViewWidget(jsonText: jsonText);

      case ViewType.LIST:
        return DynamicListWidget();

      case ViewType.HYPERLINK:
        return DynamicHyperLink();

      case ViewType.IMAGE:
        return formItem.controlFormat == ControlFormat.imagepanel.name
            ? const DynamicImageUpload()
            : NullWidget();

      case ViewType.CHECKBOX:
        return const DynamicCheckBox();

      case ViewType.HORIZONTALTEXT:
        return DynamicHorizontalText(
          input: jsonText,
        );

      case ViewType.TEXTLINK:
        return const TextLink();

      // case ViewType.CONTAINER:
      //   return const DynamicContainer();

      default:
        {
          return NullWidget();
        }
    }
  }

  Widget render();
}

class WidgetFactory {
  static Widget buildButton(
      BuildContext context, Function() onPressed, String buttonTitle,
      {Color? color}) {
    return IElevatedButton(Theme.of(context).platform)
        .getPlatformButton(onPressed, buttonTitle, color);
  }

  static Widget buildTextField(BuildContext context,
      TextFormFieldProperties properties, String? Function(String?) validator) {
    return ITextFormField(Theme.of(context).platform)
        .getPlatformTextField(properties, validator);
  }
}
