import 'package:LandlordStatistics/core/error/failures.dart';
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
  final double sort;
  final String color;

  const StatisticCompanySettings({required this.uniqueId,required this.sort,required this.color});

  @override
  // TODO: implement props
  List<Object?> get props => [uniqueId , sort , color];
}

class StatisticCompanySortSettings extends Equatable{
  final List<String> companiesSort;


  const StatisticCompanySortSettings({required this.companiesSort});

  @override
  // TODO: implement props
  List<Object?> get props => [companiesSort];
}

class StatisticColumnSettings extends Equatable{
  final String uniqueId;
  final String color;
  final double sort;

  const StatisticColumnSettings({required this.uniqueId, required this.color , required this.sort});

  @override
  // TODO: implement props
  List<Object?> get props => [uniqueId , color];
}

class StatisticColumnSortSettings extends Equatable{
  final List<String> columnsSorts;

  const StatisticColumnSortSettings({required this.columnsSorts});

  @override
  // TODO: implement props
  List<Object?> get props => [columnsSorts];
}