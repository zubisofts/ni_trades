import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/screens/homescreen/widgets/balance_widget.dart';
import 'package:ni_trades/screens/homescreen/widgets/recent_investments_widget.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:ni_trades/util/my_utils.dart';
import 'package:page_transition/page_transition.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchUserWalletEvent(AuthBloc.uid!));
    context.read<DataBloc>().add(FetchUserDetailsEvent(AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      displacement: 100,
      child: SingleChildScrollView(
        primary: true,
        physics: BouncingScrollPhysics(),
        child: Container(
          width: size.width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good ${AppUtils.greet}!',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 8.0,
                        ),
                        BlocBuilder<DataBloc, DataState>(
                          buildWhen: (previous, current) =>
                              current is UserDetailsFetchedState,
                          builder: (context, state) {
                            if (state is UserDetailsFetchedState) {
                              return Text('${state.user.lastName}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 26.0,
                                  ));
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(LogoutUserEvent());
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/img6.png')),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                // elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  width: size.width,
                  // height: size.width * 0.35,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(150)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Available Balance',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              )),
                          SizedBox(
                            height: 8.0,
                          ),
                          BlocBuilder<DataBloc, DataState>(
                            buildWhen: (previous, current) =>
                                current is UserWalletFetchedState,
                            builder: (context, state) {
                              if (state is UserWalletFetchedState) {
                                return BalanceWidget(
                                  balance: state.wallet.balance,
                                  textColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                );
                              }

                              return Text('NGN *******',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              QuickActionsWidget(),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recent Investments',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RecentInvestmentWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    context.read<DataBloc>().add(FetchUserWalletEvent(AuthBloc.uid!));
  }
}

class QuickActionsWidget extends StatefulWidget {
  QuickActionsWidget();

  @override
  _QuickActionsWidgetState createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends State<QuickActionsWidget> {
  late PaystackPlugin paystackPlugin;

  @override
  void initState() {
    initPayStack();
    super.initState();
  }

  void initPayStack() async {
    paystackPlugin = PaystackPlugin();
    await paystackPlugin.initialize(publicKey: Constants.PAYSTACK_PUBLIC_API);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: MaterialButton(
                      // height: MediaQuery.of(context).size.width * 0.6,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      color: Color(0xFFfff3e0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/invest_money.png',
                              width: 40,
                              colorBlendMode: BlendMode.colorDodge,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Fund Wallet",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        fundWallet(paystackPlugin, 1000);
                      })),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                  child: MaterialButton(
                      // height: MediaQuery.of(context).size.width * 0.6,
                      color: Color(0xFFffccbc),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              'assets/icons/funds.png',
                              width: 40,
                              colorBlendMode: BlendMode.colorDodge,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Invest Now",
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InvestmentSelectionScreen(),
                        ));
                      }))
            ],
          ),
        ],
      ),
    );
  }

  void fundWallet(PaystackPlugin paystackPlugin, dynamic amount) async {
    String? refId = await AppUtils.makePayment(context, paystackPlugin, amount);
    if (refId != null) {
      context
          .read<DataBloc>()
          .add(FundWalletEvent(amount: amount, userId: AuthBloc.uid!));
    }
  }
}
