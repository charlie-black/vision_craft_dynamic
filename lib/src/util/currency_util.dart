import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  final formatter = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text == '0') {
      return newValue;
    }

    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newValue.text.startsWith('-')) {
      newText.write('-');
      selectionIndex++;
    }

    if (newTextLength >= 1) {
      newText.write(formatter.format(int.parse(newValue.text)));
    }

    // Dump the rest.
    // In our example only allow 8 characters (123,456.)
    if (newTextLength > 8) {
      selectionIndex = 8;
      usedSubstringIndex = 8;
      newText.write(newValue.text.substring(0, usedSubstringIndex));
    } else {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
