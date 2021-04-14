import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/screens/investment/investment_item_details.dart';
import 'package:ni_trades/screens/investment/investment_wallet_dashboard.dart';
import 'package:ni_trades/util/my_utils.dart';

class InvestedItemWidget extends StatefulWidget {
  final Investment investment;

  const InvestedItemWidget({Key? key, required this.investment})
      : super(key: key);

  @override
  _InvestedItemWidgetState createState() => _InvestedItemWidgetState();
}

class _InvestedItemWidgetState extends State<InvestedItemWidget> {
  late Stream<InvestmentPackage> fetchInvestmentDetails;

  @override
  void initState() {
    fetchInvestmentDetails =
        DataService().fetchSingleInvestment(widget.investment.packageId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<InvestmentPackage>(
        stream: fetchInvestmentDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            InvestmentPackage investmentPackage = snapshot.data!;
            return Container(
              margin: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: investmentPackage.imageCoverUrl,
                    fit: BoxFit.cover,
                    width: size.width,
                    height: size.width * 0.4,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '${investmentPackage.title}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Row(
                    children: [
                      Text(
                        'Started at:',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '${AppUtils.getDateFromTimestamp(widget.investment.startDate)}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InvestmentDashboardScreen(
                            investment: widget.investment),
                      ));
                    },
                    child: Text(
                      'More details',
                    ),
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
            );
          }

          return SizedBox.shrink();
        });
  }
}
