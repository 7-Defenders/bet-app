import 'package:flutter/material.dart';

class ButtonStatesProvider with ChangeNotifier {
  final Map<String, String> _buttonStates = {};

  Map<String, String> get buttonStates => _buttonStates;

  void updateButtonState(String buttonId, String? selectedOption) {
    _buttonStates[buttonId] = selectedOption!;
    notifyListeners();
  }
}
