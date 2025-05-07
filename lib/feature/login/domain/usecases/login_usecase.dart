import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/login/domain/entities/login.dart';
import 'package:LandlordStatistics/feature/login/domain/repositories/login_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<Login , LoginParams>{

  final LoginRepository loginRepository;
  LoginUseCase({required this.loginRepository});

  @override
  Future<Either<Failures, Login>> call(LoginParams params) => loginRepository.login(params.email, params.password);
  
}