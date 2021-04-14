import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ni_trades/model/investment.dart';

class InvestmentDashboardScreen extends StatefulWidget {
  final Investment investment;

  const InvestmentDashboardScreen({Key? key, required this.investment})
      : super(key: key);

  @override
  _InvestmentDashboardScreenState createState() =>
      _InvestmentDashboardScreenState();
}

class _InvestmentDashboardScreenState extends State<InvestmentDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Investment Wallet',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Column(
        children: [InvestmentBalanceWidget(investment: widget.investment)],
      ),
    );
  }
}

class InvestmentBalanceWidget extends StatefulWidget {
  const InvestmentBalanceWidget({
    Key? key,
    required this.investment,
  }) : super(key: key);

  final Investment investment;

  @override
  _InvestmentBalanceWidgetState createState() =>
      _InvestmentBalanceWidgetState();
}

class _InvestmentBalanceWidgetState extends State<InvestmentBalanceWidget> {
  late bool isWalletVisible;
  late NumberFormat currencyFormatter;

  @override
  void initState() {
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "₦",
    );
    isWalletVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
            '${isWalletVisible ? currencyFormatter.format(widget.investment.amount) : '*******'}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold)),
        SizedBox(
          width: 16.0,
        ),
        IconButton(
          icon: Icon(isWalletVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              isWalletVisible = !isWalletVisible;
            });
          },
        )
      ],
    );
  }
}
