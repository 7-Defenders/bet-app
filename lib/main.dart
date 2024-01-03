import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/firebase_options.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:app/scaffold_with_navbar.dart';
import 'package:app/screens/achievements_screen.dart';
import 'package:app/screens/auth_screens/login_or_register_screen.dart';
import 'package:app/screens/history_screen.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/league_screens/league_creator.dart';
import 'package:app/screens/navbar_screens/league_screens/league_summary.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/profile_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';
import 'package:app/themes/dark_theme.dart';
import 'package:app/themes/light_theme.dart';
import 'package:app/themes/transitions/fade_page_builder.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  routes: <RouteBase> [
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
          path: '/profile',
          pageBuilder: fadePageBuilder(const ProfileScreen()),
          routes: <RouteBase>[
            // The history screen to display stacked on the inner Navigator.
            // This will cover profile screen but not the application shell.
            GoRoute(
              path: 'history',
              // builder: (BuildContext context, GoRouterState state) {
              //   return HistoryScreen();
              // },
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: HistoryScreen(),
                  transitionDuration: const Duration(milliseconds: 301),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
                      MaterialPageRoute(builder: (context) => Container()),
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
                );
              },
            ),
            /// Same as "/profile/history", but displayed on the root Navigator
            /// by specifying [parentNavigatorKey]. This will cover both events
            /// screen and the application shell.
            GoRoute(
              path: 'achievements',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (BuildContext context, GoRouterState state) {
                return const AchievementsScreen();
              },
            ),
          ],
        ),

        /// second navbar screen
        GoRoute(
          path: '/events',
          pageBuilder: fadePageBuilder(const EventsScreen()),
        ),

        /// third navbar screen
        GoRoute(
          path: '/leagues',
          pageBuilder: fadePageBuilder(const LeaguesScreen()),
          routes: <RouteBase>[
            // The history screen to display stacked on the inner Navigator.
            // This will cover profile screen but not the application shell.
            GoRoute(
              path: 'creator',
              // builder: (BuildContext context, GoRouterState state) {
              //   return HistoryScreen();
              // },
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const LeagueCreator(),
                  transitionDuration: const Duration(milliseconds: 301),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
                      MaterialPageRoute(builder: (context) => Container()),
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'summary',
              // builder: (BuildContext context, GoRouterState state) {
              //   return HistoryScreen();
              // },
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: LeagueSummary(leagueID: state.extra! as String,),
                  transitionDuration: const Duration(milliseconds: 301),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
                      MaterialPageRoute(builder: (context) => Container()),
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
                );
              },
              routes: <RouteBase>[
                // The history screen to display stacked on the inner Navigator.
                // This will cover profile screen but not the application shell.
                GoRoute(
                  path: 'history',
                  // builder: (BuildContext context, GoRouterState state) {
                  //   return HistoryScreen();
                  // },
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: HistoryScreen(userID: state.extra! as String,),
                      transitionDuration: const Duration(milliseconds: 301),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
                          MaterialPageRoute(builder: (context) => Container()),
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            /// Same as "/profile/history", but displayed on the root Navigator
            /// by specifying [parentNavigatorKey]. This will cover both events
            /// screen and the application shell.
          ],
        ),

        /// fourth navbar screen
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
        ],
        child: const BetApp(),
      ),
    ),
  );
}
