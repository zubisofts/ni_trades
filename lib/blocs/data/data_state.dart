part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}

class FetchInvestmentPackagesLoadingState extends DataState {}

class FetchInvestmentPackagesErrorState extends DataState {
  final String error;

  FetchInvestmentPackagesErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class InvestmentPackagesFetchedState extends DataState {
  final List<InvestmentPackage> investments;

  InvestmentPackagesFetchedState(this.investments);

  @override
  List<Object> get props => [investments];
}

// User Investments
class FetchUserInvestmentsLoadingState extends DataState {}

class FetchUserInvestmentsErrorState extends DataState {
  final String error;

  FetchUserInvestmentsErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class UserInvestmentsFetchedState extends DataState {
  final List<Investment> investments;

  UserInvestmentsFetchedState(this.investments);

  @override
  List<Object> get props => [investments];
}

// End of User Investments

// Make investment state

class InvestLoadingState extends DataState {}

class InvestErrorState extends DataState {
  final String error;

  InvestErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class InvestedState extends DataState {
  final String id;

  InvestedState(this.id);

  @override
  List<Object> get props => [id];
}
// End of make investment state

// FetchUserState
class UserDetailsFetchedState extends DataState {
  final NIUser.User user;

  UserDetailsFetchedState(this.user);

  @override
  List<Object> get props => [user];
}

class UserDetailsLoadingState extends DataState {}

class UserDetailsErrorState extends DataState {
  final String error;

  UserDetailsErrorState(this.error);
}
// End of UetchUserDetailsState

// User wallet states
class UserWalletFetchedState extends DataState {
  final Wallet wallet;

  UserWalletFetchedState(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class FetchWalletErrorState extends DataState {
  final String error;

  FetchWalletErrorState(this.error);

  @override
  List<Object> get props => [error];
}

// Categories states
class CategoriesFetchedState extends DataState {
  final List<Category> categories;

  CategoriesFetchedState(this.categories);

  @override
  List<Object> get props => [categories];
}

class FetchCategoriesErrorState extends DataState {
  final String error;

  FetchCategoriesErrorState(this.error);
  @override
  List<Object> get props => [error];
}

class CategoriesLoadingState extends DataState {}

class TransactionsLoadingState extends DataState {}

class TransactionsLoadErrorState extends DataState {
  final String error;

  TransactionsLoadErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class TransactionsLoadedState extends DataState {
  final List<NiTransacton> transactions;

  TransactionsLoadedState(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class WalletFundLoadingState extends DataState {}

class WalletFundSuccessfulState extends DataState {}

class WalletFundFailureState extends DataState {
  final String error;

  WalletFundFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class InvestViaWalletLoadingState extends DataState {}

class InvestViaWalletSuccessfulState extends DataState {}

class InvestViaWalletFailureState extends DataState {
  final String error;

  InvestViaWalletFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class VerifyAccountLoadingState extends DataState {}

class VerifyAccountSuccessfulState extends DataState {
  final String message;

  VerifyAccountSuccessfulState(this.message);

  @override
  List<Object> get props => [message];
}

class VerifyAccountFailureState extends DataState {
  final String error;

  VerifyAccountFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class UpdateUserPhotoLoadingState extends DataState{}

class UserPhotoUpdatedState extends DataState {
  final String message;

  UserPhotoUpdatedState(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateUserPhotoFailureState extends DataState {
  final String error;

  UpdateUserPhotoFailureState(this.error);

  @override
  List<Object> get props => [error];
}
