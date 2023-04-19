// import 'package:encrypt/encrypt.dart';

import 'package:encrypt/encrypt.dart';

class Aes {
  static final String keyId = "AESNIRMALYEHSKEY";
  static final String initVector = "encryptionIntTak";

  static String? encrypt(String plainText) {
    // final key = Key.fromUtf8("nirmalyaLabsPVTT");
    // final iv = IV.fromUtf8("TTVPsbaLaylamrin");
    if (plainText != null && plainText != "" && plainText != "null") {
      final key = Key.fromUtf8(keyId);
      final iv = IV.fromUtf8(initVector);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc,padding: "PKCS7"));
      return encrypter.encrypt(plainText, iv: iv).base64;
    } else {
      return null;
    }
  }

  static String? decrypt(String val) {
    if (val != null && val != "" && val != "null") {
      final key = Key.fromUtf8(keyId);
      final iv = IV.fromUtf8(initVector);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc,padding: "PKCS7"));
      return encrypter.decrypt64(val, iv: iv);
    } else {
      return null;
    }
  }
}