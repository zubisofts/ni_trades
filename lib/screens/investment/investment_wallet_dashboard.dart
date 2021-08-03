import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/api_response.dart';

import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/model/time_api.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/repository/payment_repository.dart';
import 'package:ni_trades/util/my_utils.dart';

import 'widgets/returns_desc_widget.dart';

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
  void initState() {
    context.read<DataBloc>().add(FetchInvestmentCountDownEvent(
        widget.investment.startDate, widget.investment.duration));
    super.initState();
  }

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
                      return FutureBuilder<ApiResponse>(
                        future: PaymentRepository().getCurrentTime,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            TimeApi timeApi = snapshot.data!.data;
                            int time = DateTime.parse(timeApi.currentDateTime)
                                .millisecondsSinceEpoch;
                            // print(DateTime.parse(timeApi.currentDateTime));
                            return StreamBuilder<InvestmentPackage>(
                              stream: DataService().fetchPackageDetails(
                                  widget.investment.packageId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return StreamBuilder<String>(
                                      stream: AppUtils.getInvestmentCountDown(
                                          time,
                                          widget.investment.startDate,
                                          snapshot.data!.durationInMonths),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              'Investement will be due in ${snapshot.data!} days',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ));
                                        }
                                        return Text('');
                                      });
                                }

                                return SizedBox.shrink();
                              },
                            );
                          }
                          return Text('Calculating duration...');
                        },
                      );
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
                  height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14.0,
                          )),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                          '${AppUtils.getDateFromTimestamp(widget.investment.startDate)}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 15.0,
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
                  height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due Date',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14.0,
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
                                      fontSize: 15.0,
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
          padding: const EdgeInsets.all(16.0),
          child: ReturnsDescriptionWidget(
            investment: widget.investment,
          ),
        ),
      ],
    );
  }

//   Widget _renderWidthdrawalButton(BuildContext context, Investment investment) {
//     return BlocConsumer<DataBloc, DataState>(
//       listenWhen: (previous, current) =>
//           current is InvestmentCountDownFetchErrorState ||
//           current is InvestmentCountDownFetchedState ||
//           current is InvestmentCountDownLoadingState,
//       listener: (context, state) {},
//       buildWhen: (previous, current) =>
//           current is InvestmentCountDownFetchErrorState ||
//           current is InvestmentCountDownFetchedState ||
//           current is InvestmentCountDownLoadingState,
//       builder: (context, state) {
//         if (state is InvestmentCountDownFetchErrorState) {
//           return Text(
//             'Unable to fetch data, make sure you are connected and refresh!',
//             style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//           );
//         }

//         if (state is InvestmentCountDownLoadingState) {
//           return Center(
//             child: SpinKitDualRing(
//               color: Theme.of(context).colorScheme.secondary,
//               size: 24.0,
//               lineWidth: 2,
//             ),
//           );
//         }

//         if (state is InvestmentCountDownFetchedState) {
//           int days = state.result;
//           if (days < 1 && investment.status == InvestmentStatus.Processing) {
//             return Text(
//               'Pending withdrawal request',
//               style: TextStyle(color: Colors.orangeAccent),
//             );
//           } else if (days < 1 &&
//               investment.status == InvestmentStatus.Completed) {
//             return Text(
//               'This investment has been completed!',
//               style: TextStyle(color: Colors.green),
//             );
//           }
//           return MaterialButton(
//             onPressed: () {
//               showMaterialModalBottomSheet(
//                 context: context,
//                 expand: false,
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16.0),
//                         topRight: Radius.circular(16.0))),
//                 builder: (context) => SelectionForm(investment),
//               );
//             },
//             padding: EdgeInsets.all(16.0),
//             color: Colors.green,
//             disabledColor: Colors.grey.shade600,
//             disabledTextColor: Theme.of(context).colorScheme.onPrimary,
//             textColor: Colors.white,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0)),
//             child: Text(
//               'Request Widthdrawal',
//             ),
//           );
//         }
//         return SizedBox.shrink();
//       },
//     );
//   }
}
