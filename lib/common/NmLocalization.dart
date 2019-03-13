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
      "tab_search": "検索",
      "tab_bookshelf": "本棚",
      "tab_settings": "設定"
    },
    'en': {
      'app_name': 'NovelMate',
      "tab_search": "Search",
      "tab_bookshelf": "Shelf",
      "tab_settings": "Settings"
    },
  };

  String get appName {
    return _localizedValues[locale.languageCode]['app_name'];
  }

  String get tabSearch {
    return _localizedValues[locale.languageCode]['tab_search'];
  }

  String get tabBookShelf {
    return _localizedValues[locale.languageCode]['tab_bookshelf'];
  }

  String get tabSettings {
    return _localizedValues[locale.languageCode]['tab_settings'];
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
