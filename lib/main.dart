import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ni_trades/blocs/app/app_bloc.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/repository/auth_repo.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/screens/intro/SplashScreen.dart';
import 'package:ni_trades/util/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  // Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService _authService = AuthService();
  DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    // AppTheme.isFirstTimeUser.then((isFirstTimeUser) {
    //   if (isFirstTimeUser) {
    //     AppTheme.setThemeValue(false);
    //   }
    // });

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc(),
        ),
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                  authService: _authService,
                )),
        BlocProvider<DataBloc>(
            create: (context) => DataBloc(
                  dataService: _dataService,
                )),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) => current is ThemeRetrievedState,
        builder: (context, state) {
          bool isDarkTheme = false;
          if (state is ThemeRetrievedState) {
            isDarkTheme = state.isDarkTheme;
          }
          return MaterialApp(
            title: 'NI Trades',
            debugShowCheckedModeBanner: false,
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.dark,
            home: App(),
          );
        },
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    context.read<AppBloc>().add(GetThemeEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return SplashScreen();
  }
}
