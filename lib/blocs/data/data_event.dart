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
  final BuildContext context;
  final PaymentCard card;

  InvestEvent(this.investment, this.context, this.card);

  @override
  List<Object> get props => [investment, context, card];
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
  final dynamic amount;
  final BuildContext context;
  final PaymentCard paymentCard;

  FundWalletEvent(this.context, this.paymentCard, {required this.amount});

  @override
  List<Object> get props => [amount, paymentCard, context];
}

// Categories event
class FetchCategoriesEvent extends DataEvent {}

// Transactions Event
class LoadTransactionsEvent extends DataEvent {}

class InvestViaWalletEvent extends DataEvent {
  final Investment investment;

  InvestViaWalletEvent(this.investment);

  @override
  List<Object> get props => [investment];
}

class VerifyAccountDetialsEvent extends DataEvent {
  final String accountNumber;
  final String bankCode;

  VerifyAccountDetialsEvent(this.accountNumber, this.bankCode);

  @override
  List<Object> get props => [accountNumber, bankCode];
}

class UpdateUserPhotoEvent extends DataEvent {
  final NIUser.User user;
  final File photo;

  UpdateUserPhotoEvent(this.user, this.photo);

  @override
  List<Object> get props => [user, photo];
}
