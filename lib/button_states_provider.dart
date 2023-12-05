import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonStatesProvider with ChangeNotifier {
  final ValueNotifier<Map<String, String>> _buttonStatesNotifier =
      ValueNotifier<Map<String, String>>({});

  ValueNotifier<Map<String, String>> get buttonStatesNotifier =>
      _buttonStatesNotifier;

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

  void removeButtonStateAndRefresh(String buttonId) {
    //print value notifier
    //print(_buttonStatesNotifier);
    removeButtonState(buttonId);
    notifyListeners();

    //print eagues screen state key
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   final leaguesScreenState = LeaguesScreenState.key.currentState;
    //   print(leaguesScreenState.toString() + ' leagues screen state');
    //   //leaguesScreenState?.rebuild();
    // });

    //rebuild leagues screen
    //leaguesScreenStateKey.currentState?.rebuild();

    print(_buttonStatesNotifier);
    //print(_buttonStatesNotifier.hasListeners);
  }
}
