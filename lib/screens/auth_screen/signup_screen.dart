import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/model/user_model.dart';
import 'package:ni_trades/util/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController fnameTextController = TextEditingController();
  TextEditingController lnameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(32.0),
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // SvgPicture.asset('assets/images/mobile_login.svg',
              //     color: Theme.of(context).colorScheme.secondary,
              //     colorBlendMode: BlendMode.modulate,
              //     width: 200,
              //     semanticsLabel: 'A red up arrow'),
              SizedBox(height: 16.0),
              Text("Let's get started",
                  style:
                      TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text('Create an account to NI Trade to get started',
                  style: TextStyle(fontSize: 14.0, color: Colors.black45)),
              SizedBox(height: 32.0),
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
                        Form.of(primaryFocus!.context!)!.save();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'This field is required'),
                            onChanged: (v) {
                              // _validate();
                            },
                            keyboardType: TextInputType.name,
                            controller: fnameTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(fontSize: 18.0),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    labelText: 'First Name',
                                    prefixIcon: Icon(Icons.person,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'This field is required'),
                            onChanged: (v) {
                              // _validate();
                            },
                            keyboardType: TextInputType.name,
                            controller: lnameTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(fontSize: 18.0),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    labelText: 'Last Name',
                                    prefixIcon: Icon(Icons.person,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: EmailValidator(
                                errorText: "Please enter a valid email"),
                            onChanged: (v) {
                              // _validate();
                            },
                            controller: emailTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(fontSize: 18.0),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    labelText: 'Email Address',
                                    prefixIcon: Icon(Icons.email,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            // validator:
                            //     LYDPhoneValidator(errorText: "Please enter a valid phone number"),
                            onChanged: (v) {
                              _validate();
                            },
                            keyboardType: TextInputType.phone,
                            controller: phoneTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(fontSize: 18.0),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    labelText: 'Phone Number',
                                    prefixIcon: Icon(Icons.phone,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'password is required'),
                              MinLengthValidator(5,
                                  errorText:
                                      'Password must be at least 5 digits long'),
                              PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                  errorText:
                                      'Passwords must have at least one special character')
                            ]),
                            onChanged: (v) {
                              // _validate();
                            },
                            style: TextStyle(fontSize: 18.0),
                            controller: passwordTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            obscureText: true,
                            cursorHeight: 24.0,
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is SignupUserErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${state.error}')));
                              }

                              if (state is UserSignedUpState) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Your account has been created successfully')));
                              }
                            },
                            builder: (context, state) {
                              return MaterialButton(
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  // Theme.of(context).colorScheme.secondary,
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                          SignUpEvent(
                                              user: User(
                                                  id: "",
                                                  firstName:
                                                      fnameTextController.text,
                                                  lastName:
                                                      lnameTextController.text,
                                                  email:
                                                      emailTextController.text,
                                                  phoneNumber:
                                                      phoneTextController.text,
                                                  createdAt: DateTime.now()
                                                      .millisecondsSinceEpoch,
                                                  updatedAt: DateTime.now()
                                                      .millisecondsSinceEpoch),
                                              password:
                                                  passwordTextController.text),
                                        );
                                  },
                                  child: Text('Create Account',
                                      style: TextStyle(color: Colors.white)));
                            },
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Already have an account? Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            ],
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
