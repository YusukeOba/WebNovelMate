import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// アプリ固有の国際化処理
class NmLocalizations {
  NmLocalizations(this.locale);

  final Locale locale;

  static NmLocalizations of(BuildContext context) {
    return Localizations.of<NmLocalizations>(context, NmLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'ja': {
      'app_name': 'NovelMate',
    },
    'en': {
      'app_name': 'NovelMate',
    },
  };

  String get appName {
    return _localizedValues[locale.languageCode]['app_name'];
  }
}

/// 文言リソースのハンドラ
class NmLocalizationsDelegate extends LocalizationsDelegate<NmLocalizations> {

  const NmLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["ja", "en"].contains(locale.languageCode);
  }

  @override
  Future<NmLocalizations> load(Locale locale) {
    // リソースの一括読み込みは時間がかかるので非同期で行う
    return SynchronousFuture<NmLocalizations>(NmLocalizations(locale));
  }

  /// 言語設定が切り替わった時など、文言を再読込するかどうか
  @override
  bool shouldReload(NmLocalizationsDelegate old) => false;
}
