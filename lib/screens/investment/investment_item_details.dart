import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/screens/investment/investment_form_screen.dart';

class InvestmentDetailsScreen extends StatefulWidget {
  final InvestmentPackage investmentPackage;

  const InvestmentDetailsScreen({Key? key, required this.investmentPackage})
      : super(key: key);

  @override
  _InvestmentDetailsScreenState createState() =>
      _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '${widget.investmentPackage.title}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CachedNetworkImage(
                    imageUrl: widget.investmentPackage.imageCoverUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Card(
                    shadowColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Duration:'),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            '${widget.investmentPackage.durationInMonths} months',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Card(
                    shadowColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Returns:'),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            '${widget.investmentPackage.returns} %',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'About this investment',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${widget.investmentPackage.description}',
                    style: TextStyle(height: 1.5, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Center(
            child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                padding: EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.secondary,
                child: Text('Invest Now'),
                onPressed: () {
                  Navigator.of(context).pop();
                  showBarModalBottomSheet(
                    context: context,
                    // expand: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    backgroundColor: Theme.of(context).cardTheme.color,
                    builder: (context) => InvestmentFormScreen(
                        investmentPackage: widget.investmentPackage),
                  );
                }),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
