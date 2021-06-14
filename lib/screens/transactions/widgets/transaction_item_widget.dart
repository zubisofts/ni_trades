import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/screens/transactions/transactions_details_screen.dart';
import 'package:ni_trades/util/my_utils.dart';

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
        leading: _buildIconWidget(transaction),
        title: Text(transaction.title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.description,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold)),
              Text(AppUtils.getDateFromTimestamp(transaction.timestamp),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12.0,
                  )),
            ],
          ),
        ),
        minVerticalPadding: 16,
      ),
    );
  }

  Widget _buildIconWidget(NiTransacton transaction) {
    if (transaction.type == 'Fund') {
      return SvgPicture.asset(
        'assets/icons/wallet.svg',
        width: 45,
      );
    } else if (transaction.type == 'Invest') {
      return SvgPicture.asset(
        'assets/icons/investments.svg',
        width: 45,
      );
    } else {
      return SvgPicture.asset(
        'assets/icons/payment.svg',
        width: 45,
      );
    }
  }
}
