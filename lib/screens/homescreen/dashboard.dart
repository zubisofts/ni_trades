import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ni_trades/blocs/app/app_bloc.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/screens/homescreen/widgets/balance_widget.dart';
import 'package:ni_trades/screens/homescreen/widgets/current_investmentProgress_widget.dart';
import 'package:ni_trades/screens/homescreen/widgets/recent_investments_widget.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/screens/profile/user_profile_screen.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:ni_trades/util/my_utils.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!);
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      displacement: 100,
      child: SingleChildScrollView(
        primary: true,
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 55),
          width: size.width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(32.0),
                        bottomLeft: Radius.circular(32.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<DataBloc, DataState>(
                                  buildWhen: (previous, current) =>
                                      current is UserDetailsFetchedState,
                                  builder: (context, state) {
                                    if (state is UserDetailsFetchedState) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Good ${AppUtils.greet}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                // SizedBox(
                                                //   height: 8.0,
                                                // ),
                                                Container(
                                                  width: size.width,
                                                  child: Text(
                                                      '${state.user.lastName}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 26.0,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<AppBloc, AppState>(
                            buildWhen: (previous, current) =>
                                current is ThemeRetrievedState,
                            builder: (context, state) {
                              bool isDarkTheme = false;
                              if (state is ThemeRetrievedState) {
                                isDarkTheme = state.isDarkTheme;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(8.0),
                                  onTap: () {
                                    print('Is dark theme:$isDarkTheme');
                                    context.read<AppBloc>().add(
                                        SwitchThemeEvent(
                                            isDarkTheme: !isDarkTheme));
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/theme.svg',
                                    width: 24,
                                    color: isDarkTheme
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.black,
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          BlocBuilder<DataBloc, DataState>(
                            buildWhen: (previous, current) =>
                                current is UserDetailsFetchedState,
                            builder: (context, state) {
                              if (state is UserDetailsFetchedState) {
                                return InkWell(
                                  onTap: () {
                                    // BlocProvider.of<AuthBloc>(context)
                                    //     .add(LogoutUserEvent());
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileScreen(user: state.user),
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(8.0),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              '${state.user.photo}')),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      // elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Container(
                        width: size.width,
                        // height: size.width * 0.35,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Theme.of(context).cardColor),
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
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      );
                                    }

                                    return BalanceWidget(
                                      balance: 0.00,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    );

                                    // return Text('NGN *******',
                                    //     style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontSize: 32.0,
                                    //         fontWeight: FontWeight.bold));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              QuickActionsWidget(),
              CurrentInvestmentProgressWidget(),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Investment History',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
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
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //     width: 1,
                          //     color: Theme.of(context).iconTheme.color!),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text("Fund Wallet",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
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
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //     width: 1,
                          //     color: Theme.of(context).iconTheme.color!),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.inventory,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Invest Now",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14),
                          ),
                        ],
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
