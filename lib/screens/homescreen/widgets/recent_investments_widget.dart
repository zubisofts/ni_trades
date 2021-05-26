import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/repository/data_repo.dart';

class RecentInvestmentWidget extends StatefulWidget {
  @override
  _RecentInvestmentWidgetState createState() => _RecentInvestmentWidgetState();
}

class _RecentInvestmentWidgetState extends State<RecentInvestmentWidget> {
  late NumberFormat currencyFormatter;

  @override
  void initState() {
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "₦",
    );
    context
        .read<DataBloc>()
        .add(FetchUserInvestmentsEvent(userId: AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: BlocBuilder<DataBloc, DataState>(buildWhen: (previous, current) {
        return current is UserInvestmentsFetchedState ||
            // current is FetchUserInvestmentsLoadingState ||
            current is FetchUserInvestmentsErrorState;
      }, builder: (context, state) {
        if (state is UserInvestmentsFetchedState) {
          print('FetchUserInvestments:$state');
          var investments = state.investments.take(2).toList();

          if (investments.isEmpty) {
            return Container(
              height: 150,
              child: Center(
                child: Text("You don't have any recent investments"),
              ),
            );
          }

          return Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 16.0,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: CircleAvatar(
                    //     radius: 60.0,
                    //   ),
                    // ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: investments.take(3).length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: EdgeInsets.only(left: 16.0, right: 16),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder<InvestmentPackage>(
                                        stream: DataService()
                                            .fetchSingleInvestment(
                                                investments[index].packageId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              '${snapshot.data!.title}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        }),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      '${currencyFormatter.format(investments[index].amount)}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }

        if (state is FetchUserInvestmentsErrorState) {
          return Text('An error occured:${state.error}');
        }

        return Center(
            child: Container(
                margin: EdgeInsets.all(45.0), child: Text('Loading')));
      }),
    );
  }
}
