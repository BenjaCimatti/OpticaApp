import 'dart:convert';

import 'package:crypto/crypto.dart';

class Encode {

  String hash256(String rawString) {
    List<int> digest = utf8.encode(rawString);
    Digest encodedPassword = sha256.convert(digest);
    return encodedPassword.toString();
  }

}