import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/screens/investment/investment_form_screen.dart';
import 'package:ni_trades/theme/app_theme.dart';

class InvestmentSelectionScreen extends StatefulWidget {
  @override
  _InvestmentSelectionScreenState createState() =>
      _InvestmentSelectionScreenState();
}

class _InvestmentSelectionScreenState extends State<InvestmentSelectionScreen> {
  InvestmentPackage? selectedPackage;
  ValueNotifier<InvestmentPackage?> packageNotifier = ValueNotifier(null);

  @override
  void initState() {
    context.read<DataBloc>().add(FetchInvestmentPackagesEvent(categoryId: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Theme.of(context)
        .appBarTheme
        .systemOverlayStyle!
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Choose Investment Package",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Hero(
        tag: 'fabToInvest',
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Container(
              child: BlocBuilder<DataBloc, DataState>(
                buildWhen: (previous, current) =>
                    current is InvestmentPackagesFetchedState ||
                    current is FetchInvestmentPackagesLoadingState ||
                    current is FetchInvestmentPackagesErrorState,
                builder: (context, state) {
                  if (state is InvestmentPackagesFetchedState) {
                    List<InvestmentPackage> investmentPackages =
                        state.investments;

                    if (investmentPackages.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'There are no investment packages at the moment, come back later',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    } else {
                      selectedPackage = investmentPackages[0];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ValueListenableBuilder<InvestmentPackage?>(
                            valueListenable: packageNotifier,
                            builder: (context, value, child) {
                              return value != null
                                  ? CachedNetworkImage(
                                      imageUrl: selectedPackage!.imageCoverUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox.shrink();
                            },
                          ),
                          BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                              ),
                              child: Container()),
                          PackagesView(investmentPackages, (package) {
                            selectedPackage = package;
                            packageNotifier.value = selectedPackage;
                          }),
                        ],
                      );
                    }

                    //   return LayoutBuilder(
                    //     builder:
                    //         (BuildContext context, BoxConstraints constraints) {
                    //       if (constraints.maxWidth >= 736) {
                    //         return GridView.builder(
                    //           itemCount: state.investments.length,
                    //           gridDelegate:
                    //               SliverGridDelegateWithFixedCrossAxisCount(
                    //                   crossAxisCount: 2,
                    //                   crossAxisSpacing: 16,
                    //                   mainAxisSpacing: 16),
                    //           itemBuilder: (context, index) =>
                    //               InvestmentPackageWidget(
                    //             investmentPackage: investmentPackages[index],
                    //           ),
                    //         );
                    //       } else {
                    //         return ListView.builder(
                    //           itemCount: investmentPackages.length,
                    //           itemBuilder: (context, index) =>
                    //               InvestmentPackageWidget(
                    //             investmentPackage: investmentPackages[index],
                    //           ),
                    //         );
                    //       }
                    //     },
                    //   );
                  }

                  if (state is FetchInvestmentPackagesLoadingState) {
                    return Center(
                      child: Center(
                        child: SpinKitDualRing(
                          color: Theme.of(context).iconTheme.color!,
                          lineWidth: 2,
                          size: 32,
                        ),
                      ),
                    );
                  }

                  if (state is FetchInvestmentPackagesErrorState) {
                    return Center(
                      child: Text(
                        'Error loading investmentd',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PackagesView extends StatefulWidget {
  final List<InvestmentPackage> packages;
  final Function(InvestmentPackage) onSelectPackage;

  PackagesView(this.packages, this.onSelectPackage);

  @override
  _PackagesViewState createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView> {
  late InvestmentPackage selectedItem;

  var pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    selectedItem = widget.packages[0];
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => widget.onSelectPackage(selectedItem));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        pageSnapping: true,
        physics: BouncingScrollPhysics(),
        controller: pageController,
        itemCount: widget.packages.length,
        onPageChanged: (index) {
          setState(() {
            selectedItem = widget.packages[index];
            widget.onSelectPackage(selectedItem);
          });
        },
        itemBuilder: (context, index) => PackageItemWidget(
              package: widget.packages[index],
              selectedItem: selectedItem,
            ));
  }
}

class PackageItemWidget extends StatefulWidget {
  final InvestmentPackage package;
  final InvestmentPackage selectedItem;

  const PackageItemWidget(
      {Key? key, required this.package, required this.selectedItem})
      : super(key: key);

  @override
  _PackageItemWidgetState createState() => _PackageItemWidgetState();
}

class _PackageItemWidgetState extends State<PackageItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Card(
        color: Color(widget.package.bgColor),
        elevation: widget.selectedItem == widget.package ? 4.0 : 1.0,
        clipBehavior: Clip.antiAlias,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //         width: 2,
        //         color: selectedItem == package
        //             ? Theme.of(context).colorScheme.secondary
        //             : Colors.transparent),
        //     borderRadius: BorderRadius.circular(8.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.black12),
                  child: Text(
                    '${widget.package.category}',
                    style: TextStyle(
                        color: AppTheme.getTextColor(
                            Color(widget.package.bgColor))),
                  )),
              SizedBox(
                height: 16.0,
              ),
              // SvgPicture.asset(
              //   getCategoryImage(widget.packages[index].category),
              //   width: 150,
              //   height: 150,
              //   colorBlendMode: BlendMode.multiply,
              // ),
              CachedNetworkImage(
                imageUrl: widget.package.imageCoverUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.4,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: [
                        Text(
                          '${widget.package.durationInMonths}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.getTextColor(
                                  Color(widget.package.bgColor)),
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Months',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.getTextColor(
                                  Color(widget.package.bgColor))),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Text(
                    '${widget.package.description}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: AppTheme.getTextColor(
                            Color(widget.package.bgColor))),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              OutlinedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  showMaterialModalBottomSheet(
                    context: context,
                    // expand: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    backgroundColor: Colors.transparent,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InvestmentFormScreen(
                          investmentPackage: widget.package),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    shape: StadiumBorder(),
                    side: BorderSide(
                        width: 2,
                        color: AppTheme.getTextColor(
                            Color(widget.package.bgColor)))),
                child: Text(
                  'Invest',
                  style: TextStyle(
                      color:
                          AppTheme.getTextColor(Color(widget.package.bgColor))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // String getCategoryImage(String category) {
  //   if (category == 'Agriculture') {
  //     return 'assets/icons/farm.svg';
  //   } else if (category == 'Fashion') {
  //     return 'assets/icons/fashion.svg';
  //   } else {
  //     return 'assets/icons/tech.svg';
  //   }
  // }

  // Color getCategoryColor(String category) {
  //   if (category == 'Agriculture') {
  //     return Color(0xFF2e7d32);
  //   } else if (category == 'Fashion') {
  //     return Colors.yellow;
  //   } else {
  //     return Color(0xFFaf4448);
  //   }
  // }
}
