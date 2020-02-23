import 'dart:convert';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

final Random _random = Random.secure();
final _translator = GoogleTranslator();


String createCryptoRandomString([int length = 32]) {
  var values = List<int>.generate(length, (i) => _random.nextInt(256));

  return base64Url.encode(values);
}


Future<String> translateMessage(String text, String language) async {
  return await _translator.translate(text, to: language);
}





