import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/splash/domain/repositories/language_repository.dart';
import 'package:dartz/dartz.dart';

class GetSavedLanguageUseCase implements UseCase<String? , NoParams>{
  final LanguageRepository repository;

  GetSavedLanguageUseCase({required this.repository});


  @override
  Future<Either<Failures, String?>> call(NoParams params) async => await repository.getSavedLanguage();

}