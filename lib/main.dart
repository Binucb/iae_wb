import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wm_iae/provider.dart';
import 'package:wm_iae/screens/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

import 'models/maindb.dart';
import 'screens/dashboard_screen.dart';
import 'screens/error_screen.dart';
import 'screens/login_screen.dart';

late Box<String> configDB;
late Box<MainDB> mainDB;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MainDBAdapter());

  configDB = await Hive.openBox<String>('configDB');
  mainDB = await Hive.openBox<MainDB>('mainDB');
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  runApp((MultiProvider(providers: [
    ChangeNotifierProvider<BackEndData>(create: (_) => BackEndData()),
    ChangeNotifierProvider<DBProvider>(create: (_) => DBProvider()),
    ChangeNotifierProvider<DBService>(create: (_) => DBService()),
    ChangeNotifierProvider<TempProvider>(create: (_) => TempProvider()),
    ChangeNotifierProvider<CustomTimerClass>(create: (_) => CustomTimerClass()),
  ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
        redirect: (state) {
          // print("I am called");
          final loggedin = (configDB.get("lStatus") != null) ? true : false;

          final isLogging = state.location == '/login';
          if (!loggedin && !isLogging) return '/login';
          if (loggedin && isLogging) {
            var tm = Provider.of<CustomTimerClass>(context, listen: false);
            tm.stopTimer();
            return '/';
          }

          return null;
        },
        routes: [
          GoRoute(
            name: 'login',
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
              name: 'home',
              path: '/',
              builder: (context, state) => const DashBoardWidget(),
              routes: [
                GoRoute(
                    name: 'item',
                    path: ':itemid',
                    builder: (context, state) {
                      final item = mainDB.get(state.params['itemid']);
                      return MyHomePage(item: item!);
                    })
              ]),
        ],
        errorBuilder: (context, state) =>
            ErrorScreen(er: state.error.toString()));

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'WorkBench',
      theme: ThemeData.light(),
      // home: (lStatus == "") ? const LoginScreen() : const DashBoardWidget(),
    );
  }
}
