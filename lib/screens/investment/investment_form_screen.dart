import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:ni_trades/util/my_utils.dart';

class InvestmentFormScreen extends StatefulWidget {
  final InvestmentPackage investmentPackage;

  InvestmentFormScreen({Key? key, required this.investmentPackage})
      : super(key: key);

  @override
  _InvestmentFormScreenState createState() => _InvestmentFormScreenState();
}

class _InvestmentFormScreenState extends State<InvestmentFormScreen> {
  final TextEditingController amountTextController = TextEditingController();

  late PaystackPlugin paystack;
  late int returnsAmount;
  late NumberFormat currencyFormatter;

  @override
  void initState() {
    initPayStack();
    returnsAmount = 0;
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 0,
      name: "₦",
    );
    super.initState();
  }

  void initPayStack() async {
    paystack = PaystackPlugin();
    await paystack.initialize(publicKey: Constants.PAYSTACK_PUBLIC_API);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Invest in ${widget.investmentPackage.title}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Center(
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Text(
              'How much do you want to invest on this?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextFormField(
                validator: (value) {
                  try {
                    if (double.parse(value!
                            .substring(1, value.length)
                            .replaceAll('₦', '')
                            .replaceAll(',', '')
                            .trim()) <
                        1000) {
                      return 'Minimum amount required is 1000';
                    }
                  } catch (e) {}

                  if (value!.isEmpty) {
                    return 'Amount must not be empty';
                  }
                },
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    // locale: 'en',
                    decimalDigits: 0,
                    symbol: '₦ ', // or to remove symbol set ''.
                  )
                ],
                onChanged: (v) {
                  setState(() {
                    int amount = int.parse(v
                        .substring(1, v.length)
                        .replaceAll('₦', '')
                        .replaceAll(',', '')
                        .trim());

                    int rate = widget.investmentPackage.returns;
                    returnsAmount = ((rate / 100) * amount).round();
                  });
                },
                controller: amountTextController,
                cursorColor: Theme.of(context).colorScheme.secondary,
                cursorHeight: 24,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.onPrimary),
                decoration: Constants.inputDecoration(context).copyWith(
                    hintText: 'Minimum of 1,000',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'At the end of ${widget.investmentPackage.durationInMonths} months, you will get returns worth of ${currencyFormatter.format(returnsAmount)}',
              style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
            SizedBox(
              height: 32.0,
            ),
            BlocConsumer<DataBloc, DataState>(
              listener: (context, state) {
                if (state is InvestedState) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'You have successfully invested in ${widget.investmentPackage.title}')));
                }

                if (state is InvestErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'You have successfully invested in ${widget.investmentPackage.title}')));
                }
              },
              builder: (context, state) {
                return MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    elevation: 1.0,
                    disabledColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: Theme.of(context).colorScheme.secondary,
                    // Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Investment investment = Investment(
                          id: '',
                          packageId: widget.investmentPackage.id,
                          userId: AuthBloc.uid!,
                          refId: '',
                          amount: int.parse(amountTextController.text
                              .substring(1, amountTextController.text.length)
                              .replaceAll('₦', '')
                              .replaceAll(',', '')
                              .trim()),
                          startDate: DateTime.now().millisecondsSinceEpoch,
                          active: true,
                          isDue: false);
                      invest(investment, paystack);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state is InvestLoadingState
                            ? Row(
                                children: [
                                  SpinKitDualRing(
                                      size: 24,
                                      lineWidth: 2,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        Text('Make Payment',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  void invest(Investment investment, PaystackPlugin paystackPlugin) async {
    var refId =
        await AppUtils.makePayment(context, paystackPlugin, investment.amount);

    if (refId != null) {
      context
          .read<DataBloc>()
          .add(InvestEvent(investment.copyWith(refId: refId)));
    }
  }
}
