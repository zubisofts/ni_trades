import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/screens/auth_screen/login_screen.dart';
import 'package:ni_trades/screens/homescreen/homescreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: BlocConsumer<AuthBloc, AuthState>(
          buildWhen: (previous, current) => current is AuthUserChangedState,
          listener: (context, state) {
            if (state is AuthUserChangedState) {
              Future.delayed(Duration(seconds: 3)).then((value)  {
                if (state.status == AuthenticationStatus.authenticated) {
                debugPrint('User has logged in with the id: ${state.user?.uid}');
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   builder: (context) => HomeScreen(),
                // ));
              } else {
                debugPrint('User has logged out the id: ${state.user?.uid}');
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   builder: (context) => LoginScreen(),
                // ));
              }
              });

            }
          },
          builder: (context, state) {
            if(state is AuthUserChangedState){
              if (state.status == AuthenticationStatus.authenticated) {
                debugPrint('User has logged in with the id: ${state.user?.uid}');
                return HomeScreen();
            }else{
              return LoginScreen();
            }
          }
          return Image.asset('assets/images/wallet.png', width: 200.0);
        
          })
      ),
    );
  }
}
