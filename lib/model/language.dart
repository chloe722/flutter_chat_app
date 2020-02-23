class Language {

  String ttsLang;
  String translationLang;
  String label;

  Language({this.ttsLang, this.translationLang, this.label});

}

List<Language> languageList = [
  Language(label: "English", translationLang: "en", ttsLang: "en-US"),
  Language(label: "German", translationLang: "de", ttsLang: "de-DE"),
  Language(label: "Traditional Chinese", translationLang: "zh-tw", ttsLang: "zh-TW"),
  Language(label: "Lithuania", translationLang: "lt", ttsLang: null),
];