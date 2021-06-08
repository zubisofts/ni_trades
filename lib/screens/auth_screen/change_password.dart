import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  TextEditingController oldPasswordTextController = TextEditingController();

  TextEditingController newPasswordTextController = TextEditingController();

  TextEditingController confirmPasswordTextController = TextEditingController();

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
        title: Text('Change Password',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Shortcuts(
                  shortcuts: <LogicalKeySet, Intent>{
                    // Pressing space in the field will now move to the next field.
                    LogicalKeySet(LogicalKeyboardKey.enter):
                        const NextFocusIntent(),
                  },
                  child: FocusTraversalGroup(
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _form,
                      onChanged: () {
                        // Form.of(primaryFocus.context)!.save();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.length < 5) {
                                return 'Password must be at 5 characters long';
                              }
                              return null;
                            },
                            onChanged: (v) {
                              _validate();
                            },
                            controller: oldPasswordTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'Old password',
                                // labelText: 'Password',
                                filled: true,
                                fillColor: Color(0xFFdfe6e8),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none)),
                            onSaved: (value) {},
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.length < 5) {
                                return 'Password must be at 5 characters long';
                              }
                              return null;
                            },
                            onChanged: (v) {
                              _validate();
                            },
                            controller: newPasswordTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'New password',
                                // labelText: 'Password',
                                filled: true,
                                fillColor: Color(0xFFdfe6e8),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none)),
                            onSaved: (value) {},
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value != newPasswordTextController.text) {
                                return 'Password mismatch';
                              }
                              return null;
                            },
                            onChanged: (v) {
                              _validate();
                            },
                            controller: confirmPasswordTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'Confirm new password',
                                // labelText: 'Password',
                                filled: true,
                                fillColor: Color(0xFFdfe6e8),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none)),
                            onSaved: (value) {},
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is ChangePasswordLoadingState) {
                                print('Changing password Loading...');
                              }
                              if (state is PasswordChangeErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(16.0),
                                        content: Text('${state.error}',
                                            style: TextStyle(fontSize: 16.0))));
                              }
                              if (state is PasswordChangedState) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(16.0),
                                        content: Text(
                                            'Password updated successfully',
                                            style: TextStyle(fontSize: 16.0))));
                              }
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
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    child: state is ChangePasswordLoadingState
                                        ? SpinKitCircle(
                                            size: 23.0,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Text('Save',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                          ),
                                    onPressed: _formValidated &&
                                            !(state
                                                is ChangePasswordLoadingState)
                                        ? () async {
                                            context.read<AuthBloc>().add(
                                                ChangePasswordEvent(
                                                    newPassword:
                                                        newPasswordTextController
                                                            .text,
                                                    oldPassword:
                                                        oldPasswordTextController
                                                            .text));
                                          }
                                        : null);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
