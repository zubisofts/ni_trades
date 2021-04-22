import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/screens/transactions/widgets/transaction_item_widget.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    context.read<DataBloc>().add(LoadTransactionsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 75.0,
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Transactions',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        BlocBuilder<DataBloc, DataState>(
          buildWhen: (previous, current) =>
              current is TransactionsLoadedState ||
              current is TransactionsLoadingState ||
              current is TransactionsLoadErrorState,
          builder: (context, state) {
            if (state is TransactionsLoadedState) {
              var transactions = state.transactions;
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
                      'You have not made any transactions yet',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
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
        )
      ],
    );
  }
}
