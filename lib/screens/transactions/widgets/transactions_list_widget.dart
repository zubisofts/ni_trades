import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/screens/transactions/widgets/transaction_item_widget.dart';

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
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: ListView.builder(
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
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/empty.svg',
                    color: Theme.of(context).colorScheme.secondary,
                    width: 100,
                  ),
                  Text(
                    'You have not made any wallet transactions yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            );
          }
        }

        if (state is TransactionsLoadingState) {
          return Center(
            child: SpinKitDualRing(
              lineWidth: 2,
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}