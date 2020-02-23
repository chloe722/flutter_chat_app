import 'package:flash_chat/constants.dart';
import 'package:flash_chat/model/language.dart';
import 'package:flash_chat/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class TranslationBottomSheet extends StatefulWidget {
  TranslationBottomSheet({this.text});

  final String text;

  @override
  _TranslationBottomSheetState createState() => _TranslationBottomSheetState();
}

class _TranslationBottomSheetState extends State<TranslationBottomSheet> {
  FlutterTts _flutterTts;

  TtsState ttsState = TtsState.stopped;
  Language selectedLanguage = languageList[0];
  String _translatedText;
  dynamic languages;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool _loading = true;

  void _initTts() async {
    _translatedText = widget.text; // default
    _flutterTts = FlutterTts();
    print('current language: ${selectedLanguage.label}');
    _translatedText =
        await translateMessage(widget.text, selectedLanguage.translationLang);
//   await _getLanguages();
    _flutterTts.setLanguage(selectedLanguage.ttsLang);

    _flutterTts.setStartHandler(() {
      print('playing');

      ttsState = TtsState.playing;
    });

    _flutterTts.setCompletionHandler(() {
      print('stop');
      ttsState = TtsState.stopped;
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await _flutterTts.setVolume(volume);
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(0.5);
    if (_translatedText != null && _translatedText.isNotEmpty) {
      var result = await _flutterTts.speak(_translatedText);
      if (result == 1) setState(() => ttsState = TtsState.playing);
    }
  }

//  Future _getLanguages() async {
//    var _languages = await _flutterTts.getLanguages;
//    print("languages: $_languages");
//    setState(() {
//      languages = _languages;
//      _loading = false;
//    });
//  }

  @override
  void initState() {
    _initTts();
    super.initState();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  List<DropdownMenuItem<Language>> _getLanguagesDropdownItems() {
    var items = List<DropdownMenuItem<Language>>();
    for (Language language in languageList) {
      items.add(DropdownMenuItem(child: Text(language.label), value: language));
    }
    return items;
  }

  void changedLanguageDropDownItem(Language selectedLang) async {
    await translateMessage(_translatedText, selectedLang.translationLang)
        .then((result) {
      print("translated text1: $result");
      setState(() {
        selectedLanguage = selectedLang;
        _flutterTts.setLanguage(selectedLang.ttsLang);
        _translatedText = result;
        print("translated text: $_translatedText");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.volume_up),
                  color: kDodgerBlue,
                  onPressed:
                      selectedLanguage.ttsLang != null ? () => _speak() : null),
              DropdownButton(
                items: _getLanguagesDropdownItems(),
                onChanged: changedLanguageDropDownItem,
                value: selectedLanguage,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text(
              _translatedText ?? widget.text,
              softWrap: true,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
