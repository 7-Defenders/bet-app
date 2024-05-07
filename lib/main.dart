import 'dart:async';

import 'package:app/globals.dart';
import 'package:app/other/firebase_options.dart';
import 'package:app/other/scaffold_with_navbar.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:app/screens/auth_screens/login_or_register_screen.dart';
import 'package:app/screens/history_screen.dart';
import 'package:app/screens/loading_screen.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/home_screens/home_screen.dart';
import 'package:app/screens/navbar_screens/home_screens/home_screen_2.dart';
import 'package:app/screens/navbar_screens/league_screens/league_creator.dart';
import 'package:app/screens/navbar_screens/league_screens/league_summary.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';
import 'package:app/screens/profile_screens/achievements_screen.dart';
import 'package:app/screens/profile_screens/cosmetics.dart';
import 'package:app/screens/profile_screens/profile_screen_new.dart';
import 'package:app/screens/profile_screens/profile_settings_screen.dart';
import 'package:app/screens/profile_screens/settings_screen.dart';
import 'package:app/themes/dark_theme.dart';
import 'package:app/themes/light_theme.dart';
import 'package:app/themes/transitions/fade_page_builder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
      // builder: (BuildContext context, GoRouterState state) {
      // return const LoginOrRegisterScreen();
      // },
      pageBuilder: fadePageBuilder(
        (context, state, uid) => const LoginOrRegisterScreen(),
        null,
      ),
    ),
    GoRoute(
      path: '/loading',
      pageBuilder: fadePageBuilder(
        (context, state, _) => const LoadingScreen(),
        null,
      ),
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
        //TODO: there might be no need for both /user/:uid and /profile
        GoRoute(
          path: '/profile',
          pageBuilder: fadePageBuilder(
            (context, state, uid) => ProfileScreenNew(
              uid: Provider.of<UserDataProvider>(context, listen: false)
                  .userData!
                  .uid,
            ),
            null,
          ),
          // builder: (BuildContext context, GoRouterState state) {
          //   return ProfileScreenNew(
          //     uid: Provider.of<UserDataProvider>(context, listen: false)
          //         .userData!
          //         .uid,
          //   );
          // },
          routes: <RouteBase>[
            GoRoute(
              path: 'settings',
              pageBuilder: fadePageBuilder(
                (context, state, _) => const SettingsScreen(),
                null,
              ),
            ),
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
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder()
                        .buildTransitions(
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
              path: 'profile_settings',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfileSettingsScreen(),
                  transitionDuration: const Duration(milliseconds: 301),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder()
                        .buildTransitions(
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
              path: 'cosmetics',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CosmeticsScreen(),
                  transitionDuration: const Duration(milliseconds: 301),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder()
                        .buildTransitions(
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
              pageBuilder: fadePageBuilder(
                (context, state, _) => const AchievementsScreen(),
                null,
              ),
            ),
          ],
        ),

        GoRoute(
          path: '/events',
          pageBuilder: fadePageBuilder(
            (context, state, _) => const EventsScreen(),
            null,
          ),
        ),

        GoRoute(
          path: '/home',
          pageBuilder: fadePageBuilder(
            (context, state, _) => const HomeScreen(),
            null,
          ),
          routes: <RouteBase>[
            GoRoute(
              path: '2',
              pageBuilder: fadePageBuilder(
                (context, state, _) => const HomeScreen2(),
                null,
              ),
            ),
          ],
        ),

        GoRoute(
          path: '/leagues',
          pageBuilder: fadePageBuilder(
            (context, state, _) => const LeaguesScreen(),
            null,
          ),
          routes: <RouteBase>[
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
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder()
                        .buildTransitions(
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
                  child: LeagueSummary(
                    leagueID: state.extra! as String,
                  ),
                  transitionDuration: const Duration(milliseconds: 301),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder()
                        .buildTransitions(
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
                      child: HistoryScreen(
                        userID: state.extra! as String,
                      ),
                      transitionDuration: const Duration(milliseconds: 301),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return const FadeUpwardsPageTransitionsBuilder()
                            .buildTransitions(
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
            GoRoute(
              path: 'achievements',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (BuildContext context, GoRouterState state) {
                return const AchievementsScreen();
              },
            ),
          ],
        ),

        GoRoute(
          path: '/events',
          pageBuilder: fadePageBuilder(
              (context, state, _) => const EventsScreen(), null),
        ),

        GoRoute(
          path: '/home',
          pageBuilder:
              fadePageBuilder((context, state, _) => const HomeScreen(), null),
          routes: <RouteBase>[
            GoRoute(
              path: '2',
              pageBuilder: fadePageBuilder(
                  (context, state, _) => const HomeScreen2(), null),
            ),
          ],
        ),

        GoRoute(
          path: '/shop',
          pageBuilder:
              fadePageBuilder((context, state, _) => const ShopScreen(), null),
        ),
      ],
    ),
  ],
  redirect: (BuildContext ctx, GoRouterState state) {
    final bool userAuthenticated = FirebaseAuth.instance.currentUser != null;
    final bool userDataExists =
        Provider.of<UserDataProvider>(ctx, listen: false).userData != null;
    final bool onAuthPage = state.matchedLocation.startsWith('/auth');
    if (!userAuthenticated && !onAuthPage) {
      return '/auth';
    } else if ((userAuthenticated && onAuthPage) ||
        (!userDataExists && userAuthenticated && !onAuthPage)) {
      // log in authenticated user; if logged in and no user data, show loading screen
      return '/loading';
    } else {
      return null;
    }
  },
);

class BetApp extends StatelessWidget {
  BetApp({super.key});

  final connectivity = Connectivity();

  Future<bool> isConnected() async {
    return await connectivity.checkConnectivity() != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: cancel_subscriptions
    final StreamSubscription<ConnectivityResult> connectivityPlus =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (ConnectivityResult.none == result) {
        showDialog(
          context: context,
          builder: (ctx) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                icon: const Icon(Icons.wifi_off_rounded),
                title: const Text("No internet connection"),
                content:
                    const Text("Make sure you are connected to the internet"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (await isConnected()) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: Container(
                      color: Colors.green,
                      padding: const EdgeInsets.all(14),
                      child: const Text("Retry"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    });

    return Consumer<ThemeModeProvider>(
      builder: (context, themeModeProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: themeModeProvider.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Globals.loadData();
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

  // runApp(
  //   MultiBlocProvider(
  //     providers: [
  //       // BlocProvider(
  //       //   create: (context) => NetworkBloc()..add(NetworkObserve()),
  //       //   // child: const Home(),
  //       //   child: BlocBuilder<NetworkBloc, NetworkState>(
  //       //   builder: (context, state) {
  //       //     if (state is NetworkFailure) {
  //       //       return const Text("No Internet Connection");
  //       //     } else if (state is NetworkSuccess) {
  //       //       return const Text("You're Connected to Internet");
  //       //     } else {
  //       //       return const SizedBox.shrink();
  //       //     }
  //       //   },
  //       // ),
  //       // ),
  //     ],
  //     child: MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider<ButtonStatesProvider>(
  //           create: (context) => ButtonStatesProvider(),
  //         ),
  //         Provider<GlobalKey<EventsScreenState>>(
  //           create: (_) => EventsScreenState.key,
  //         ),
  //         ChangeNotifierProvider(
  //           create: (context) => UserDataProvider(),
  //         ),
  //         ChangeNotifierProvider(
  //           create: (context) => ThemeModeProvider(),
  //         ),
  //       ],
  //       child: MaterialApp(
  //         home: BetApp(),
  //       ),
  //     ),
  //   ),
  // );

  runApp(
    MultiProvider(
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
        ChangeNotifierProvider(
          create: (context) => ThemeModeProvider(),
        ),
      ],
      child: MaterialApp(
        home: BetApp(),
      ),
    ),
  );
}
