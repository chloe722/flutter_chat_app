import 'dart:convert';
import 'dart:math';

final Random _random = Random.secure();

String createCryptoRandomString([int length = 32]) {
  var values = List<int>.generate(length, (i) => _random.nextInt(256));

  return base64Url.encode(values);
}
