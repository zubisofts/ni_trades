import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/screens/auth_screen/login_screen.dart';
import 'package:ni_trades/screens/homescreen/homescreen.dart';

import 'blocs/bloc/auth_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is AuthUserChangedState,
      listener: (context, state) {
        if (state is AuthUserChangedState) {
          print('Status:${state.status}');
        }
      },
      builder: (context, state) {
        if (state is AuthUserChangedState) {
          if (state.status == AuthenticationStatus.authenticated) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
        return SpinKitThreeBounce(
          color: Theme.of(context).colorScheme.secondary,
        );
      },
    );
  }
}
