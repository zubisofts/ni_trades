import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ni_trades/screens/homescreen/dashboard.dart';
import 'package:ni_trades/screens/homescreen/widgets/fab_bottom_bar.dart';
import 'package:ni_trades/screens/investment/investment_selection_screen.dart';
import 'package:ni_trades/screens/investment/investments_screen.dart';
import 'package:ni_trades/screens/payment/payment_screen.dart';
import 'package:ni_trades/screens/transactions/transactions_screen.dart';
import 'package:ni_trades/util/diamond_shaped_notch.dart';

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
    PaymentScreen(),
    TransactionsScreen(),
  ];

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey fabKey = GlobalKey();

  @override
  void initState() {
    activePage = 0;
    super.initState();
  }

  void _selectedTab(int index) {
    setState(() {
      activePage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!);
    return Scaffold(
      // key: scaffoldKey,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Hero(
        tag: 'fabToInvest',
        child: Transform.rotate(
            angle: 0.8,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InvestmentSelectionScreen(),
                  ));
                },
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Transform.rotate(
                    angle: 0.8,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: '',
        color: Colors.grey,
        selectedColor: Theme.of(context).colorScheme.secondary,
        notchedShape: DiamondFabNotchedShape(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home_outlined, text: 'Home'),
          FABBottomAppBarItem(
              iconData: Icons.analytics_outlined, text: 'Investments'),
          FABBottomAppBarItem(iconData: Icons.payment_outlined, text: 'Wallet'),
          FABBottomAppBarItem(
              iconData: Icons.swap_horiz_outlined, text: 'Tranx'),
        ],
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      ),
      body: Container(
        child: pages[activePage],
      ),
      // floatingActionButton: activePage == 1
      //     ? FloatingActionButton.extended(
      //         key: fabKey,
      //         onPressed: () {
      //           Navigator.of(context).push(PageTransition(
      //               child: InvestmentSelectionScreen(),
      //               type: PageTransitionType.bottomToTop));
      //         },
      //         label: Text(
      //           'Invest',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         icon: Icon(
      //           Icons.add,
      //           color: Colors.white,
      //         ),
      //       )
      //     : SizedBox.shrink(),
    );
  }
}
