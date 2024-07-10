import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class EnumFormatter {
  static ControlID getControlID(String formControlID) {
    ControlID controlID = ControlID.OTHER;
    try {
      controlID = ControlID.values.byName(formControlID);
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return controlID;
  }

  static ControlFormat getControlFormat(String? formControlFormat) {
    ControlFormat controlFormat = ControlFormat.OTHER;
    try {
      if (formControlFormat == null || formControlFormat.isEmpty) {
        return ControlFormat.OTHER;
      }
      controlFormat = ControlFormat.values.byName(formControlFormat);
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return controlFormat;
  }

  static ViewType getViewType(String? formControlFormat) {
    ViewType viewType = ViewType.OTHER;
    try {
      if (formControlFormat == null || formControlFormat.isEmpty) {
        return ViewType.OTHER;
      }
      viewType = ViewType.values.byName(formControlFormat);
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return viewType;
  }

  static FormId getFormID(String formIDToConvert) {
    FormId formID = FormId.FORMS;
    try {
      formID = FormId.values.byName(formIDToConvert);
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return formID;
  }

  static MapValue getMapValueAsString(String key) {
    MapValue mapValue = MapValue.DEFAULT;
    try {
      mapValue = MapValue.values.byName(key.toUpperCase());
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return mapValue;
  }

  static MapKey getMapKeyAsString(String key) {
    MapKey mapKey = MapKey.DEFAULT;
    try {
      mapKey = MapKey.values.byName(key.toUpperCase());
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return mapKey;
  }

  static ModuleId getModuleId(String moduleIdToConvert) {
    ModuleId moduleId = ModuleId.DEFAULT;
    try {
      moduleId = ModuleId.values.byName(moduleIdToConvert);
    } catch (e) {
      debugPrint("Error!, $e");
    }
    return moduleId;
  }
}
