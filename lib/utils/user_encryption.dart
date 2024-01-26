import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:nexus/models/user.dart';

String userEncrypt(User user) {
  String jsonString = jsonEncode(user!.toJson());

  final key = Key.fromUtf8('nexus_user012345');
  final iv = IV.fromLength(8);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(jsonString, iv: iv);
  return encrypted.base64;
}

User userDecrypt(String base64) {
  final key = Key.fromUtf8('nexus_user012345');
  final iv = IV.fromLength(8);
  final encrypter = Encrypter(AES(key));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(base64), iv: iv);

  final user = User.fromJson(jsonDecode(decrypted));
  return user;
}
