import 'package:claimizer/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class LanguageRepository{

  Future<Either<Failures , void>> changeLang({required String languageCode});
  Future<Either<Failures , String?>> getSavedLanguage();
}