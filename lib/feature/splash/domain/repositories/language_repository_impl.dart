import 'package:claimizer/core/error/exceptions.dart';
import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/feature/splash/data/datasources/language_local_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_repository.dart';

class LanguageRepositoryImpl implements LanguageRepository{
  final LanguageLocalDataSource localDataSource;

  LanguageRepositoryImpl({required this.localDataSource});


  @override
  Future<Either<Failures, void>> changeLang({required String languageCode}) async{
    try{
      debugPrint('here');
      return Right(await localDataSource.changeLang(languageCode));
    }on CacheException{
      return Left(CashFailure(msg: 'error'.tr));
    }
  }

  @override
  Future<Either<Failures, String?>> getSavedLanguage() async{
    try{
      return Right(await localDataSource.getSavedLanguage());
    }on CacheException{
      return Left(CashFailure(msg: 'error'.tr));
    }
  }

}