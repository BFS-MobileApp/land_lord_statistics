import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/splash/domain/repositories/language_repository.dart';
import 'package:dartz/dartz.dart';

class ChangeLanguageUseCase implements UseCase<void , String>{
  final LanguageRepository repository;

  ChangeLanguageUseCase({required this.repository});


  @override
  Future<Either<Failures, void>> call(String languageCode) async => await repository.changeLang(languageCode: languageCode);

}