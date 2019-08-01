import 'package:flutter/cupertino.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class UserLanguageLocalizationDelegate extends LocalizationsDelegate<UserLanguage>{

  final Locale locale;
  UserLanguageLocalizationDelegate({@required this.locale});

  final List<String> supportLocalize = [
    ConstantCollections.LANGUAGE_EN,
    ConstantCollections.LANGUAGE_ID
  ];

  @override
  bool isSupported(Locale locale) => supportLocalize.contains(locale.languageCode);

  @override
  Future<UserLanguage> load(Locale locale) => UserLanguage.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<UserLanguage> old) {
    return false;
  }
}