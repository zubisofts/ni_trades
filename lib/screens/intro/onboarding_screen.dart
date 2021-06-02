import 'package:flutter/material.dart';
import 'package:ni_trades/screens/auth_screen/login_screen.dart';
import 'package:ni_trades/util/app_theme.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  final pages = [
    SkOnboardingModel(
        title: 'Learn to invest',
        description:
            "Learn to invest today, you don't need to wait until old age.",
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/invest.png'),
    SkOnboardingModel(
        title: 'Monitor your progress',
        description:
            'You can monitor your investment progress without any stress.',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/watch.png'),
    SkOnboardingModel(
        title:
            'Withdraw and Rejoice',
        description: 'When due, you can widthdraw and use your money for your personal purposes.',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/reap.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
                      child: SKOnboardingScreen(
              bgColor: Colors.white,
              themeColor: Theme.of(context).colorScheme.secondary,
              pages: pages,
              skipClicked: (value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
              getStartedClicked: (value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
