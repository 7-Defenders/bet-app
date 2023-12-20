import 'package:app/providers/button_states_provider.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/button_states_provider.dart';
import 'package:app/firebase_options.dart';
import 'package:app/screens/achievements_screen.dart';
import 'package:app/screens/auth_screens/auth_screen.dart';
import 'package:app/screens/history_screen.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/league_screens/league_creator.dart';
import 'package:app/themes/dark_theme.dart';
import 'package:app/themes/light_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider(dotenv.env['RECAPTCHA_SITE_KEY']!),
    // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.debug,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LeagueJoiningBloc>(
          create: (context) => LeagueJoiningBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider(),
          ),
          ChangeNotifierProvider<ButtonStatesProvider>(
            create: (context) => ButtonStatesProvider(),
          ),
          Provider<GlobalKey<EventsScreenState>>(
            create: (_) => EventsScreenState.key,
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthScreen(),
    );
  }
}
