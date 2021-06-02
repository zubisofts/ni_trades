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
import 'package:ni_trades/repository/payment_repository.dart';

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
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SpinKitDualRing(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          lineWidth: 2,
                                          size: 50.0,
                                        ),
                                        Text(
                                          'Verifying account...',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (state is VerifyAccountFailureState) {
                                Navigator.of(context).pop();
                                showErrorDialog(state.error);
                              }

                              if (state is VerifyAccountSuccessfulState) {
                                Navigator.of(context).pop();
                                showContinueDialog(state.message);
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
      showErrorDialog("Please select bank");
    } else if (accountNumber.isEmpty) {
      showErrorDialog("Please enter an account number");
    } else {
      context
          .read<DataBloc>()
          .add(VerifyAccountDetialsEvent(accountNumber, bankCode));
    }
  }

  void showErrorDialog(String s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Error!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          s,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ))
        ],
      ),
    );
  }

  void showContinueDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                text: '$message',
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
              onPressed: () {
                Navigator.of(context).pop();
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
    );
  }
}

class AmountFormScreen extends StatefulWidget {
  final Function(String) onYieldValied;

  const AmountFormScreen({Key? key, required this.onYieldValied})
      : super(key: key);

  @override
  _AmountFormScreenState createState() => _AmountFormScreenState();
}

class _AmountFormScreenState extends State<AmountFormScreen> {
  late NumberFormat currencyFormatter;
  int balance = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "\u20A6",
    );
    context.read<DataBloc>().add(FetchUserWalletEvent(AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          SizedBox(
            height: 32.0,
          ),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              // controller: widget.dateTextController,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.date_range_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: 'Enter amount',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Amount is required';
                } else if (int.parse(value) > balance) {
                  return 'Balance is insuffient for the entered amount';
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // new LengthLimitingTextInputFormatter(5),
                // CardMonthInputFormatter()
              ],
              keyboardType: TextInputType.number,
              // maxLength: 5,
              onChanged: (value) {
                widget.onYieldValied(value);
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Text(
                'Current balance: ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              BlocBuilder<DataBloc, DataState>(
                buildWhen: (previous, current) =>
                    current is UserWalletFetchedState,
                builder: (context, state) {
                  if (state is UserWalletFetchedState) {
                    balance = state.wallet.balance;
                    return Text(
                      '${currencyFormatter.format(state.wallet.balance)}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    );
                  }
                  return Text(
                    '₦0.00',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BankSelectionScreen extends StatefulWidget {
  final Function(String, String) onYieldValue;

  BankSelectionScreen({required this.onYieldValue, required this.bankList});

  final List<Bank> bankList;

  @override
  _BankSelectionScreenState createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  String? selectedBank;
  late List<Bank> getBankList;
  String accountNumber = '';

  var accountNumberTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Text(
            'Account details',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  onChanged: (v) {
                    setState(() {
                      selectedBank = v;
                      widget.onYieldValue(v!, accountNumber);
                    });
                  },
                  // icon: Icon(Icons.home_filled),
                  value: selectedBank,
                  isExpanded: true,
                  hint: Text(
                    'Select your bank',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  items: widget.bankList
                      .map((bank) => DropdownMenuItem(
                          value: bank.code,
                          child: Text(
                            bank.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.onPrimary),
                          )))
                      .toList()),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: accountNumberTextController,
              onChanged: (value) {
                setState(() {
                  accountNumber = value;
                  widget.onYieldValue(selectedBank!, value);
                });
              },
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.payment,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: 'Account Number',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1),
                      borderRadius: BorderRadius.circular(8.0))),
              validator: MultiValidator([
                RequiredValidator(errorText: 'Account number is required'),
                MinLengthValidator(10, errorText: 'Invalid account number'),
              ]),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
