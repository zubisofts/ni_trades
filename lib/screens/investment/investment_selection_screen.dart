import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/category.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/screens/investment/widgets/investment_package_widget.dart';

class InvestmentSelectionScreen extends StatefulWidget {
  @override
  _InvestmentSelectionScreenState createState() =>
      _InvestmentSelectionScreenState();
}

class _InvestmentSelectionScreenState extends State<InvestmentSelectionScreen> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchInvestmentPackagesEvent(categoryId: ''));
    context.read<DataBloc>().add(FetchCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Choose Package",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<DataBloc, DataState>(
              buildWhen: (previous, current) =>
                  current is CategoriesFetchedState,
              builder: (context, state) {
                if (state is CategoriesFetchedState) {
                  if (state.categories.isEmpty) {
                    return Text('There are no investments yet');
                  } else {
                    return CategoriesRow(state.categories);
                  }
                }

                if (state is FetchCategoriesErrorState) {
                  return Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<DataBloc>().add(FetchCategoriesEvent()),
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text('Reload'),
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
            Expanded(
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
                      }

                      return LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          if (constraints.maxWidth >= 736) {
                            return GridView.builder(
                              itemCount: state.investments.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16),
                              itemBuilder: (context, index) =>
                                  InvestmentPackageWidget(
                                investmentPackage: investmentPackages[index],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: investmentPackages.length,
                              itemBuilder: (context, index) =>
                                  InvestmentPackageWidget(
                                investmentPackage: investmentPackages[index],
                              ),
                            );
                          }
                        },
                      );
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
          ],
        ),
      ),
    );
  }
}

class CategoriesRow extends StatefulWidget {
  final List<Category> categories;

  CategoriesRow(this.categories);

  @override
  _CategoriesRowState createState() => _CategoriesRowState();
}

class _CategoriesRowState extends State<CategoriesRow> {
  int selectedItem = 0;
  List<Category> cats = [Category(id: '', name: 'All')];

  @override
  void initState() {
    cats.addAll(widget.categories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: cats.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = index;
                  });
                  context.read<DataBloc>().add(
                      FetchInvestmentPackagesEvent(categoryId: cats[index].id));
                },
                child: Chip(
                    backgroundColor: selectedItem == index
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).cardTheme.color,
                    label: Text(
                      '${cats[index].name}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    )),
              ),
            );
          },
        ));
  }
}
