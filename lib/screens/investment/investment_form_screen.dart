import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/screens/payment/widgets/checkout_widget.dart';
import 'package:ni_trades/util/constants.dart';

class InvestmentFormScreen extends StatefulWidget {
  final InvestmentPackage investmentPackage;

  InvestmentFormScreen({Key? key, required this.investmentPackage})
      : super(key: key);

  @override
  _InvestmentFormScreenState createState() => _InvestmentFormScreenState();
}

class _InvestmentFormScreenState extends State<InvestmentFormScreen> {
  final TextEditingController amountTextController = TextEditingController();

  late int returnsAmount;
  late NumberFormat currencyFormatter;

  var pageController = PageController(initialPage: 0, keepPage: true);

  int selectedPaymentSource = 0;

  @override
  void initState() {
    returnsAmount = 0;
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 0,
      name: "₦",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.0),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.0)),
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
                  Container(
                    height: 300,
                    child: PageView(
                      controller: pageController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        PayFormScreen(
                          textController: amountTextController,
                          investmentPackage: widget.investmentPackage,
                        ),
                        PaymentSelectionScreen(
                          onSelectionMade: (source) {
                            setState(() {
                              selectedPaymentSource = source;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          BlocConsumer<DataBloc, DataState>(
            listener: (context, state) async {
              if (state is InvestLoadingState) {
                showDialog(
                  context: context,
                  barrierColor: Theme.of(context).cardColor.withOpacity(0.3),
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(
                      child: SpinKitDualRing(
                        color: Theme.of(context).colorScheme.secondary,
                        lineWidth: 2,
                        size: 50,
                      ),
                    );
                  },
                );
              }

              if (state is InvestViaWalletSuccessfulState) {
                Navigator.of(context)..pop();
                AwesomeDialog(
                    context: context,
                    title: 'Success',
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.SCALE,
                    headerAnimationLoop: false,
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    dialogBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    btnOk: TextButton(
                      onPressed: () {
                        Navigator.of(context)..pop()..pop();
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text('Dismiss'),
                    )).show();
              }

              if (state is InvestedState) {
                Navigator.of(context)..pop();
                AwesomeDialog(
                    context: context,
                    title: 'Success',
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.SCALE,
                    headerAnimationLoop: false,
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    dialogBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    btnOk: TextButton(
                      onPressed: () {
                        Navigator.of(context)..pop()..pop()..pop()..pop();
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text('Dismiss'),
                    )).show();
              }

              if (state is InvestErrorState) {
                Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text('Sorry an error occured: ${state.error}')));

                //     Navigator.of(context)..pop();
                AwesomeDialog(
                    context: context,
                    title: 'Operation Failed',
                    dialogType: DialogType.ERROR,
                    animType: AnimType.SCALE,
                    headerAnimationLoop: false,
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    dialogBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    btnOk: TextButton(
                      onPressed: () {
                        Navigator.of(context)..pop();
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text('Dismiss'),
                    )).show();
              }
            },
            builder: (context, state) {
              return MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  elevation: 1.0,
                  disabledColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  // Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (pageController.page == 0) {
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    } else {
                      if (amountTextController.text.isEmpty) {
                        pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      } else {
                        Investment investment = Investment(
                            id: '',
                            packageId: widget.investmentPackage.id,
                            userId: AuthBloc.uid!,
                            refId: '',
                            amount: int.parse(amountTextController.text.trim()),
                            startDate: DateTime.now().millisecondsSinceEpoch,
                            duration: widget.investmentPackage.durationInMonths,
                            returns: widget.investmentPackage.returns,
                            status: InvestmentStatus.Pending,
                            isDue: false);
                        // invest(investment, paystack);

                        if (selectedPaymentSource == 0) {
                          context
                              .read<DataBloc>()
                              .add(InvestViaWalletEvent(investment));
                        } else {
                          showMaterialModalBottomSheet(
                            context: context,
                            // expand: false,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(16.0)),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            useRootNavigator: true,
                            builder: (context) => CheckoutWidget(
                              investment: investment,
                              paymentType: PaymentType.INVEST,
                            ),
                          );
                        }
                      }
                    }
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
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ],
                  ));
            },
          )
        ],
      ),
    );
  }
}

class PayFormScreen extends StatefulWidget {
  final InvestmentPackage investmentPackage;
  final TextEditingController textController;

  const PayFormScreen(
      {Key? key, required this.investmentPackage, required this.textController})
      : super(key: key);

  @override
  _PayFormScreenState createState() => _PayFormScreenState();
}

class _PayFormScreenState extends State<PayFormScreen> {
  late int returnsAmount;
  late NumberFormat currencyFormatter;

  @override
  void initState() {
    returnsAmount = 0;
    currencyFormatter = NumberFormat.currency(
      decimalDigits: 0,
      name: "₦",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'How much do you want to invest on this?',
          style: TextStyle(
              fontSize: 14, color: Theme.of(context).colorScheme.onPrimary),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TextFormField(
            validator: (value) {
              try {
                if (value!.isNotEmpty) {
                  if (double.parse(value) < 1000) {
                    return 'Minimum amount required is 1000';
                  }
                } else {
                  return 'Amount must not be empty';
                }
              } catch (e) {}
            },
            // inputFormatters: [
            //   CurrencyTextInputFormatter(
            // locale: 'en',
            // decimalDigits: 0,
            // symbol: '₦ ', // or to remove symbol set ''.
            // )
            // ],
            onChanged: (v) {
              setState(() {
                if (v.isNotEmpty) {
                  int amount = int.parse(v
                      // .substring(1, v.length)
                      // .replaceAll('₦', '')
                      // .replaceAll(',', '')
                      // .trim()
                      );

                  int rate = widget.investmentPackage.returns;
                  returnsAmount = ((rate / 100) * amount).round();
                }
              });
            },
            controller: widget.textController,
            cursorColor: Theme.of(context).colorScheme.secondary,
            keyboardType: TextInputType.number,
            cursorHeight: 24,
            style: TextStyle(
                fontSize: 18.0, color: Theme.of(context).colorScheme.onPrimary),
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
              fontSize: 14,
              // fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
        SizedBox(
          height: 32.0,
        ),
      ],
    );
  }
}

class PaymentSelectionScreen extends StatefulWidget {
  final Function(int) onSelectionMade;

  const PaymentSelectionScreen({Key? key, required this.onSelectionMade})
      : super(key: key);

  @override
  _PaymentSelectionScreenState createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Select Payment Source',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = 0;
                    widget.onSelectionMade(selectedItem);
                  });
                },
                child: PaymentSource(
                  isSelected: selectedItem == 0,
                  title: 'Wallet',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = 1;
                    widget.onSelectionMade(selectedItem);
                  });
                },
                child: PaymentSource(
                  isSelected: selectedItem == 1,
                  title: 'Card',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PaymentSource extends StatelessWidget {
  final String title;
  final bool isSelected;

  const PaymentSource({Key? key, required this.title, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
              width: 4,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent)),
      child: Container(
        margin: EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
