import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/screens/transactions/widgets/transaction_item_widget.dart';
import 'package:ni_trades/util/my_utils.dart';

class TransactionsDetailsScreen extends StatefulWidget {
  final NiTransacton transaction;

  const TransactionsDetailsScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  _TransactionsDetailsScreenState createState() =>
      _TransactionsDetailsScreenState();
}

class _TransactionsDetailsScreenState extends State<TransactionsDetailsScreen> {
  @override
  void initState() {
    context.read<DataBloc>().add(LoadTransactionsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 32.0,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                Center(
                  child: Text(
                    'Transaction Details',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container()
              ],
            ),
          ),
          ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
              title: Text(
                'Amount',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              trailing: Text(
                '₦500.00',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
              title: Text(
                'Transaction Type',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              trailing: Text(
                '${widget.transaction.type}',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: widget.transaction.type == 'Widthdraw'
                        ? Colors.red
                        : Colors.green),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
              title: Text(
                'Date/Time',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${AppUtils.getDateFromTimestamp(widget.transaction.timestamp)}',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    '${AppUtils.getTimeFromTimestamp(widget.transaction.timestamp)}',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
              title: Text(
                'Transaction ID',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              trailing: Text(
                '${widget.transaction.id}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
