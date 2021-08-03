import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/bank.dart';
import 'package:ni_trades/model/withdraw_request.dart';
import 'package:ni_trades/repository/payment_repository.dart';
import 'package:ni_trades/screens/withdrawal/widgets/amount_selection_widget.dart';
import 'package:ni_trades/screens/withdrawal/widgets/bank_selection_widget.dart';
import 'package:ni_trades/util/my_utils.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  int currentPage = 0;
  List<Bank> bankList = [];
  String amount = '';
  String bankCode = '';
  String accountNumber = '';

  late PageController pageController;
  Future<bool> _willPopScope() async {
    if (currentPage == 1) {
      pageController.jumpToPage(0);
      return false;
    } else {
      return true;
    }
  }

  Future setBankList() async {
    var list = await PaymentRepository().getBankList;
    setState(() {
      bankList = list;
    });
  }

  @override
  void initState() {
    setBankList();
    pageController = PageController(initialPage: currentPage, keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
      body: WillPopScope(
        onWillPop: _willPopScope,
        child: Container(
          child: Stack(
            children: [
              FractionallySizedBox(
                heightFactor: 0.3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.15)),
                  child: Container(
                    // padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      // borderRadius: BorderRadius.only(
                      //   bottomLeft: Radius.circular(16.0),
                      //   bottomRight: Radius.circular(16.0),
                      // )
                    ),
                    child: Stack(
                      children: [
                        SvgPicture.asset('assets/images/credit_card.svg'),
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16.0),
                            color: Colors.black.withOpacity(0.8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Withdrawal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                // SizedBox(
                                //   height: 4.0,
                                // ),
                                Text(
                                  'Withdraw money into your bank account.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: pageController,
                            onPageChanged: (value) {
                              setState(() {
                                currentPage = value;
                              });
                            },
                            children: [
                              AmountFormScreen(
                                onYieldValied: (value) {
                                  setState(() {
                                    amount = value;
                                  });
                                },
                              ),
                              BankSelectionScreen(
                                bankList: bankList,
                                onYieldValue: (code, number) {
                                  setState(() {
                                    bankCode = code;
                                    accountNumber = number;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BlocConsumer<DataBloc, DataState>(
                            buildWhen: (previous, current) =>
                                current is VerifyAccountLoadingState ||
                                current is VerifyAccountFailureState ||
                                current is VerifyAccountSuccessfulState,
                            listener: (context, state) {
                              if (state is VerifyAccountLoadingState) {
                                AppUtils.showLoaderDialog(
                                    context, "Verifying account...");
                              }

                              if (state is VerifyAccountFailureState) {
                                Navigator.of(context).pop();
                                AppUtils.showErrorDialog(context, state.error);
                              }

                              if (state is VerifyAccountSuccessfulState) {
                                Navigator.of(context).pop();

                                showContinueDialog(context, amount,
                                    accountNumber, bankCode, state.message);
                              }

                              if (state is WithdrawalRequestLoadingState) {
                                AppUtils.showLoaderDialog(
                                    context, "Sending request...");
                              }

                              if (state is WithdrawalRequestErrorState) {
                                Navigator.of(context).pop();
                                AppUtils.showErrorDialog(context, state.error);
                              }

                              if (state is WithdrawalRequestSentState) {
                                Navigator.of(context).pop();
                                AppUtils.showSuccessDialog(
                                    context, state.message);
                              }
                            },
                            builder: (context, state) {
                              return MaterialButton(
                                padding: EdgeInsets.all(16.0),
                                disabledColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.3),
                                onPressed: amount.isNotEmpty
                                    ? () {
                                        if (currentPage == 0) {
                                          pageController.jumpToPage(1);
                                        } else {
                                          trySendRequest(
                                              amount, accountNumber, bankCode);
                                        }
                                      }
                                    : null,
                                color: Theme.of(context).colorScheme.secondary,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                                child: Text('Continue'),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> trySendRequest(
      String amount, String accountNumber, String bankCode) async {
    if (bankCode.isEmpty) {
      AppUtils.showErrorDialog(context, "Please select bank");
    } else if (accountNumber.isEmpty) {
      AppUtils.showErrorDialog(context, "Please enter an account number");
    } else {
      context
          .read<DataBloc>()
          .add(VerifyAccountDetialsEvent(accountNumber, bankCode));
    }
  }

  void showContinueDialog(BuildContext context, String amount,
      String accountNumber, String bankCode, String name) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Confirm',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green),
          ),
          content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Confirm if ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16.0,
                      fontFamily: 'Poppins-Medium'),
                ),
                TextSpan(
                  text: '$name',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: 'Poppins-Medium'),
                ),
                TextSpan(
                  text: ' matches your account information...',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16.0,
                      fontFamily: 'Poppins-Medium'),
                )
              ])),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  var withdrawRequest = WithdrawRequest(
                      id: '',
                      accountName: name,
                      amount: amount,
                      accountNumber: accountNumber,
                      bankCode: bankCode,
                      userId: AuthBloc.uid!,
                      status: WithdrawalStatus.Pending,
                      timestamp: 0);
                  context
                      .read<DataBloc>()
                      .add(WithdrawalRequestEvent(withdrawRequest));
                },
                child: Text(
                  'Continue',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ))
          ],
        ),
      ),
    );
  }
}
