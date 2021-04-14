import 'package:flutter/material.dart';
import 'package:ni_trades/screens/auth_screen/login_screen.dart';
import 'package:ni_trades/util/app_theme.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  final pages = [
    SkOnboardingModel(
        title: 'Choose your item',
        description: 'Accept delivery request from your customers',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/delivery_address.png'),
    SkOnboardingModel(
        title: 'Deliver to customer',
        description: 'Deliver item to customer as soon as possible',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/ride.png'),
    SkOnboardingModel(
        title: 'Get paid quick and easy',
        description: 'Get paid when delivery is completed and confirmed',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/wallet.png'),
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme.setFirstTimeUser(false);

    return Scaffold(
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: const Color(0xFFf74269),
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
    );
  }
}
