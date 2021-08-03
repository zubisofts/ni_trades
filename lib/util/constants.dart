import 'package:flutter/material.dart';

class Constants {
  static const USER_PREF_KEY = 'login_user_credentials';
  static const THEME_PREF_KEY = "nitrade_theme_key";
  static const FIRST_TIME_USER_PREF_KEY = "first_time_user_key";
  static const PAYSTACK_PUBLIC_API =
      'pk_test_d433aa543b6a685cd91269ef1fc47d666a343287';
  static const PAYSTACK_SECRETE =
      "sk_test_e3226b354c8d421ec1cc846736e87d0414adde89";

  static const ONE_SIGNAL_APP_ID = "acaa1606-1341-49f5-b73b-1084ec634c7f";

  static const SENDTRY_CDN="https://4a62fa3f823d44a5840101098956c37c@o934062.ingest.sentry.io/5883364";

  static const MAP_API_KEY = "AIzaSyAdcDU38dn79bKr5pJwYxEt1deLz_Hz34E";
  static const OTP_BASE_URL = "https://ni-trades-api.herokuapp.com";

  static final inputDecoration = (BuildContext context) => InputDecoration(
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 16.0,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0)),
        // enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //     borderSide: BorderSide(
        //       color: Theme.of(context).colorScheme.secondary,
        //     )),
        // focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //     borderSide: BorderSide(
        //       color: Theme.of(context).colorScheme.secondary,
        //     )),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //     borderSide: BorderSide(
        //       color: Theme.of(context).colorScheme.secondary,
        // )
        // )
      );
}

enum PaymentType { FUND, INVEST }
