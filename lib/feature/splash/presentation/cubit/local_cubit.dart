import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/splash/domain/usecases/change_language.dart';
import 'package:claimizer/feature/splash/domain/usecases/get_saved_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'local_state.dart';

class LocalCubit extends Cubit<LocalState> {

  final GetSavedLanguageUseCase savedLanguageUseCase;
  final ChangeLanguageUseCase changeLanguageUseCase;

  LocalCubit({required this.savedLanguageUseCase,required this.changeLanguageUseCase}) : super(const ChangeLocalState(
      Locale(AppStrings.enCountryCode)
  ));

  String currentLangCode = AppStrings.enCountryCode;

  Future<void> getSavedLang() async {
    final response = await savedLanguageUseCase.call(NoParams());
    debugPrint('hi 2$response');
    response.fold((failure) => debugPrint(AppStrings.cacheError), (value) {
      currentLangCode = value!;
      emit(ChangeLocalState(Locale(currentLangCode)));
    });
  }

  Future<void> _changeLang(String langCode) async {
    final response = await changeLanguageUseCase.call(langCode);
    response.fold((failure) => debugPrint(AppStrings.cacheError), (value) {
      currentLangCode = langCode;
      debugPrint(currentLangCode);
      emit(ChangeLocalState(Locale(currentLangCode)));
    });
  }

  void toEnglish() => _changeLang(AppStrings.enCountryCode);

  void toArabic() => _changeLang(AppStrings.arCountryCode);
}
