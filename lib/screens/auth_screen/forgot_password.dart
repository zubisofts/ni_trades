import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailTextController = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey();

  bool _formValidated = false;

  void _validate() {
    setState(() {
      _formValidated = _form.currentState!.validate();
      if (_formValidated) {
        _form.currentState!.save();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Forgot Password',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      )),
      body: Container(
        margin: EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
                'Please provide your email address below, we will send you a password reset link to reset your password.',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            SizedBox(
              height: 32.0,
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: _form,
              onChanged: () {
                Form.of(primaryFocus!.context!)!.save();
              },
              child: TextFormField(
                validator: MultiValidator([
                  RequiredValidator(errorText: "Yo must provide email address"),
                  EmailValidator(errorText: "Enter a valid email address")
                ]),
                onChanged: (v) {
                  _validate();
                },
                controller: emailTextController,
                cursorColor: Theme.of(context).colorScheme.onSecondary,
                decoration: const InputDecoration(
                    hintText: 'Email Address',
                    // labelText: 'Email Address',
                    filled: true,
                    fillColor: Color(0xFFdfe6e8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none)),
                onSaved: (value) {},
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  current is SendPasswordResetLinkFailureState ||
                  current is SendPasswordResetLinkLoadingState ||
                  current is PasswordResetLinkSentState,
              listener: (context, state) {
                if (state is SendPasswordResetLinkLoadingState) {
                  showSuccessDialog(context);
                }
                if (state is SendPasswordResetLinkFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(16.0),
                      content: Text('Unable to send OTP to the provided email.',
                          style: TextStyle(fontSize: 16.0))));
                }
                if (state is PasswordResetLinkSentState) {}
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return MaterialButton(
                      elevation: 1.0,
                      disabledColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).colorScheme.secondary,
                      child: state is SendPasswordResetLinkLoadingState
                          ? SpinKitCircle(
                              size: 23.0,
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text('Send',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                      onPressed: _formValidated &&
                              !(state is SendPasswordResetLinkLoadingState)
                          ? () async {
                              context.read<AuthBloc>().add(
                                  SendPasswordResetLink(
                                      emailTextController.text));
                            }
                          : null);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    AwesomeDialog(
        context: context,
        title: 'Success',
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Password reset reset link link has been sent to your email.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        btnOk: TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(LogoutUserEvent());
            Navigator.of(context)..pop()..pop();
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: Theme.of(context).colorScheme.secondary),
          child: Text('Dismiss'),
        )).show();
  }
}
