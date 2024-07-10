import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class Config {
  static dynamic yamlFile;

  static createConfig(BuildContext context) async {
    yamlFile = await loadAsset(context);
    return Config();
  }

  static Future<dynamic> loadAsset(BuildContext context) async {
    final yamlString = await DefaultAssetBundle.of(context)
        .loadString('assets/craft_dynamic.yaml');
    return loadYaml(yamlString);
  }

  static String generateBankCustomerID(
      String countryCode, String bankID, bool isTest) {
    String bankCustomerID = "";
    bankCustomerID = bankCustomerID + countryCode;
    int lengthToAdd = 8 - (bankCustomerID.length + bankID.length);

    for (int i = lengthToAdd - 1; i >= 0; i--) {
      if (isTest && i == 0) {
        bankCustomerID += "1";
      } else {
        bankCustomerID += "0";
      }
      lengthToAdd--;
    }
    bankCustomerID += bankID; //25119972
    return bankCustomerID;
  }
}
