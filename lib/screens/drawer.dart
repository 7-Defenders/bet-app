import 'dart:ui';

import 'package:app/components/other/nunito_text.dart';
import 'package:app/components/profile_screen/settings_widget.dart';
import 'package:flutter/material.dart';


BackdropFilter drawer(BuildContext context, double vw, double vh) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Drawer(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 4 * vh, 0, 2.5 * vh),
                    child: nunitoText("Menu", 3 * vh, FontWeight.bold, Theme.of(context).colorScheme.background),
                  ),
                ],
              ),
              Expanded( // Wrap the entire container with Expanded
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.background,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(3 * vw, 3 * vh, 3 * vw, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: ColoredBox(
                              color: Theme.of(context).colorScheme.onTertiary,
                              child: SettingsExpansionButton(
                                title: "Settings",
                                vh: vh,
                                vw: vw,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
