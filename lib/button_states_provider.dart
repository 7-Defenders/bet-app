import 'package:flutter/material.dart';

class ButtonStatesProvider with ChangeNotifier {
  final ValueNotifier<Map<String, String>> _buttonStatesNotifier =
      ValueNotifier<Map<String, String>>({});

  final Map<String, String> _buttonStates = {};

  Map<String, String> get buttonStates => _buttonStates;

  void updateButtonState(String buttonId, String? selectedOption) {
    _buttonStates[buttonId] = selectedOption!;
    notifyListeners();

    _buttonStatesNotifier.value = _buttonStates;
    _buttonStatesNotifier.notifyListeners();
  }

  void removeButtonState(String buttonId) {
    _buttonStates.remove(buttonId);
    notifyListeners();
    _buttonStatesNotifier.value = _buttonStates;
    _buttonStatesNotifier.notifyListeners();
  }
}
