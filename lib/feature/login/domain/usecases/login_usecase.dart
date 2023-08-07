import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/login/domain/entities/login.dart';
import 'package:claimizer/feature/login/domain/repositories/login_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<Login , LoginParams>{

  final LoginRepository loginRepository;
  LoginUseCase({required this.loginRepository});

  @override
  Future<Either<Failures, Login>> call(LoginParams params) => loginRepository.login(params.email, params.password);
  
}