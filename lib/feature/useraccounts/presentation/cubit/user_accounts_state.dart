part of 'user_accounts_cubit.dart';

abstract class UserAccountsState extends Equatable {
  const UserAccountsState();

  @override
  List<Object> get props => [];
}

class UserAccountsInitial extends UserAccountsState {}

class UserAccountsLoading extends UserAccountsState{}

class UserAccountsLoaded extends UserAccountsState{

  final List<User> userAccounts;

  const UserAccountsLoaded({required this.userAccounts});

  @override
  List<Object> get props =>[userAccounts];
}

class UserAccountsError extends UserAccountsState{
  final String msg;
  const UserAccountsError({required this.msg});

  @override
  List<Object> get props =>[msg];
}

class UserAccountChanged extends UserAccountsState{
  final List<User> userAccounts;

  const UserAccountChanged({required this.userAccounts});

  @override
  List<Object> get props =>[userAccounts];
}