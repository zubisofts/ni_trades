import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({
    Key? key,
    required this.balance,
    required this.textColor,
  }) : super(key: key);

  final dynamic balance;
  final Color textColor;

  @override
  _BalanceWidgetState createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
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
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(
              '${isWalletVisible ? currencyFormatter.format(widget.balance) : 'NGN *****'}',
              style: TextStyle(
                  color: widget.textColor,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w900)),
          SizedBox(
            width: 16.0,
          ),
          IconButton(
            icon:
                Icon(isWalletVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                isWalletVisible = !isWalletVisible;
              });
            },
          )
        ],
      ),
    );
  }
}
