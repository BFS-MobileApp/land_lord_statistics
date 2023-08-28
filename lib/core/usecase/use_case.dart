import 'package:claimizer/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {

  Future<Either<Failures , Type>> call(Params params);
}


class NoParams extends Equatable{

  @override
  List<Object?> get props => [];
}

class LoginParams extends Equatable{

  final String email;
  final String password;

  const LoginParams({required this.email,required this.password});
  @override
  List<Object?> get props => [email , password];
}

class StatisticDetailsParams extends Equatable{

  final String uniqueId;
  const StatisticDetailsParams({required this.uniqueId});

  @override
  // TODO: implement props
  List<Object?> get props => [uniqueId];
}

class StatisticCompanySettings extends Equatable{
  final String uniqueId;
  final int sort;
  final String color;

  const StatisticCompanySettings({required this.uniqueId,required this.sort,required this.color});

  @override
  // TODO: implement props
  List<Object?> get props => [uniqueId , sort , color];
}