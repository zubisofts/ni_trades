import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/screens/investment/investment_form_screen.dart';
import 'package:ni_trades/screens/investment/investment_item_details.dart';

class InvestmentPackageWidget extends StatelessWidget {
  final InvestmentPackage investmentPackage;

  const InvestmentPackageWidget({Key? key, required this.investmentPackage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: investmentPackage.imageCoverUrl,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                        // Image.asset(
                        //   'assets/images/agriculture.jpeg',
                        //   width: MediaQuery.of(context).size.width,
                        //   fit: BoxFit.cover,
                        // ),
                        Container(
                          color: Colors.black.withOpacity(0.2),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: -60,
                  top: 10.0,
                  child: Transform.rotate(
                    angle: -5.5,
                    child: Container(
                      width: 200,
                      height: 40,
                      color: Colors.black.withOpacity(0.6),
                      child: Center(
                        child: Text(
                          '${investmentPackage.returns}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 16.0,
            // ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${investmentPackage.title}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Duration:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        '${investmentPackage.durationInMonths} months',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsetsDirectional.zero,
                              // backgroundColor: Colors.blueGrey,
                              textStyle: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            showBarModalBottomSheet(
                              context: context,
                              // expand: false,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              backgroundColor:
                                  Theme.of(context).cardTheme.color,
                              builder: (context) => InvestmentDetailsScreen(
                                  investmentPackage: investmentPackage),
                            );
                          },
                          child: Text(
                            'More details',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          onPressed: () {
                            showBarModalBottomSheet(
                              context: context,
                              // expand: false,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              backgroundColor:
                                  Theme.of(context).cardTheme.color,
                              builder: (context) => InvestmentFormScreen(
                                  investmentPackage: investmentPackage),
                            );
                          },
                          child: Text('Invest Now'))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
