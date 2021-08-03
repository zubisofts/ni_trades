
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/bank.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_withdraw_request.dart';
import 'package:ni_trades/repository/payment_repository.dart';
import 'package:ni_trades/screens/withdrawal/widgets/bank_selection_widget.dart';
import 'package:ni_trades/util/my_utils.dart';

class SelectionForm extends StatefulWidget {
  final Investment investment;
  const SelectionForm(this.investment, {Key? key});

  @override
  _SelectionFormState createState() => _SelectionFormState();
}

class _SelectionFormState extends State<SelectionForm> {
  Future<List<Bank>> banks() async {
    var list = await PaymentRepository().getBankList;
    return list;
  }

  late List<Bank> bankList;
  String accountNumber = '';
  String code = '';

  @override
  void initState() {
    banks().then((value) => bankList = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Destination',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          SizedBox(
            height: 16.0,
          ),
          BlocListener<DataBloc, DataState>(
            // listenWhen: (previous, current) =>
            //     current is InvestmentWithdrawalRequestLoadingState ||
            //     current is InvestmentWithdrawalRequestErrorState ||
            //     current is InvestmentWithdrawalRequestSentState,
            listener: (context, state) {
              if (state is InvestmentWithdrawalRequestLoadingState) {
                AppUtils.showLoaderDialog(context, "Sending request...");
              }

              if (state is InvestmentWithdrawalRequestErrorState) {
                Navigator.of(context).pop();
                AppUtils.showErrorDialog(context, state.error);
              }

              if (state is InvestmentWithdrawalRequestSentState) {
                Navigator.of(context).pop();
                AppUtils.showSuccessDialog(context, state.message);
              }

              if (state is VerifyAccountLoadingState) {
                AppUtils.showLoaderDialog(
                    context, "Verifying account details...");
              }

              if (state is VerifyAccountFailureState) {
                Navigator.of(context).pop();
                AppUtils.showErrorDialog(context, state.error);
              }

              if (state is VerifyAccountSuccessfulState) {
                Navigator.of(context).pop();
                var request = InvestmentWithdrawRequest(
                    id: '',
                    accountName: '',
                    amount: widget.investment.amount,
                    accountNumber: '',
                    bankCode: '',
                    userId: AuthBloc.uid!,
                    destination: 'wallet',
                    investmentId: widget.investment.id,
                    status: WithdrawalStatus.Pending,
                    timestamp: 0);
                showContinueDialog(context, request);
              }
            },
            child: ListTile(
              leading: Icon(
                Icons.payment_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              title: Text(
                'To Wallet',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onTap: () {
                var investmentWithdrawRequest = InvestmentWithdrawRequest(
                    id: '',
                    accountName: '',
                    amount: widget.investment.amount,
                    accountNumber: '',
                    bankCode: '',
                    userId: AuthBloc.uid!,
                    destination: 'wallet',
                    investmentId: widget.investment.id,
                    status: WithdrawalStatus.Pending,
                    timestamp: 0);

                context.read<DataBloc>().add(
                    SendInvestmentWithdrawalEvent(investmentWithdrawRequest));
                Navigator.of(context).pop();
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_balance,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            title: Text(
              'To Bank Account',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            onTap: () {
              showMaterialModalBottomSheet(
                context: context,
                expand: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0))),
                builder: (context) => Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    BankSelectionScreen(
                        onYieldValue: (bankCode, number) {
                          accountNumber = number;
                          code = bankCode;
                        },
                        bankList: bankList),
                    MaterialButton(
                      onPressed: () {
                        if (code.isEmpty) {
                          AppUtils.showErrorDialog(
                              context, "Please select your bank");
                          // return;
                        } else if (accountNumber.isEmpty) {
                          AppUtils.showErrorDialog(
                              context, "Please enter account number");
                          // return;
                        } else {
                          context.read<DataBloc>().add(
                              VerifyAccountDetialsEvent(accountNumber, code));
                        }
                      },
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      minWidth: MediaQuery.of(context).size.width * 0.85,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Send Request',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    )
                  ],
                ),
              );

              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void showContinueDialog(
      BuildContext context, InvestmentWithdrawRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Confirm',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green),
        ),
        content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: 'Confirm if ',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16.0,
                    fontFamily: 'Poppins-Medium'),
              ),
              TextSpan(
                text: '${request.accountName}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Poppins-Medium'),
              ),
              TextSpan(
                text: ' matches your account information...',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16.0,
                    fontFamily: 'Poppins-Medium'),
              )
            ])),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                context
                    .read<DataBloc>()
                    .add(SendInvestmentWithdrawalEvent(request));
              },
              child: Text(
                'Continue',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ))
        ],
      ),
    );
  }
}
