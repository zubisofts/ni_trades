import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/repository/payment_repository.dart';
import 'package:ni_trades/screens/homescreen/dashboard.dart';
import 'package:ni_trades/screens/homescreen/widgets/balance_widget.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/screens/payment/widgets/checkout_widget.dart';
import 'package:ni_trades/screens/transactions/widgets/transaction_item_widget.dart';
import 'package:ni_trades/screens/transactions/widgets/transactions_list_widget.dart';
import 'package:ni_trades/screens/withdrawal/withdrawal_screen.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:ni_trades/util/my_utils.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchUserWalletEvent(AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadiusDirectional.circular(16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Balance',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              BlocBuilder<DataBloc, DataState>(
                buildWhen: (previous, current) =>
                    current is UserWalletFetchedState,
                builder: (context, state) {
                  if (state is UserWalletFetchedState) {
                    return BalanceWidget(
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        balance: state.wallet.balance);
                  }
                  return BalanceWidget(
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      balance: 0);
                },
              ),
              SizedBox(height: 32.0),
              Container(
                child: ActionsRow(),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Wallet Transactions',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        Expanded(
          child: Container(
            // padding: EdgeInsets.only(bottom: 80),
            child: TransactionsWidget(),
          ),
        ),
        // SizedBox(
        //   height: 70,
        // )
      ],
    );
  }
}

class ActionsRow extends StatelessWidget {
  final amountTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: BlocConsumer<DataBloc, DataState>(
          listenWhen: (previous, current) =>
              current is WalletFundSuccessfulState ||
              current is WalletFundFailureState ||
              current is WalletFundLoadingState,
          listener: (context, state) {
            if (state is WalletFundSuccessfulState) {
              AppUtils.showFundSuccessDialog(context);
            }

            if (State is WalletFundFailureState) {
              AppUtils.showFundFailureDialog(context);
            }

            if (state is WalletFundLoadingState) {
              AppUtils.showFundLoadingDialog(context);
            }
          },
          builder: (context, state) {
            return MaterialButton(
                // height: MediaQuery.of(context).size.width * 0.6,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: Theme.of(context).iconTheme.color!),
                    borderRadius: BorderRadius.circular(4.0)),
                elevation: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Fund",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.7),
                            // fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10.0,
                              sigmaY: 10.0,
                            ),
                            child: AlertDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: Text('Wallet Fund Amount'),
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'How much do you want to fund (\u20A6)',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                    SizedBox(height: 8.0),
                                    TextFormField(
                                      controller: amountTextController,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.payment,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          hintText: 'Amount',
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                          fillColor:
                                              Theme.of(context).cardColor,
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.0))),
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText: 'Amount is required'),
                                        MinLengthValidator(3,
                                            errorText:
                                                'Fund amount must start from \2UA6100'),
                                      ]),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context) => CheckoutWidget(
                                          paymentType: PaymentType.FUND,
                                          fundAmount: int.parse(
                                              amountTextController.text)),
                                    );
                                  },
                                  disabledColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.4),
                                  minWidth: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ));
                });
          },
        )),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
            child: MaterialButton(
                // height: MediaQuery.of(context).size.width * 0.6,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: Theme.of(context).iconTheme.color!),
                    borderRadius: BorderRadius.circular(4.0)),
                elevation: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wallet_giftcard_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Withdraw",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.7),
                            // fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  // var response = await PaymentRepository().makeTransfer(
                  //     name: "ANYANWU GODSWILL NZUBECHI",
                  //     accountNumber: "2112037132",
                  //     bankCode: "033",
                  //     amount: "10000");
                  // print(response.data);

                  makeWidthdrawal(context);
                }))
      ],
    );
  }

  void makeWidthdrawal(BuildContext context) async {
    // var response = await PaymentRepository().getBankList;
    // print('Bank List:$response');

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WithdrawalScreen(),
    ));
  }
}
