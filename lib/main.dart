import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                  authService: _authService,
                )),
        BlocProvider<DataBloc>(
            create: (context) => DataBloc(
                  dataService: _dataService,
                )),
      ],
      child: MaterialApp(
        title: 'NI Trades',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
