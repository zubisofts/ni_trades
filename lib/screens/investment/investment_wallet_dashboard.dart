import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/util/my_utils.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!);
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

  late Stream<InvestmentPackage> fetchPackageInfo;

  @override
  void initState() {
    fetchPackageInfo =
        DataService().fetchPackageDetails(widget.investment.packageId);
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "₦",
    );
    isWalletVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<InvestmentPackage>(
            stream: fetchPackageInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('${snapshot.data!.title}',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                );
              }

              return SizedBox.shrink();
            }),
        SizedBox(
          width: 16.0,
        ),
        Card(
          margin: EdgeInsets.all(16.0),
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      icon: Icon(isWalletVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isWalletVisible = !isWalletVisible;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                StreamBuilder<InvestmentPackage>(
                  stream: fetchPackageInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<String>(
                          stream: AppUtils.getInvestmentCountDown(
                              widget.investment.startDate,
                              snapshot.data!.durationInMonths),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  'Your investement will be due in ${snapshot.data!} days',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ));
                            }
                            return Text('');
                          });
                    }

                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16.0,
                          )),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                          '${AppUtils.getDateFromTimestamp(widget.investment.startDate)}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due Date',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16.0,
                          )),
                      SizedBox(
                        height: 8.0,
                      ),
                      StreamBuilder<InvestmentPackage>(
                          stream: fetchPackageInfo,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  '${AppUtils.getInvestmentDueDate(widget.investment.startDate, snapshot.data!.durationInMonths)}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold));
                            }
                            return Text('...');
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: widget.investment.isDue ? () {} : null,
                padding: EdgeInsets.all(16.0),
                color: Colors.green,
                disabledColor: Colors.grey.shade600,
                disabledTextColor: Theme.of(context).colorScheme.onPrimary,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  'Request Widthdrawal',
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              // MaterialButton(
              //   onPressed: widget.investment.active ? () {} : null,
              //   padding: EdgeInsets.all(16.0),
              //   color: Colors.red,
              //   disabledColor: Colors.grey.shade600,
              //   disabledTextColor: Theme.of(context).colorScheme.onPrimary,
              //   textColor: Colors.white,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8.0)),
              //   child: Text(
              //     'Cancel Investment',
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }
}
