import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/util/my_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CurrentInvestmentProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(16.0),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.secondary)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Column(
          children: [
            Text('Active Investment Progress',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
            Expanded(
              child: BlocBuilder<DataBloc, DataState>(
                buildWhen: (previous, current) =>
                    current is UserInvestmentsFetchedState ||
                    current is FetchUserInvestmentsLoadingState,
                builder: (context, state) {
                  if (state is UserInvestmentsFetchedState) {
                    List<Investment> activeInvestments =
                        state.investments.where((i) => i.active).toList();
                    if (activeInvestments.isNotEmpty) {
                      return PageView.builder(
                        itemCount: activeInvestments.length,
                        itemBuilder: (context, index) {
                          return InvestmentProgress(
                              investment: activeInvestments[index]);
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/empty.svg',
                              color: Theme.of(context).colorScheme.secondary,
                              width: 150,
                            ),
                            Text("You don't have any active investments",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 14.0)),
                          ],
                        ),
                      );
                    }
                  }

                  if (state is FetchUserInvestmentsLoadingState) {
                    return SpinKitDualRing(
                      lineWidth: 2,
                      size: 32.0,
                      color: Theme.of(context).iconTheme.color!,
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestmentProgress extends StatelessWidget {
  final Investment investment;

  const InvestmentProgress({Key? key, required this.investment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InvestmentPackage>(
        stream: DataService().fetchPackageDetails(investment.packageId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<double>(
                future: AppUtils.getInvestmentProgress(
                    investment.startDate, snapshot.data!.durationInMonths),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    var data = snapshot2.data;
                    return CircularPercentIndicator(
                      radius: 150.0,
                      animation: true,
                      animateFromLastPercent: true,
                      rotateLinearGradient: true,
                      footer: Column(
                        children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '${snapshot.data!.title}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                // fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                      animationDuration: 1200,
                      lineWidth: 15.0,
                      percent: snapshot2.data!,
                      center: Text(
                        '${((data! / 1) * 100).round()}%',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      progressColor: Colors.green[400],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Fetching investment progress...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    );
                  }
                });
          }

          if (snapshot.hasError) {
            print('ERROR SNAPSHOT:${snapshot.error}');
          }

          return Center(
              child: Text(
            'Loading progress..',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ));
        });
  }
}
