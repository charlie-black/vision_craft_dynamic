import 'package:craft_dynamic/craft_dynamic.dart';

import 'result_builder.dart';
import 'map_builder.dart';

class DynamicFactory {
  static Map<String, dynamic> getDynamicRequestObject(ActionType action,
      {required merchantID,
      required actionID,
      required requestMap,
      required dataObject,
      isList = false,
      listType,
      encryptedFields}) {
    return IRequestObject(action,
            merchantID: merchantID,
            actionID: actionID,
            requestMap: requestMap,
            dataObject: dataObject,
            isList: isList,
            listType: listType,
            encryptedFields: encryptedFields)
        .getRequestObject();
  }

  static PostDynamicBuilder getPostDynamicObject(DynamicData? dynamicData) {
    return IPostDynamicCheck(dynamicData).getBuilder();
  }
}
