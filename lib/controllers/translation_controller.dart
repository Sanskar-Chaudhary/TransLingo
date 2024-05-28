import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/translation.dart';

class TranslationController with ChangeNotifier {
  final String apiKey = dotenv.env['API_KEY']!;
  final String apiRegion = dotenv.env['API_REGION']!;
  final String apiUrl = 'https://api.cognitive.microsofttranslator.com/';

  List<Translation> _translations = [];
  Map<String, String> _languages = {};

  List<Translation> get translations => _translations;
  Map<String, String> get languages => _languages;

  TranslationController() {
    loadTranslations();
    fetchLanguages();
  }

  Future<void> loadTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? translationsData = prefs.getString('translations');
    if (translationsData != null) {
      _translations = (jsonDecode(translationsData) as List)
          .map((item) => Translation.fromJson(item))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addTranslation(Translation translation) async {
    _translations.add(translation);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('translations', jsonEncode(_translations.map((e) => e.toJson()).toList()));
  }

  Future<void> clearHistory() async {
    _translations.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('translations');
  }

  Future<Translation> translate(String text, String from, String to) async {
    final response = await http.post(
      Uri.parse('${apiUrl}translate?api-version=3.0&from=$from&to=$to'),
      headers: {
        'Ocp-Apim-Subscription-Key': apiKey,
        'Ocp-Apim-Subscription-Region': apiRegion,
        'Content-Type': 'application/json',
      },
      body: jsonEncode([{'Text': text}]),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final translatedText = data[0]['translations'][0]['text'];
      final translation = Translation(originalText: text, translatedText: translatedText);
      await addTranslation(translation);
      return translation;
    } else {
      throw Exception('Failed to translate text');
    }
  }

  Future<void> fetchLanguages() async {
    final response = await http.get(
      Uri.parse('${apiUrl}languages?api-version=3.0'),
      headers: {
        'Ocp-Apim-Subscription-Key': apiKey,
        'Ocp-Apim-Subscription-Region': apiRegion,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final languageData = data['translation'];
      _languages = Map<String, String>.from(languageData.map((key, value) => MapEntry(key, value['name'])));
      notifyListeners();
    } else {
      throw Exception('Failed to fetch languages');
    }
  }
}
