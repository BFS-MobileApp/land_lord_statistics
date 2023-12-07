import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/feature/login/domain/entities/login.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/feature/login/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  final LoginUseCase loginUseCase;
  LoginCubit({required this.loginUseCase }) : super(LoginInitial());

  void initLoginPage() => emit(LoginInitial());


  Future<void> login(String email , String password) async{
    emit(LoginIsLoading());
    Either<Failures , Login> response = await loginUseCase(LoginParams(email: email, password: password));
    emit(response.fold(
            (failures) => LoginError(msg: failures.msg),
            (login) => LoginLoaded(login: login)));
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
