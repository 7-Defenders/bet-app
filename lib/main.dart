import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/firebase_options.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:app/scaffold_with_navbar.dart';
import 'package:app/screens/auth_screens/login_or_register_screen.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/home_screens/home_screen.dart';
import 'package:app/screens/navbar_screens/home_screens/home_screen_2.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';
import 'package:app/screens/profile_screens/profile_screen_new.dart';
import 'package:app/themes/dark_theme.dart';
import 'package:app/themes/light_theme.dart';
import 'package:app/themes/transitions/fade_page_builder.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final _router = GoRouter(
  initialLocation: '/events',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    // auth flow route
    GoRoute(
      path: '/auth',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginOrRegisterScreen();
      },
    ),
    // Shell for scaffold + bottom navbar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: <RouteBase>[
        /// first navbar screen
        GoRoute(
          path: '/user/:uid',
          builder: (context, state) => ProfileScreenNew(
            uid: state.pathParameters['uid'],
          ),
        ),

        GoRoute(
          path: '/profile',
          pageBuilder: fadePageBuilder(
            ProfileScreenNew(
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        ),

        GoRoute(
          path: '/events',
          pageBuilder: fadePageBuilder(const EventsScreen()),
        ),

        GoRoute(
          path: '/home',
          pageBuilder: fadePageBuilder(const HomeScreen()),
          routes: <RouteBase>[
            GoRoute(
              path: '2',
              pageBuilder: fadePageBuilder(const HomeScreen2()),
            ),
          ],
        ),

        GoRoute(
          path: '/leagues',
          pageBuilder: fadePageBuilder(const LeaguesScreen()),
        ),

        GoRoute(
          path: '/shop',
          pageBuilder: fadePageBuilder(const ShopScreen()),
        ),
      ],
    ),
  ],
  redirect: (BuildContext ctx, GoRouterState state) {
    final userAuthenticated = FirebaseAuth.instance.currentUser != null;
    final onAuthPage = state.matchedLocation.startsWith('/auth');
    if (!userAuthenticated && !onAuthPage) {
      return '/auth';
    } else if (userAuthenticated && onAuthPage) {
      return '/events';
    } else {
      return null;
    }
  },
);

class BetApp extends StatelessWidget {
  const BetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider(dotenv.env['RECAPTCHA_SITE_KEY']!),
    androidProvider: AndroidProvider.debug,
  );

  // when log out or log in, refresh the router to redirect to the correct page
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    _router.refresh();
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LeagueJoiningBloc>(
          create: (context) => LeagueJoiningBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ButtonStatesProvider>(
            create: (context) => ButtonStatesProvider(),
          ),
          Provider<GlobalKey<EventsScreenState>>(
            create: (_) => EventsScreenState.key,
          ),
          ChangeNotifierProvider(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: const BetApp(),
      ),
    ),
  );
}
