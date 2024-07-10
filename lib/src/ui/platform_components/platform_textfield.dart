// ignore_for_file: non_constant_identifier_names

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';

abstract class ITextFormField {
  factory ITextFormField(TargetPlatform targetPlatform) {
    switch (targetPlatform) {
      case TargetPlatform.android:
        return AndroidTextFormField();

      case TargetPlatform.iOS:
        return AndroidTextFormField();

      default:
        return AndroidTextFormField();
    }
  }

  Widget getPlatformTextField(
      TextFormFieldProperties properties, String? Function(String?) validator);
}

class IOSTextFormField implements ITextFormField {
  @override
  Widget getPlatformTextField(
      TextFormFieldProperties properties, String? Function(String?) validator) {
    return CupertinoTextFormFieldRow(
      autofocus: properties.autofocus,
      enabled: properties.isEnabled,
      controller: properties.controller,
      keyboardType: properties.textInputType,
      obscureText: properties.isObscured,
      decoration: properties.boxDecoration,
      style: const TextStyle(fontSize: 16),
      validator: validator,
      onChanged: properties.onChange,
      inputFormatters: properties.isAmount ? [CurrencyInputFormatter()] : null,
    );
  }
}

class AndroidTextFormField implements ITextFormField {
  @override
  Widget getPlatformTextField(
      TextFormFieldProperties properties, String? Function(String?) validator) {
    return TextFormField(
      autofocus: properties.autofocus,
      enabled: properties.isEnabled,
      controller: properties.controller,
      keyboardType: properties.textInputType,
      obscureText: properties.isObscured,
      maxLength: properties.maxLength,
      maxLines: properties.isObscured ? 1 : properties.maxLines,
      decoration: properties.inputDecoration,
      style: properties.textStyle,
      validator: validator,
      onChanged: properties.onChange ?? (input) {},
      inputFormatters: properties.isAmount ? [CurrencyInputFormatter()] : null,
    );
  }
}
