import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/model/api_response.dart';
import 'package:ni_trades/model/category.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/repository/payment_repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  late StreamSubscription<Wallet> _walletSubscription;
  late StreamSubscription<List<Investment>> _recentInvestmentsSubscription;

  DataBloc({required this.dataService}) : super(DataInitial()) {
    _walletSubscription = dataService.userWallet(userId: AuthBloc.uid!).listen(
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
      yield* _mapInvestEventToState(
          event.investment, event.context, event.card);
    }

    if (event is InvestViaWalletEvent) {
      yield* _investViaWalletEventToState(event.investment);
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
      yield* _mapFundWalletEventToState(
          event.amount, event.context, event.paymentCard);
    }

    if (event is FetchCategoriesEvent) {
      yield* _mapFetchCategoriesEvent();
    }

    if (event is LoadTransactionsEvent) {
      yield* _mapTransactionsLoadingEventToState();
    }

    if (event is VerifyAccountDetialsEvent) {
      yield* _verifyAccountDetialsEventToState(
          event.accountNumber, event.bankCode);
    }

    if (event is UpdateUserPhotoEvent) {
      yield* _mapUpdateUserPhotoEventToState(event.user, event.photo);
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

  Stream<DataState> _mapInvestEventToState(
      investment, BuildContext context, PaymentCard card) async* {
    yield InvestLoadingState();
    await Future.delayed(Duration(seconds: 2));
    var result = await dataService.invest(context, investment, card);
    if (!result.error) {
      yield InvestedState(result.data);
    } else {
      yield InvestErrorState(result.data!);
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
    dataService.userWallet(userId: AuthBloc.uid!).listen(
          (wallet) => add(UserWalletFetchedEvent(wallet)),
        );
  }

  Stream<DataState> _mapFetchUserInvestmentsEventToState(String userId) async* {
    _recentInvestmentsSubscription = dataService
        .investments(AuthBloc.uid!)
        .listen(
            (investments) => add(RecentInvestmentsFetchedEvent(investments)));
  }

  Stream<DataState> _mapFundWalletEventToState(amount, context, card) async* {
    yield WalletFundLoadingState();
    ApiResponse apiResponse =
        await dataService.fundWallet(amount, context, card);
    if (!apiResponse.error) {
      yield WalletFundSuccessfulState();
    } else {
      yield WalletFundFailureState(apiResponse.data);
    }
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

  Stream<DataState> _investViaWalletEventToState(Investment investment) async* {
    yield InvestLoadingState();
    await Future.delayed(Duration(seconds: 2));
    var result = await dataService.investViaWallet(investment);
    if (!result.error) {
      yield InvestViaWalletSuccessfulState();
    } else {
      yield InvestErrorState(result.data!);
    }
  }

  Stream<DataState> _verifyAccountDetialsEventToState(
      String accountNumber, String bankCode) async* {
    yield VerifyAccountLoadingState();
    ApiResponse response =
        await PaymentRepository().verifyAccount(accountNumber, bankCode);
    print(response.data);
    if (response.error) {
      yield VerifyAccountFailureState(response.data);
    } else {
      yield VerifyAccountSuccessfulState(response.data);
    }
  }

  Stream<DataState> _mapUpdateUserPhotoEventToState(
      NIUser.User user, File photo) async* {
    yield UpdateUserPhotoLoadingState();
    ApiResponse res =
        await dataService.updateUserPhoto(user: user, photo: photo);
    if (res.error) {
      yield UpdateUserPhotoFailureState(res.data);
    } else {
      yield UserPhotoUpdatedState(res.data);
    }
  }
}
