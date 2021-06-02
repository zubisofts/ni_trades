import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
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
          height: 50.0,
        ),
        Container(
          padding:
              EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
        Expanded(
          child: Container(
            child: BlocBuilder<DataBloc, DataState>(
              buildWhen: (previous, current) =>
                  current is TransactionsLoadedState ||
                  current is TransactionsLoadingState ||
                  current is TransactionsLoadErrorState,
              builder: (context, state) {
                if (state is TransactionsLoadedState) {
                  var transactions = state.transactions;
                  if (transactions.isNotEmpty) {
                    return Container(
                      padding: EdgeInsets.only(
                        right: 16.0,
                        left: 16.0,
                        top: 16.0,
                      ),
                      child: ListView.builder(
                        primary: false,
                        padding: EdgeInsets.only(bottom: 60.0),
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
                    return Center(
                      child: Text(
                        'You have not made any transactions yet',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    );
                  }
                }

                if (state is TransactionsLoadingState) {
                  return Center(
                    child: SpinKitDualRing(
                      size: 32,
                      lineWidth: 3,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ),
        )
      ],
    );
  }
}
