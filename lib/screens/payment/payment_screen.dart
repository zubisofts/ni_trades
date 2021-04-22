import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/screens/homescreen/dashboard.dart';
import 'package:ni_trades/screens/homescreen/widgets/balance_widget.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/screens/transactions/widgets/transaction_item_widget.dart';

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
              color: Theme.of(context).cardTheme.color,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Wallet Transactions',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              TransactionsWidget()
            ],
          ),
        )
      ],
    );
  }
}

class ActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: MaterialButton(
                // height: MediaQuery.of(context).size.width * 0.6,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Colors.white.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 16),
                      Text(
                        "Fund",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.7),
                            // fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InvestmentSelectionScreen(),
                  ));
                })),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
            child: MaterialButton(
                // height: MediaQuery.of(context).size.width * 0.6,
                color: Colors.white.withOpacity(0.4),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.wallet_giftcard_outlined),
                      SizedBox(width: 16),
                      Text(
                        "Withdraw",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.7),
                            // fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InvestmentSelectionScreen(),
                  ));
                }))
      ],
    );
  }
}

class TransactionsWidget extends StatefulWidget {
  @override
  _TransactionsWidgetState createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  @override
  void initState() {
    context.read<DataBloc>().add(LoadTransactionsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      buildWhen: (previous, current) =>
          current is TransactionsLoadedState ||
          current is TransactionsLoadingState ||
          current is TransactionsLoadErrorState,
      builder: (context, state) {
        if (state is TransactionsLoadedState) {
          var transactions = state.transactions
              .where((element) =>
                  element.type == "Fund" || element.type == "Withdraw")
              .toList();
          if (transactions.isNotEmpty) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItemWidget(
                      transaction: transactions[index]);
                },
              ),
            );
          } else {
            return Expanded(
              child: Center(
                child: Text(
                  'You have not made any wallet transactions yet',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            );
          }
        }

        if (state is TransactionsLoadingState) {
          return Expanded(
            child: Center(
              child: Platform.isIOS
                  ? SpinKitCircle(
                      size: 32,
                      color: Colors.blueGrey,
                    )
                  : SpinKitChasingDots(
                      color: Colors.blue,
                      size: 32,
                    ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
