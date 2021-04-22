import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/model/category.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';
import 'package:ni_trades/repository/data_repo.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  late StreamSubscription<Wallet> _walletSubscription;
  late StreamSubscription<List<Investment>> _recentInvestmentsSubscription;

  DataBloc({required this.dataService}) : super(DataInitial()) {
    _walletSubscription =
        dataService.fetchUserWallet(userId: AuthBloc.uid!).listen(
              (wallet) => add(UserWalletFetchedEvent(wallet)),
            );
    _recentInvestmentsSubscription = dataService
        .investments(AuthBloc.uid!)
        .listen(
            (investments) => add(RecentInvestmentsFetchedEvent(investments)));
  }

  late DataService dataService;

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is FetchInvestmentPackagesEvent) {
      yield* _mapFetchInvestmentEventToState(event.categoryId);
    }

    if (event is FetchUserInvestmentsEvent) {
      yield* _mapFetchUserInvestmentsEventToState(event.userId);
    }

    if (event is RecentInvestmentsFetchedEvent) {
      yield UserInvestmentsFetchedState(event.investments);
    }

    if (event is InvestEvent) {
      yield* _mapInvestEventToState(event.investment);
    }

    if (event is FetchUserDetailsEvent) {
      yield* _mapFetchUserDetailsEvent(event.uid);
    }

    if (event is FetchUserWalletEvent) {
      yield* _mapFetchUserWalletEventToState(event.uid);
    }

    if (event is UserWalletFetchedEvent) {
      yield UserWalletFetchedState(event.wallet);
    }

    if (event is FundWalletEvent) {
      yield* _mapFundWalletEventToState(event.amount, event.userId);
    }

    if (event is FetchCategoriesEvent) {
      yield* _mapFetchCategoriesEvent();
    }

    if (event is LoadTransactionsEvent) {
      yield* _mapTransactionsLoadingEventToState();
    }
  }

  @override
  Future<void> close() {
    _walletSubscription.cancel();
    _recentInvestmentsSubscription.cancel();
    return super.close();
  }

  Stream<DataState> _mapFetchInvestmentEventToState(String categoryId) async* {
    yield FetchInvestmentPackagesLoadingState();
    var investments = await dataService.investmentsPackages(categoryId);
    yield InvestmentPackagesFetchedState(investments);
  }

  Stream<DataState> _mapInvestEventToState(investment) async* {
    yield InvestLoadingState();
    await Future.delayed(Duration(seconds: 2));
    var result = await dataService.invest(investment);
    if (result is String) {
      yield InvestedState(result);
    }
    if (result is FirebaseException) {
      yield InvestErrorState(result.message!);
    }
  }

  Stream<DataState> _mapFetchUserDetailsEvent(String uid) async* {
    yield UserDetailsLoadingState();
    var response = await dataService.getUserInfo(userId: uid);
    if (response is NIUser.User) {
      yield UserDetailsFetchedState(response);
    }

    if (response is FirebaseException) {
      yield UserDetailsErrorState(response.message!);
    }
  }

  Stream<DataState> _mapFetchUserWalletEventToState(String uid) async* {
    dataService.fetchUserWallet(userId: AuthBloc.uid!).listen(
          (wallet) => add(UserWalletFetchedEvent(wallet)),
        );
  }

  Stream<DataState> _mapFetchUserInvestmentsEventToState(String userId) async* {
    _recentInvestmentsSubscription = dataService
        .investments(AuthBloc.uid!)
        .listen(
            (investments) => add(RecentInvestmentsFetchedEvent(investments)));
  }

  Stream<DataState> _mapFundWalletEventToState(amount, userId) async* {
    await dataService.fundUserWallet(userId: userId, amount: amount);
  }

  Stream<DataState> _mapFetchCategoriesEvent() async* {
    yield CategoriesLoadingState();
    var response = await dataService.categories;
    if (response is SocketException) {
      yield FetchCategoriesErrorState(response.message);
    } else if (response is FirebaseException) {
      yield FetchCategoriesErrorState(response.message!);
    } else {
      yield CategoriesFetchedState(response);
    }
  }

  Stream<DataState> _mapTransactionsLoadingEventToState() async* {
    yield TransactionsLoadingState();
    var transactions = await dataService.transactions;
    if (transactions is FirebaseException) {
      yield TransactionsLoadErrorState(transactions.message!);
    } else {
      yield TransactionsLoadedState(transactions);
    }
  }
}
