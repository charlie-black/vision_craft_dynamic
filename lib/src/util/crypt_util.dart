// ignore_for_file: deprecated_member_use

part of craft_dynamic;

class CryptLib {
  static int count = 0;

  static Map<String, dynamic> generateKeyIV() {
    final key = Key.fromSecureRandom(8);
    final iv = IV.fromSecureRandom(8);
    // return {"key": "csXDRzpcEPm_jMny", "iv": "84jfkfndl3ybdfkf"};
    return {
      "key": key.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(''),
      "iv": iv.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('')
    };
  }

  static String toSHA256(String key, int length) {
    var bytes1 = utf8.encode(key); // data being hashed
    var digest1 = sha256.convert(bytes1);
    var digestBytes = digest1.bytes;
    var hex = HEX.encode(digestBytes);
    if (length > hex.toString().length) {
      return hex.toString();
    } else {
      return hex.toString().substring(0, length);
    }
  }

  static Future<String> oldDecrypt(String response, {key, value}) async {
    return utf8.decode(base64.decode(CryptLib.decrypt(
        base64.normalize(response),
        CryptLib.toSHA256(key ?? currentKey.value, 32),
        value ?? currentIv.value,
        response: response)));
  }

  static String decrypt(String ciphertext, String decryptKey, String decryptIv,
      {response}) {
    String decrypted = "";
    try {
      final key = encryptcrpto.Key.fromUtf8(decryptKey);
      final iv = encryptcrpto.IV.fromUtf8(decryptIv);

      final encrypter = encryptcrpto.Encrypter(
          encryptcrpto.AES(key, mode: encryptcrpto.AESMode.cbc));
      encryptcrpto.Encrypted enBase64 =
          encryptcrpto.Encrypted.from64(ciphertext);
      decrypted = encrypter.decrypt(enBase64, iv: iv);
    } catch (e) {
      AppLogger.appLogE(
          tag: "DECRYPT ERROR", message: "Unable to decrypt data:::$e");
    }
    return decrypted;
  }

  static String encrypt(String plainText, String encryptKey, String encryptIv) {
    final key = encryptcrpto.Key.fromUtf8(toSHA256(encryptKey, 32));
    final iv = encryptcrpto.IV.fromUtf8(encryptIv);
    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(key, mode: encryptcrpto.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String encryptField(String plainText) {
    final hashKey =
        encryptcrpto.Key.fromUtf8(toSHA256(Constants.logKeyValue, 32));
    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(hashKey, mode: encryptcrpto.AESMode.cbc));
    final encryptedText = encrypter.encrypt(plainText,
        iv: encryptcrpto.IV.fromUtf8(Constants.staticIV));
    return encryptedText.base64;
  }

  static String dynamicEncryptField(String plainText) {
    final hashKey = encryptcrpto.Key.fromUtf8(toSHA256(currentKey.value, 32));
    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(hashKey, mode: encryptcrpto.AESMode.cbc));
    final encryptedText = encrypter.encrypt(plainText,
        iv: encryptcrpto.IV.fromUtf8(currentIv.value));
    return encryptedText.base64;
  }

  static String decryptField({encrypted}) {
    // final hashKey = encryptcrpto.Key.fromUtf8(toSHA256(currentKey.value, 32)); //TODO IMPLEMENT THIS
    final hashKey =
        encryptcrpto.Key.fromUtf8(toSHA256(Constants.logKeyValue, 32));

    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(hashKey, mode: encryptcrpto.AESMode.cbc));
    encryptcrpto.Encrypted enBase64 = encryptcrpto.Encrypted.from64(encrypted);
    return encrypter.decrypt(enBase64,
        iv: encryptcrpto.IV.fromUtf8(Constants.staticIV));
  }

  static String encryptPayloadObj(
      String decryptedString, String keyvaltest, String serverIV) {
    String data = "";
    String key = toSHA256(keyvaltest, 32);
    data = encrypt(decryptedString, key, serverIV);
    data = data.replaceAll("\\r\\n|\\r|\\n", "");
    return data;
  }

  static String gzipDecompressStaticData(String gzippedString) {
    return utf8.decode(GZipDecoder().decodeBytes(base64.decode(gzippedString)));
  }

  static decryptResponse(String response) async {
    String decrypted = "";
    try {
      decrypted = await CryptLib.oldDecrypt(response);
    } catch (e) {
      AppLogger.appLogE(
          tag: "Decryption Error", message: "Unable to decrypt data!");
    }
    return decrypted;
  }

  static String? gcmDecrypt(
      String encryptedData, String encryptIv, String encryptKey) {
    String? decrypted;
    try {
      final cipher = GCMBlockCipher(AESFastEngine());

      AppLogger.appLogI(
          tag: "gcm function", message: "now getting aed parameters...");
      // final cbcParams = ParametersWithIV(
      //     KeyParameter(Uint8List.fromList(utf8.encode(encryptKey))),
      //     Uint8List.fromList(utf8.encode(encryptIv)));

      final params = AEADParameters(
        KeyParameter(Uint8List.fromList(utf8.encode(encryptKey))),
        128,
        Uint8List.fromList(utf8.encode(encryptIv)),
        Uint8List(0),
      );

      AppLogger.appLogI(
          tag: "gcm function", message: "now initializing cipher...");
      cipher.init(false, params);

      AppLogger.appLogI(
          tag: "gcm function", message: "now decoding encrypted data...");
      final decodedValue = base64.decode(encryptedData);

      AppLogger.appLogI(
          tag: "gcm function", message: "now processing decoded data...");
      final decryptedVal = cipher.process(decodedValue);

      decrypted = utf8.decode(decryptedVal);
    } catch (e) {
      AppLogger.appLogE(tag: "GCM DECRYPTION ERROR", message: e.toString());
    }

    return decrypted;
  }
}
