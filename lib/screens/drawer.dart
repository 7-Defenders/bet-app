import 'dart:ui';

import 'package:app/assets/translations.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/components/profile_screen/settings_widget.dart';
import 'package:flutter/material.dart';


BackdropFilter drawer(BuildContext context, double vw, double vh, String selectedLanguage, Function(String) onLanguageChange) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.background.withOpacity(0.8),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2 * vh),
                  nunitoText("Drawer", 22, FontWeight.bold, Theme.of(context).colorScheme.onBackground),
                  SizedBox(height: 2 * vh),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3 * vw),
                    child: SettingsExpansionButton(
                      title: translate("Settings", selectedLanguage),
                      vh: vh,
                      vw: vw,
                      onLanguageChange: (String newLanguage) {
                        onLanguageChange(newLanguage);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
