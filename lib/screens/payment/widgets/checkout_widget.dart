import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/util/my_utils.dart';

class CheckoutWidget extends StatefulWidget {
  final Investment investment;

  const CheckoutWidget({Key? key, required this.investment}) : super(key: key);

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  bool saveCard = false;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController cardNumberTextController = TextEditingController();
  TextEditingController dateTextController = TextEditingController();
  TextEditingController cvcTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
      ),
      child: Form(
        key: _form,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Pay with card',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: cardNumberTextController,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.payment,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        hintText: 'Card Number',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0))),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Card number is required'),
                      MinLengthValidator(16,
                          errorText:
                              'Card number must be at least 16 digits long'),
                    ]),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      CardNumberInputFormatter()
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ExpiryDateTextField(
                            dateTextController: dateTextController),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: cvcTextController,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              hintText: 'CVV',
                              hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              fillColor: Theme.of(context).cardColor,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0))),
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'CVC is required'),
                            MinLengthValidator(3,
                                errorText:
                                    'CVC must be at least 4 digits long'),
                            MaxLengthValidator(4,
                                errorText: 'CVC must be at least 4 digits long')
                          ]),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 8.0,
                  // ),
                  SwitchListTile.adaptive(
                    value: saveCard,
                    onChanged: (value) {
                      setState(() {
                        saveCard = value;
                      });
                    },
                    title: Text(
                      'Save card',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveTrackColor: Theme.of(context).cardColor,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      var validate = _form.currentState!.validate();
                      if (validate) {
                        invest(
                            widget.investment,
                            context,
                            PaymentCard(
                                number: cardNumberTextController.text,
                                // .replaceAll(' ', ''),
                                cvc: cvcTextController.text,
                                // expiryMonth: 4,
                                // expiryYear: 33,
                                expiryMonth: int.parse(
                                    dateTextController.text.substring(0, 2)),
                                expiryYear: int.parse(
                                    dateTextController.text.substring(3))));
                      }
                    },
                    disabledColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.4),
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      'PAY',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Secured by ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Image.asset(
                  'assets/icons/paystack.png',
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 100,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void invest(
      Investment investment, BuildContext context, PaymentCard card) async {
    print(card);
    context.read<DataBloc>().add(InvestEvent(investment, context, card));
  }
}

class ExpiryDateTextField extends StatefulWidget {
  const ExpiryDateTextField({
    Key? key,
    required this.dateTextController,
  }) : super(key: key);

  final TextEditingController dateTextController;

  @override
  _ExpiryDateTextFieldState createState() => _ExpiryDateTextFieldState();
}

class _ExpiryDateTextFieldState extends State<ExpiryDateTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateTextController,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.date_range_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          hintText: 'Expiry',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          fillColor: Theme.of(context).cardColor,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0))),
      validator: MultiValidator([
        RequiredValidator(errorText: 'CVC is required'),
        MinLengthValidator(5, errorText: 'Date must be at least 4 digits long'),
        MaxLengthValidator(5, errorText: 'Date must be at least 4 digits long')
      ]),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(5),
        CardMonthInputFormatter()
      ],
      keyboardType: TextInputType.number,
      maxLength: 5,
      onChanged: (value) {},
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
