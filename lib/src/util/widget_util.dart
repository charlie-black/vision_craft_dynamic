import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/util/enum_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetUtil {
  static Map<String, dynamic> checkControlFormat(String widgetControlFormat,
      {context, isObscure, refreshParent, isTodayInitialDate = false}) {
    IconButton? suffixIcon;
    ControlFormat controlFormat = ControlFormat.OTHER;
    var inputType = TextInputType.text;
    var pinVisibility =
        Provider.of<PluginState>(context, listen: false).obscureText;

    try {
      controlFormat = ControlFormat.values.byName(widgetControlFormat);
    } catch (e) {
      AppLogger.appLogE(tag: "control format error", message: e.toString());
    }

    switch (controlFormat) {
      case ControlFormat.DATE:
        {
          inputType = TextInputType.datetime;
          suffixIcon = IconButton(
              onPressed: () {
                CommonUtils.selectDate(context,
                    refreshDate: refreshParent,
                    isTodayInitialDate: isTodayInitialDate);
              },
              icon: Icon(
                Icons.calendar_month,
                color: APIService.appPrimaryColor,
              ));
        }
        break;
      case ControlFormat.NUMERIC:
        {
          inputType = TextInputType.number;
        }
        break;
      case ControlFormat.Amount:
        {
          inputType = TextInputType.number;
        }
        break;
      case ControlFormat.PinNumber:
        {
          inputType = TextInputType.text;
          suffixIcon = IconButton(
              onPressed: () {
                Provider.of<PluginState>(context, listen: false)
                    .changeVisibility(!pinVisibility);
              },
              icon: Icon(
                pinVisibility ? Icons.visibility : Icons.visibility_off,
                color: APIService.appPrimaryColor,
              ));
        }
        break;
      case ControlFormat.PIN:
        {
          inputType = TextInputType.text;
          suffixIcon = IconButton(
              onPressed: () {
                Provider.of<PluginState>(context, listen: false)
                    .changeVisibility(!pinVisibility);
              },
              icon: Icon(
                  pinVisibility ? Icons.visibility : Icons.visibility_off));
        }
        break;
      default:
        inputType = TextInputType.text;
    }
    Map<String, dynamic> textFieldParams = {
      "inputType": inputType,
      "suffixIcon": suffixIcon
    };
    return textFieldParams;
  }

  static Color getTextColor(String value, String key) {
    var mapvalue = EnumFormatter.getMapValueAsString(value);
    var mapKey = EnumFormatter.getMapKeyAsString(key);
    if (mapKey == MapKey.AMOUNT) {
      return APIService.appPrimaryColor;
    }
    switch (mapvalue) {
      case MapValue.CREDIT:
        return Colors.green;
      case MapValue.DEBIT:
        return Colors.red;
      case MapValue.DEFAULT:
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  static List<FormItem> sortForms(List<FormItem> formItems) {
    for (var i = 1; i < formItems.length; i++) {
      FormItem key = formItems[i];
      int j = i - 1;
      while (j >= 0 && formItems[j].controlType == ViewType.BUTTON.name) {
        formItems[j + 1] = formItems[j];
        --j;
      }
      formItems[j + 1] = key;
    }
    return formItems;
  }
}
