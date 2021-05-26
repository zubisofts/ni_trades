import 'package:flutter/material.dart';

class Constants {
  static const BASE = 'https://chinmarklogistics.com';
  // static const BASE_URL = 'http://192.168.43.71:80/api';
  static const BASE_URL = '$BASE/api';
  static const RIDER_IMAGE_BASE_URL = '$BASE/storage/images/riders';
  static const USER_PREF_KEY = 'login_user_credentials';
  static const THEME_PREF_KEY = "nitrade_theme_key";
  static const FIRST_TIME_USER_PREF_KEY = "first_time_user_key";
  static const PAYSTACK_PUBLIC_API =
      'pk_test_d433aa543b6a685cd91269ef1fc47d666a343287';

  static const MAP_API_KEY = "AIzaSyAdcDU38dn79bKr5pJwYxEt1deLz_Hz34E";

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
