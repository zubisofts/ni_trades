import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';

class AmountFormScreen extends StatefulWidget {
  final Function(String) onYieldValied;

  const AmountFormScreen({Key? key, required this.onYieldValied})
      : super(key: key);

  @override
  _AmountFormScreenState createState() => _AmountFormScreenState();
}

class _AmountFormScreenState extends State<AmountFormScreen> {
  late NumberFormat currencyFormatter;
  late var balance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "\u20A6",
    );
    context.read<DataBloc>().add(FetchUserWalletEvent(AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          SizedBox(
            height: 32.0,
          ),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              // controller: widget.dateTextController,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.date_range_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: 'Enter amount',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Amount is required';
                } else if (int.parse(value) > balance) {
                  return 'Balance is insuffient for the entered amount';
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // new LengthLimitingTextInputFormatter(5),
                // CardMonthInputFormatter()
              ],
              keyboardType: TextInputType.number,
              // maxLength: 5,
              onChanged: (value) {
                widget.onYieldValied(value);
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Text(
                'Current balance: ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              BlocBuilder<DataBloc, DataState>(
                buildWhen: (previous, current) =>
                    current is UserWalletFetchedState,
                builder: (context, state) {
                  if (state is UserWalletFetchedState) {
                    balance = state.wallet.balance;
                    return Text(
                      '${currencyFormatter.format(balance)}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    );
                  }
                  return Text(
                    '₦0.00',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
