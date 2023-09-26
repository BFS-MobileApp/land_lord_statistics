part of 'setting_cubit.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class UserAccountsInitial extends SettingState {}

class UserAccountsLoading extends SettingState{}

class UserAccountsLoaded extends SettingState{

  final List<User> userAccounts;

  const UserAccountsLoaded({required this.userAccounts});

  @override
  List<Object> get props =>[userAccounts];
}

class UserAccountsError extends SettingState{
  final String msg;
  const UserAccountsError({required this.msg});

  @override
  List<Object> get props =>[msg];
}

class UserAccountChanged extends SettingState{
  final List<User> userAccounts;

  const UserAccountChanged({required this.userAccounts});

  @override
  List<Object> get props =>[userAccounts];
}