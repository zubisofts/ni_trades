import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/screens/auth_screen/login_screen.dart';
import 'package:ni_trades/screens/auth_screen/signup_screen.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:ni_trades/util/my_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  var emailTextController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary),
                  child: Center(
                    child: Image.asset(
                      'assets/images/ni_trade_logo_trans.png',
                      width: 300,
                      color: Colors.white,
                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.all(32.0),
              color: Colors.white,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Let us get your money to work for you',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 22.0),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: TextFormField(
                            validator: EmailValidator(
                                errorText: "Please enter a valid email"),
                            onChanged: (v) {},
                            controller: emailTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(color: Colors.blueGrey),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'Enter your email address',
                                    prefixIcon: Icon(Icons.email,
                                        color: Colors.blueGrey)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listenWhen: (previous, current) =>
                        current is OTPSentState ||
                        current is SendOTPErrorState ||
                        current is SendOTPLoadingState,
                    listener: (context, state) {
                      if (state is SendOTPErrorState) {
                        Navigator.pop(context);
                        AppUtils.showErrorDialog(context, state.error);
                      }

                      if (state is SendOTPLoadingState) {
                        AppUtils.showLoaderDialog(context,
                            'Sending OTP to ${emailTextController.text}');
                      }

                      if (state is OTPSentState) {
                        Navigator.pop(context);
                        showOTPVerifyDialog(
                            context, state.message, emailTextController.text);
                      }
                    },
                    child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        elevation: 1.0,
                        disabledColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 18.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Theme.of(context).colorScheme.secondary,
                        // Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<AuthBloc>()
                                .add(SendOTPEvent(emailTextController.text));
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Get Started',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )
                            ])),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                            child: LoginScreen(),
                            type: PageTransitionType.leftToRight,
                          ));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Already got an account? ',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 16.0)),
                            TextSpan(
                                text: 'Sign in here',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)..pop();
                                  },
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16.0)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showOTPVerifyDialog(
      BuildContext context, String message, String email) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm OTP',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        content: ConfirmOTPScreen(email: email),
      ),
    );
  }
}

class ConfirmOTPScreen extends StatefulWidget {
  final String email;

  ConfirmOTPScreen({Key? key, required this.email});

  @override
  _ConfirmOTPScreenState createState() => _ConfirmOTPScreenState();
}

class _ConfirmOTPScreenState extends State<ConfirmOTPScreen> {
  final otpTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is OTPVerifiedState ||
            current is VerifyOTPLoadingState ||
            current is VerifyOTPErrorState,
        listener: (context, state) async {
          if (state is OTPVerifiedState) {
            // Navigator.of(context)..pop();
            // Navigator.of(context).pop();
            // await Future.delayed(Duration(seconds: 1));

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => SignupScreen(email: widget.email),
                ),
                (route) => false);
          }

          if (state is VerifyOTPLoadingState) {
            AppUtils.showLoaderDialog(context, "Verifying OTP");
          }

          if (state is VerifyOTPErrorState) {
            Navigator.of(context).pop();
            AppUtils.showErrorDialog(context, state.error);
          }
        },
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Check your email, an OTP has been sent to you. Please provide it below to continue.',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 6) {
                        return "Input the Otp digits to verify";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: Colors.green,
                        inactiveColor: Theme.of(context).colorScheme.secondary,
                        selectedColor: Colors.red),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    // enableActiveFill: true,
                    // errorAnimationController: errorController,
                    controller: otpTextController,
                    keyboardType: TextInputType.number,
                    // boxShadows: [
                    //   BoxShadow(
                    //     offset: Offset(0, 1),
                    //     color: Colors.black12,
                    //     blurRadius: 10,
                    //   )
                    // ],
                    onCompleted: (pin) {
                      print('Completed');
                      context
                          .read<AuthBloc>()
                          .add(VerifyOTPEvent(pin, widget.email));
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      // print(value);
                      // setState(() {
                      //   currentText = value;
                      // });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste ");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
