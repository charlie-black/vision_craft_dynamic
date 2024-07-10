import 'package:craft_dynamic/craft_dynamic.dart';

abstract class IRequestObject {
  Map<String?, dynamic> dataObject = {};
  Map<String, dynamic> requestObject = {};
  ActionType? actionType;

  factory IRequestObject(ActionType action,
      {required merchantID,
      required actionID,
      required requestMap,
      required dataObject,
      isList = false,
      listType,
      encryptedFields}) {
    switch (action) {
      case ActionType.DBCALL:
        return DBCall(
            merchantID: merchantID,
            actionType: action,
            actionID: actionID,
            requestObject: requestMap,
            dataObject: dataObject,
            encryptedFieldsObject: encryptedFields,
            isList: isList,
            listType: listType);

      case ActionType.PAYBILL:
        return PayBill(
            dataObject: dataObject,
            merchantID: merchantID,
            actionType: action,
            encryptedFieldsObject: encryptedFields,
            requestObject: requestMap);

      case ActionType.VALIDATE:
        return Validate(
            merchantID: merchantID,
            dataObject: dataObject,
            actionType: action,
            requestObject: requestMap);

      case ActionType.CHANGEPIN:
        return ChangePin(
          dataObject: dataObject,
          actionType: action,
          requestObject: requestMap,
          encryptedFieldsObject: encryptedFields,
        );

      case ActionType.FORGOTPIN:
        return ForgotPin(
          dataObject: dataObject,
          actionType: action,
          requestObject: requestMap,
          encryptedFieldsObject: encryptedFields,
        );

      default:
        return DefaultObject();
    }
  }

  Map<String, dynamic> getRequestObject();
}

class DefaultObject implements IRequestObject {
  @override
  Map<String?, dynamic> dataObject = {};

  @override
  Map<String, dynamic> requestObject = {};

  @override
  ActionType? actionType;

  @override
  Map<String, dynamic> getRequestObject() {
    return {};
  }
}

class Validate implements IRequestObject {
  String merchantID;

  @override
  ActionType? actionType;

  @override
  Map<String?, dynamic> dataObject;

  @override
  Map<String, dynamic> requestObject = {};

  Validate(
      {required this.merchantID,
      this.actionType,
      required this.dataObject,
      required this.requestObject});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    fields.addAll(dataObject);
    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.MerchantID.name] = merchantID;
    requestObject[RequestParam.Validate.name] = fields;
    return requestObject;
  }
}

class PayBill implements IRequestObject {
  @override
  Map<String?, dynamic> dataObject;
  Map<String?, dynamic> encryptedFieldsObject;

  @override
  Map<String, dynamic> requestObject = {};

  @override
  ActionType? actionType;

  String merchantID;

  PayBill({
    required this.requestObject,
    required this.dataObject,
    required this.merchantID,
    required this.encryptedFieldsObject,
    this.actionType,
  });

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    Map<String?, dynamic> encryptedFields = {};
    fields.addAll(dataObject);
    encryptedFields.addAll(encryptedFieldsObject);

    fields.addAll({RequestParam.MerchantID.name: merchantID});
    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.MerchantID.name] = merchantID;
    requestObject[RequestParam.PayBill.name] = fields;
    requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    return requestObject;
  }
}

class DBCall implements IRequestObject {
  @override
  Map<String?, dynamic> dataObject;
  Map<String?, dynamic>? encryptedFieldsObject;

  @override
  Map<String, dynamic> requestObject = {};

  @override
  ActionType? actionType;

  final String merchantID, actionID;
  final ListType listType;
  final bool isList;

  DBCall(
      {required this.merchantID,
      required this.actionType,
      required this.actionID,
      required this.requestObject,
      required this.dataObject,
      this.encryptedFieldsObject,
      this.listType = ListType.TransactionList,
      this.isList = false});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    Map<String?, dynamic> encryptedFields = {};
    fields.addAll(dataObject);
    encryptedFields.addAll(encryptedFieldsObject ?? {});

    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.MerchantID.name] = merchantID;
    if (fields.containsKey(RequestParam.HEADER.name) == false) {
      fields[RequestParam.HEADER.name] = actionID;
    }
    fields[RequestParam.MerchantID.name] = merchantID;

    if (encryptedFields.isNotEmpty) {
      requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    }
    requestObject[RequestParam.DynamicForm.name] = fields;
    return requestObject;
  }
}

class ChangePin implements IRequestObject {
  @override
  ActionType? actionType;

  @override
  Map<String?, dynamic> dataObject;

  Map<String?, dynamic> encryptedFieldsObject;

  @override
  Map<String, dynamic> requestObject = {};

  ChangePin(
      {this.actionType,
      required this.dataObject,
      required this.requestObject,
      required this.encryptedFieldsObject});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    Map<String?, dynamic> encryptedFields = {};
    fields.addAll(dataObject);
    encryptedFields.addAll(encryptedFieldsObject);

    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.CHANGEPIN.name] = fields;
    requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    return requestObject;
  }
}

class ForgotPin implements IRequestObject {
  @override
  ActionType? actionType;

  @override
  Map<String?, dynamic> dataObject;

  Map<String?, dynamic> encryptedFieldsObject;

  @override
  Map<String, dynamic> requestObject = {};

  ForgotPin(
      {this.actionType,
      required this.dataObject,
      required this.requestObject,
      required this.encryptedFieldsObject});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    Map<String?, dynamic> encryptedFields = {};
    fields.addAll(dataObject);
    encryptedFields.addAll(encryptedFieldsObject);

    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.CHANGEPIN.name] = fields;
    requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    return requestObject;
  }
}
