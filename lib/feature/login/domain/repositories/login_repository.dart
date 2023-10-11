import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/feature/login/domain/entities/login.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {

  Future<Either<Failures , Login>> login(String email , String password);

  Future<void> saveUserInfo(String email , String name , String token);
}
