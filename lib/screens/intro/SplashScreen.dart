import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/screens/auth_screen/login_screen.dart';
import 'package:ni_trades/screens/homescreen/homescreen.dart';
import 'package:ni_trades/screens/intro/onboarding_screen.dart';
import 'package:ni_trades/theme/app_theme.dart';
import 'package:ni_trades/theme/app_theme.dart';
import 'package:ni_trades/wrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      AppTheme.isFirstTimeUser.then((isFirstTimeUser) {
        if (isFirstTimeUser) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Wrapper(),
              ));              
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Wrapper(),
          ));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white));
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
              child: Entry(
                  scale: 1,
                  curve: Curves.bounceInOut,
                  duration: Duration(milliseconds: 500),
                  child: Image.asset('assets/images/ni_trade_logo2.png',
                      width: 300.0)))),
    );
  }
}
