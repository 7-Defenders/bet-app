import 'package:flutter/material.dart';

class AppLanguageNotifier extends ChangeNotifier {
  String _selectedLanguage = 'English';

  String get selectedLanguage => _selectedLanguage;

  void setSelectedLanguage(String newLanguage) {
    _selectedLanguage = newLanguage;
    notifyListeners();
  }
}
