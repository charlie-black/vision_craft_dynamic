import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asn1.dart';

import 'package:pointycastle/export.dart';

import '../../craft_dynamic.dart';

class RSAUtil {
  static Future<String?> readCertificate(String pem) async {
    final publicKey =
        pem.replaceAll(RegExp(r'-----(BEGIN|END) CERTIFICATE-----'), '');
    return publicKey;
  }

  static Future<String?> rsaEncrypt(String plainText) async {
    String? encryptedText;
    try {
      final encrypter = Encrypter(
          RSA(publicKey: parsePublicKeyFromString(Constants.publicKey)));
      encryptedText = encrypter.encrypt(plainText).base64;
    } catch (e) {
      AppLogger.appLogE(
          tag: "Base64 to RSAPublicKey error", message: e.toString());
    }
    return encryptedText;
  }

  static RSAPublicKey? parsePublicKeyFromString(publicKey) {
    RSAPublicKey? rsaPublicKey;
    try {
      Uint8List encodedKeyBytes = base64.decode(publicKey);
      ASN1Parser parser = ASN1Parser(encodedKeyBytes);
      parser.nextObject();
      ASN1Sequence sequence = parser.nextObject() as ASN1Sequence;

      var ans1BitString = sequence.elements?[1] as ASN1BitString;
      AppLogger.appLogD(
          tag: "ans1BitString", message: ans1BitString.valueBytes);
      final rsaBytes = ans1BitString.stringValues;
      final rsaParser = ASN1Parser(Uint8List.fromList(rsaBytes!));
      final rsaSequence = rsaParser.nextObject() as ASN1Sequence;
      final modulus = rsaSequence.elements?[0] as ASN1Integer;
      final exponent = rsaSequence.elements?[1] as ASN1Integer;
      AppLogger.appLogD(tag: "modulus", message: modulus.integer);
      AppLogger.appLogD(tag: "exponent", message: exponent.integer);

      rsaPublicKey = RSAPublicKey(
        modulus.integer ?? BigInt.zero,
        exponent.integer ?? BigInt.zero,
      );
      AppLogger.appLogD(tag: "rsa", message: rsaPublicKey.modulus);
    } catch (e) {
      AppLogger.appLogE(tag: "RSA PARSE ERROR", message: e.toString());
    }
    return rsaPublicKey;
  }
}
