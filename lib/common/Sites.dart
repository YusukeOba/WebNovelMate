import 'dart:ui';

import 'package:flutter/material.dart';

/// 対応webサイト固有のIF
abstract class Site {
  // 小説サイト固有の文言
  String get identifier;

  // 小説サイトの名称
  String get siteName;

  // 小説サイトのテーマカラー
  Color get siteColor;

  // 小説サイトのテキストカラー
  Color get textColor;

  @override
  int get hashCode {
    return identifier.hashCode;
  }

  @override
  bool operator ==(other) =>
      other is Site && other.identifier == this.identifier;
}

/// 対応しているWebサイト
class AvailableSites {
  static final _Narou narou = _Narou();
  static final _Kakuyomu kakuyomu = _Kakuyomu();
}

/// 小説家になろう
class _Narou implements Site {
  @override
  String get identifier {
    return "narou";
  }

  @override
  Color get siteColor {
    return Colors.cyanAccent;
  }

  @override
  Color get textColor {
    return Colors.black;
  }

  @override
  String get siteName {
    return "小説家になろう";
  }
}

/// カクヨム
class _Kakuyomu implements Site {
  @override
  String get identifier {
    return "kakuyomu";
  }

  @override
  Color get siteColor {
    return Colors.lightBlue;
  }

  @override
  Color get textColor {
    return Colors.black;
  }

  @override
  String get siteName {
    return "カクヨム";
  }
}
