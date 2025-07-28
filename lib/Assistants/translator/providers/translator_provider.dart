// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import '../../../chat-with-ai-bot/apis/apis.dart';
import '../../../chat-with-ai-bot/helper/my_dialog.dart';

enum Status { none, loading, complete }

class TranslateProvider with ChangeNotifier {
  final textC = TextEditingController();
  final resultC = TextEditingController();
  Status _status = Status.none;
  String _from = '';
  String _to = '';
  String _search = '';

  final Map<String, String> _jsonLang = const {
    // 'Automatic': 'auto',
    'Afrikaans': 'af',
    'Albanian': 'sq',
    'Amharic': 'am',
    'Arabic': 'ar',
    'Armenian': 'hy',
    'Assamese': 'as',
    'Aymara': 'ay',
    'Azerbaijani': 'az',
    'Bambara': 'bm',
    'Basque': 'eu',
    'Belarusian': 'be',
    'Bengali': 'bn',
    'Bhojpuri': 'bho',
    'Bosnian': 'bs',
    'Bulgarian': 'bg',
    'Catalan': 'ca',
    'Cebuano': 'ceb',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-tw',
    'Corsican': 'co',
    'Croatian': 'hr',
    'Czech': 'cs',
    'Danish': 'da',
    'Dhivehi': 'dv',
    'Dogri': 'doi',
    'Dutch': 'nl',
    'English': 'en',
    'Esperanto': 'eo',
    'Estonian': 'et',
    'Ewe': 'ee',
    'Filipino (Tagalog)': 'tl',
    'Finnish': 'fi',
    'French': 'fr',
    'Frisian': 'fy',
    'Galician': 'gl',
    'Georgian': 'ka',
    'German': 'de',
    'Greek': 'el',
    'Guarani': 'gn',
    'Gujarati': 'gu',
    'Haitian Creole': 'ht',
    'Hausa': 'ha',
    'Hawaiian': 'haw',
    'Hebrew': 'iw',
    'Hindi': 'hi',
    'Hmong': 'hmn',
    'Hungarian': 'hu',
    'Icelandic': 'is',
    'Igbo': 'ig',
    'Ilocano': 'ilo',
    'Indonesian': 'id',
    'Irish': 'ga',
    'Italian': 'it',
    'Japanese': 'ja',
    'Javanese': 'jw',
    'Kannada': 'kn',
    'Kazakh': 'kk',
    'Khmer': 'km',
    'Kinyarwanda': 'rw',
    'Konkani': 'gom',
    'Korean': 'ko',
    'Krio': 'kri',
    'Kurdish (Kurmanji)': 'ku',
    'Kurdish (Sorani)': 'ckb',
    'Kyrgyz': 'ky',
    'Lao': 'lo',
    'Latin': 'la',
    'Latvian': 'lv',
    'Lithuanian': 'lt',
    'Luganda': 'lg',
    'Luxembourgish': 'lb',
    'Macedonian': 'mk',
    'Malagasy': 'mg',
    'Maithili': 'mai',
    'Malay': 'ms',
    'Malayalam': 'ml',
    'Maltese': 'mt',
    'Maori': 'mi',
    'Marathi': 'mr',
    'Meiteilon (Manipuri)': 'mni-mtei',
    'Mizo': 'lus',
    'Mongolian': 'mn',
    'Myanmar (Burmese)': 'my',
    'Nepali': 'ne',
    'Norwegian': 'no',
    'Nyanja (Chichewa)': 'ny',
    'Odia (Oriya)': 'or',
    'Oromo': 'om',
    'Pashto': 'ps',
    'Persian': 'fa',
    'Polish': 'pl',
    'Portuguese': 'pt',
    'Punjabi': 'pa',
    'Quechua': 'qu',
    'Romanian': 'ro',
    'Russian': 'ru',
    'Samoan': 'sm',
    'Sanskrit': 'sa',
    'Scots Gaelic': 'gd',
    'Sepedi': 'nso',
    'Serbian': 'sr',
    'Sesotho': 'st',
    'Shona': 'sn',
    'Sindhi': 'sd',
    'Sinhala': 'si',
    'Slovak': 'sk',
    'Slovenian': 'sl',
    'Somali': 'so',
    'Spanish': 'es',
    'Sundanese': 'su',
    'Swahili': 'sw',
    'Swedish': 'sv',
    'Tajik': 'tg',
    'Tamil': 'ta',
    'Tatar': 'tt',
    'Telugu': 'te',
    'Thai': 'th',
    'Tigrinya': 'ti',
    'Tsonga': 'ts',
    'Turkish': 'tr',
    'Turkmen': 'tk',
    'Twi (Akan)': 'ak',
    'Ukrainian': 'uk',
    'Urdu': 'ur',
    'Uyghur': 'ug',
    'Uzbek': 'uz',
    'Vietnamese': 'vi',
    'Welsh': 'cy',
    'Xhosa': 'xh',
    'Yiddish': 'yi',
    'Yoruba': 'yo',
    'Zulu': 'zu'
  };

  // Getters and Setters for languages and states
  Status get status => _status;
  String get from => _from;
  String get to => _to;
  String get search => _search;
  List<String> get languages => _jsonLang.keys.toList();

  set status(Status value) {
    _status = value;
    notifyListeners();
  }

  set from(String value) {
    _from = value;
    notifyListeners(); // Notify listeners for UI update
  }

  set to(String value) {
    _to = value;
    notifyListeners(); // Notify listeners for UI update
  }

  set search(String value) {
    _search = value.toLowerCase(); // Ensure search term is in lowercase
    notifyListeners(); // Notify listeners for filteredLanguages update
  }

  // Filtered list of languages based on the search input
  List<String> get filteredLanguages {
    if (_search.isEmpty) return languages;
    return languages
        .where((lang) =>
            lang.toLowerCase().contains(_search)) // Case insensitive filtering
        .toList();
    notifyListeners();
  }

  // Swap the 'from' and 'to' languages
  void swapLanguages() {
    final temp = _from;
    _from = _to;
    _to = temp;
    final tempController = textC.text;
    textC.text = resultC.text;
    resultC.text = tempController;

    notifyListeners(); // Notify listeners after swap
  }

  // Translate text using Google API
  Future<void> googleTranslate() async {
    if (textC.text.trim().isEmpty) {
      MyDialog.info('Type something to translate!');
      return;
    }
    if (_to.isEmpty) {
      MyDialog.info('Select "To" language!');
      return;
    }
    _status = Status.loading;
    notifyListeners();
    try {
      final fromLangCode = _jsonLang[_from] ?? 'auto';
      final toLangCode = _jsonLang[_to] ?? 'en';

      final translation = await APIS.googleTranslate(
        from: fromLangCode,
        to: toLangCode,
        text: textC.text.trim(),
      );

      resultC.text = translation;
      _status = Status.complete;
    } catch (e) {
      MyDialog.info('Translation failed! Please try again.');
      _status = Status.none;
    }

    notifyListeners(); // Notify listeners after translation
  }

  // Reset search term
  void clearSearch() {
    _search = '';
    notifyListeners(); // Notify listeners to reset search
  }
}
