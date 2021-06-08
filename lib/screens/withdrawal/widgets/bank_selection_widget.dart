
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ni_trades/model/bank.dart';

class BankSelectionScreen extends StatefulWidget {
  final Function(String, String) onYieldValue;

  BankSelectionScreen({required this.onYieldValue, required this.bankList});

  final List<Bank> bankList;

  @override
  _BankSelectionScreenState createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  String? selectedBank;
  late List<Bank> getBankList;
  String accountNumber = '';

  var accountNumberTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Text(
            'Account details',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  onChanged: (v) {
                    setState(() {
                      selectedBank = v;
                      widget.onYieldValue(v!, accountNumber);
                    });
                  },
                  // icon: Icon(Icons.home_filled),
                  value: selectedBank,
                  isExpanded: true,
                  hint: Text(
                    'Select your bank',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  items: widget.bankList
                      .map((bank) => DropdownMenuItem(
                          value: bank.code,
                          child: Text(
                            bank.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.onPrimary),
                          )))
                      .toList()),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: accountNumberTextController,
              onChanged: (value) {
                setState(() {
                  accountNumber = value;
                  widget.onYieldValue(selectedBank!, value);
                });
              },
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.payment,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: 'Account Number',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1),
                      borderRadius: BorderRadius.circular(8.0))),
              validator: MultiValidator([
                RequiredValidator(errorText: 'Account number is required'),
                MinLengthValidator(10, errorText: 'Invalid account number'),
              ]),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}