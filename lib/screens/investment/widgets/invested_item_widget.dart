import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/screens/investment/investment_item_details.dart';
import 'package:ni_trades/screens/investment/investment_wallet_dashboard.dart';
import 'package:ni_trades/util/my_utils.dart';
import 'package:shimmer/shimmer.dart';

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
            return Card(
              margin: EdgeInsets.all(16.0),
              color:
                  getCategoryColor(investmentPackage.category).withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                // side: BorderSide(
                // width: 1,
                // color: Colors.blueGrey
                // color: Theme.of(context).colorScheme.secondary
                // )
              ),
              child: Container(
                margin: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CachedNetworkImage(
                    //   imageUrl: investmentPackage.imageCoverUrl,
                    //   errorWidget: (context, url, error) {
                    //     return Center(
                    //       child: Icon(
                    //         Icons.error,
                    //         color: Theme.of(context).iconTheme.color,
                    //       ),
                    //     );
                    //   },
                    //   placeholder: (context, url) => Shimmer.fromColors(
                    //       child: Container(),
                    //       baseColor: Colors.grey.shade200,
                    //       highlightColor: Colors.grey.shade400),
                    //   fit: BoxFit.cover,
                    //   width: size.width,
                    //   height: size.width * 0.4,
                    // ),
                    Expanded(
                      flex: 2,
                      child: SvgPicture.asset(
                        getCategoryImage(investmentPackage.category),
                        width: 100,
                        height: 100,
                        // color: getCategoryColor(investmentPackage.category),
                        colorBlendMode: BlendMode.multiply,
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${investmentPackage.title}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Started at:',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                '${AppUtils.getDateFromTimestamp(widget.investment.startDate)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => InvestmentDashboardScreen(
                    //           investment: widget.investment),
                    //     ));
                    //   },
                    //   child: Text(
                    //     'More details',
                    //   ),
                    //   style: TextButton.styleFrom(
                    //       textStyle: TextStyle(
                    //           fontSize: 16,
                    //           color: Theme.of(context).colorScheme.onPrimary),
                    //       backgroundColor:
                    //           Theme.of(context).colorScheme.secondary),
                    // )
                  ],
                ),
              ),
            );
          }

          return SizedBox.shrink();
        });
  }

  String getCategoryImage(String category) {
    if (category == 'Agriculture') {
      return 'assets/icons/farm.svg';
    } else if (category == 'Fashion') {
      return 'assets/icons/fashion.svg';
    } else {
      return 'assets/icons/tech.svg';
    }
  }

  Color getCategoryColor(String category) {
    if (category == 'Agriculture') {
      return Color(0xFF2e7d32);
    } else if (category == 'Fashion') {
      return Color(0xFFff8f00);
    } else {
      return Color(0xFFaf4448);
    }
  }
}
