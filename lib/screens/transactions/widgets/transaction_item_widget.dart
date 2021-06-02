import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/screens/transactions/transactions_details_screen.dart';

class TransactionItemWidget extends StatelessWidget {
  final NiTransacton transaction;

  TransactionItemWidget({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color!.withOpacity(0.1)),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                TransactionsDetailsScreen(transaction: transaction),
          ));
        },
        contentPadding: EdgeInsets.all(8.0),
        leading: SvgPicture.asset(
          transaction.type == 'Invest'
              ? 'assets/icons/investments.svg'
              : 'assets/icons/wallet.svg',
          width: 45,
        ),
        title: Text(transaction.title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(transaction.description,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold)),
        ),
        minVerticalPadding: 16,
      ),
    );
  }
}
