import 'package:flutter/material.dart';

class ButtonStatesProvider with ChangeNotifier {
  final ValueNotifier<Map<String, String>> _buttonStatesNotifier =
      ValueNotifier<Map<String, String>>({});

  Map<String, String> get buttonStates => _buttonStatesNotifier.value;

  void updateButtonState(String buttonId, String selectedOption) {
    _buttonStatesNotifier.value = {
      ..._buttonStatesNotifier.value,
      buttonId: selectedOption,
    };
    _buttonStatesNotifier.notifyListeners();
  }

  void removeButtonState(String buttonId) {
    _buttonStatesNotifier.value = Map.from(_buttonStatesNotifier.value);
    _buttonStatesNotifier.value.remove(buttonId);
    _buttonStatesNotifier.notifyListeners();
  }
}
