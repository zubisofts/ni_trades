import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/screens/investment/investment_wallet_dashboard.dart';
import 'package:ni_trades/screens/investment/widgets/invested_item_widget.dart';
import 'package:page_transition/page_transition.dart';

class InvestmentScreen extends StatefulWidget {
  @override
  _InvestmentScreenState createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  @override
  void initState() {
    context
        .read<DataBloc>()
        .add(FetchUserInvestmentsEvent(userId: AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'My Investments',
      //     style: TextStyle(
      //         color: Theme.of(context).colorScheme.onPrimary,
      //         fontSize: 18,
      //         fontWeight: FontWeight.w900),
      //   ),
      //   leading: SizedBox.shrink(),
      //   centerTitle: true,
      // ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 55.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'My Investments',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DataBloc, DataState>(
              buildWhen: (previous, current) =>
                  current is UserInvestmentsFetchedState ||
                  current is FetchUserInvestmentsErrorState ||
                  current is FetchUserInvestmentsLoadingState,
              builder: (context, state) {
                if (state is UserInvestmentsFetchedState) {
                  List<Investment> investments = state.investments;
                  if (investments.isEmpty) {
                    return EmptyWidget();
                  } else {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: investments.length,
                        itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InvestmentDashboardScreen(
                                    investment: investments[index]),
                              ));
                            },
                            child: Hero(
                              tag: investments[index].id,
                              child: InvestedItemWidget(
                                  investment: investments[index]),
                            )));
                  }
                }

                return SizedBox.shrink();
              },
            ),
          )
        ],
      )),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/empty.svg',
              color: Theme.of(context).colorScheme.secondary,
              colorBlendMode: BlendMode.modulate,
              width: 200,
              semanticsLabel: 'A red up arrow'),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "You don't have any investment at the moment. \nUse the below button to enroll now",
            style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          // SizedBox(
          //   height: 16.0,
          // ),
          // TextButton(
          //     style: TextButton.styleFrom(
          //         backgroundColor: Theme.of(context).colorScheme.secondary),
          //     onPressed: () {

          //       // showMaterialModalBottomSheet(
          //       //   context: context,
          //       //   animationCurve: Curves.easeInOutCubic,
          //       //   // expand: false,
          //       //   backgroundColor: Theme.of(context).cardTheme.color,
          //       //   builder: (context) => InvestmentSelectionScreen(),
          //       // );
          //     },
          //     child: Text('Invest Now'))
        ],
      ),
    );
  }
}
