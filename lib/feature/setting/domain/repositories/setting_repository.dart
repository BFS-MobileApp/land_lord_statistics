import 'package:claimizer/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class SettingRepository {

  Future<Either<Failures , List<User>>> getUserAccounts();
}
