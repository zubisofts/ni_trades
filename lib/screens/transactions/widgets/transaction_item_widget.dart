import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ni_trades/model/transaction.dart';

class TransactionItemWidget extends StatelessWidget {
  final NiTransacton transaction;

  TransactionItemWidget({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color),
      child: ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.all(8.0),
        leading: CircleAvatar(
          radius: 24.0,
          backgroundImage: AssetImage('assets/images/wallet.png'),
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
