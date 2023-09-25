import 'package:bloc/bloc.dart';
import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/useraccounts/domain/entities/user.dart';
import 'package:claimizer/feature/useraccounts/domain/usecases/user_accounts_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'user_accounts_state.dart';

class UserAccountsCubit extends Cubit<UserAccountsState> {

  final UserAccountsUseCase userAccountsUseCase;
  UserAccountsCubit({required this.userAccountsUseCase}) : super(UserAccountsInitial());

  Future<void> getData() async{
    emit(UserAccountsLoading());
    Either<Failures , List<User>> response = await userAccountsUseCase(NoParams());
    emit(response.fold((failures) => UserAccountsError(msg: mapFailureToMsg(failures)), (accounts) => UserAccountsLoaded(userAccounts: accounts)));
  }

  String mapFailureToMsg(Failures failures){
    switch (failures.runtimeType){
      case ServerFailure:
        return AppStrings.serverError;
      case CashFailure:
        return AppStrings.cacheError;
      default:
        return AppStrings.unexpectedError;
    }
  }
}
