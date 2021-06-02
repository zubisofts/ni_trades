import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ni_trades/model/api_response.dart';
import 'package:ni_trades/model/bank.dart';
import 'package:ni_trades/model/time_api.dart';
import 'package:ni_trades/util/constants.dart';

class PaymentRepository {
  Future<ApiResponse> verifyAccount(
      String accountNumber, String bankCode) async {
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.paystack.co/bank/resolve?account_number=$accountNumber&bank_code=$bankCode'),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${Constants.PAYSTACK_SECRETE}',
          });

      var d = jsonDecode(response.body);
      if (d['status']) {
        return ApiResponse(data: d['data']['account_name'], error: false);
      } else {
        return ApiResponse(data: d['message'], error: true);
      }
    } catch (e) {
      return ApiResponse(data: "An error occured!", error: true);
    }
  }

// Create transfer recipient
  Future<ApiResponse> createTransferRecipient(
      {required String name,
      required String accountNumber,
      required String bankCode,
      String currency = "NGN"}) async {
    try {
      var response = await http
          .post(Uri.parse('https://api.paystack.co/transferrecipient'), body: {
        'name': name,
        'account_number': accountNumber,
        'bank_code': bankCode,
        'currency': currency,
        'type': 'nuban'
      }, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Constants.PAYSTACK_SECRETE}',
      });

      var d = jsonDecode(response.body);
      if (d['status']) {
        return ApiResponse(data: d, error: false);
      } else {
        return ApiResponse(data: d['message'], error: true);
      }
    } catch (e) {
      return ApiResponse(data: "An error occured!", error: true);
    }
  }

  // Initiate transfer
  Future<ApiResponse> initiatePaymentTransfer(
      {required String source,
      required String amount,
      required String recipient,
      required String reason}) async {
    try {
      var response =
          await http.post(Uri.parse('https://api.paystack.co/transfer'), body: {
        'source': source,
        'amount': amount,
        'recipient': recipient,
        'reason': reason,
      }, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Constants.PAYSTACK_SECRETE}',
      });

      var d = jsonDecode(response.body);
      if (d['status']) {
        return ApiResponse(data: d, error: false);
      } else {
        return ApiResponse(data: d['message'], error: true);
      }
    } catch (e) {
      return ApiResponse(data: "An error occured!", error: true);
    }
  }

// Try to make a transfer
// This returns a verification OTP to continue with transaction
  Future<ApiResponse> makeTransfer(
      {required String name,
      required String accountNumber,
      required String bankCode,
      required String amount,
      String source = "balance",
      String currency = "NGN"}) async {
    try {
      ApiResponse res1 = await verifyAccount(accountNumber, bankCode);
      if (!res1.error) {
        ApiResponse res2 = await createTransferRecipient(
            name: name, accountNumber: accountNumber, bankCode: bankCode);

        if (!res2.error) {
          ApiResponse res3 = await initiatePaymentTransfer(
              source: source,
              amount: amount,
              recipient: res2.data['data']['recipient_code'],
              reason: "Investment widthdrawal");

          if (!res3.error) {
            return res3;
          } else {
            return res3;
          }
        } else {
          return res2;
        }
      } else {
        return res1;
      }
    } catch (e) {
      return ApiResponse(data: e.toString(), error: true);
    }
  }

  Future<List<Bank>> get getBankList async {
    String json = await rootBundle.loadString('assets/files/bank_list.json');
    var data = bankListFromJson(json);
    return data.data;
  }

Future<ApiResponse> get getCurrentTime async {
    try {
      final response = await http.get(
        Uri.parse('https://world-clock.p.rapidapi.com/json/gmt/now'),
        headers: {
            'content-type': 'application/json',
            'Access-Control-Allow-Origin': 'true',
            'x-rapidapi-key':
                '62a3289a18mshae4f62227441f27p1e1607jsn952d6b5a04ca',
            'x-rapidapi-host': 'world-clock.p.rapidapi.com',
            'useQueryString': 'true'
          },
      );
      TimeApi time = TimeApi.fromJson(jsonDecode(response.body));
      return ApiResponse(data: time, error:false);
    } on SocketException catch (s) {
      return ApiResponse(data: 'Network error', error: true);
    } catch (e) {
      print(e);
      return ApiResponse(data: 'Unable to fetch data at the moment', error: true);
    }
  }

}
