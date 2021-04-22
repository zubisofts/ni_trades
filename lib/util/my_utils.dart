import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AppUtils {
  static String displayTimeAgoFromTimestamp(int millisecondsSinceEpoch,
      {bool numericDates = true}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  static String getTimeFromTimestamp(int millisecondsSinceEpoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String time = DateFormat.jm().format(date);
    return time;
  }

  static String getDateFromTimestamp(int millisecondsSinceEpoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String time = DateFormat.yMMMMEEEEd().format(date);
    return time;
  }

  static Future<String?> makePayment(BuildContext context,
      PaystackPlugin paystackPlugin, dynamic amount) async {
    Uuid referenceKey = Uuid();
    String ref = referenceKey.v1(options: {
      'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
      'clockSeq': 0x1234,
      'mSecs': new DateTime.now().millisecondsSinceEpoch,
      'nSecs': 5678
    });
    PaymentCard card = PaymentCard(
        number: '4084084084084081', cvc: '408', expiryMonth: 4, expiryYear: 22);
    Charge charge = Charge()
      ..amount = amount * 100
      ..reference = '$ref'
      ..card = card
      ..currency = 'NGN'
      ..putMetaData("name", "NI Trades")
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = 'zubitex40@email.com'
      ..putCustomField('Charged From', 'NI Trades');

    // CheckoutResponse response =
    //     await paystackPlugin.chargeCard(context, charge: charge);

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );

    print('Transaction Response: ${response.status}');

    return response.status ? ref : null;
  }

  static Stream<String> getInvestmentCountDown(int timestamp, int months) {
    return Stream.periodic(Duration(seconds: 1), (data) {
      var advanceDaysInMillis = (31 * months) * 8.64e+7;
      var advanceDate =
          DateTime.now().millisecondsSinceEpoch + advanceDaysInMillis;
      var difference =
          ((advanceDate - DateTime.now().millisecondsSinceEpoch) / 8.64e+7)
              .round();
      return '$difference';
    });
  }

  static getInvestmentDueDate(int startDate, int months) {
    var advanceDaysInMillis = ((31 * months) * 8.64e+7).round();
    var date = (startDate + advanceDaysInMillis).round();
    return getDateFromTimestamp(date);
  }

  static String get greet {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }
}
