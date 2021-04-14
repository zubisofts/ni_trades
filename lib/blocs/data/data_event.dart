part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class FetchInvestmentPackagesEvent extends DataEvent {
  final String categoryId;

  FetchInvestmentPackagesEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class FetchUserInvestmentsEvent extends DataEvent {
  final String userId;

  FetchUserInvestmentsEvent({required this.userId});
  @override
  List<Object> get props => super.props;
}

class InvestEvent extends DataEvent {
  final Investment investment;

  InvestEvent(this.investment);

  @override
  List<Object> get props => [investment];
}

class FetchUserDetailsEvent extends DataEvent {
  final String uid;

  FetchUserDetailsEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class FetchUserWalletEvent extends DataEvent {
  final String uid;

  FetchUserWalletEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class UserWalletFetchedEvent extends DataEvent {
  final Wallet wallet;

  UserWalletFetchedEvent(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class RecentInvestmentsFetchedEvent extends DataEvent {
  final List<Investment> investments;

  RecentInvestmentsFetchedEvent(this.investments);

  @override
  List<Object> get props => [investments];
}

class FundWalletEvent extends DataEvent {
  final String userId;
  final dynamic amount;

  FundWalletEvent({required this.userId, required this.amount});

  @override
  List<Object> get props => [userId, amount];
}

// Categories event
class FetchCategoriesEvent extends DataEvent {}
