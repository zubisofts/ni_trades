import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/screens/homescreen/dashboard.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/screens/investment/investments_screen.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late int activePage;
  List pages = [
    DashBoardScreen(),
    InvestmentScreen(),
    Container(color: Colors.blue),
    Container(color: Colors.pink),
  ];

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey fabKey = GlobalKey();

  @override
  void initState() {
    activePage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activePage,
        selectedLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold),
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index != activePage) {
            setState(() {
              activePage = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/home.svg',
                  color: activePage == 0 ? Colors.transparent : Colors.blueGrey,
                  colorBlendMode: BlendMode.srcATop,
                  width: 24,
                  semanticsLabel: 'Home'),
              label: "Home"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/investments.svg',
                  color: activePage == 1 ? Colors.transparent : Colors.blueGrey,
                  colorBlendMode: BlendMode.srcATop,
                  width: 24,
                  semanticsLabel: 'Investments'),
              label: "Investments"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/payment.svg',
                  color: activePage == 2 ? Colors.transparent : Colors.blueGrey,
                  colorBlendMode: BlendMode.srcATop,
                  width: 24,
                  semanticsLabel: 'Payment'),
              label: "Payment"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/wallet.svg',
                  color: activePage == 3 ? Colors.transparent : Colors.blueGrey,
                  colorBlendMode: BlendMode.srcATop,
                  width: 24,
                  semanticsLabel: 'Withdraw'),
              label: "Withdraw")
        ],
      ),
      body: Container(
        child: pages[activePage],
      ),
      floatingActionButton: activePage == 1
          ? FloatingActionButton.extended(
              key: fabKey,
              onPressed: () {
                Navigator.of(context).push(PageTransition(
                    child: InvestmentSelectionScreen(),
                    type: PageTransitionType.bottomToTop));
              },
              label: Text(
                'Invest',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
