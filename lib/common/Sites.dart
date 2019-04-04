import 'dart:ui';

import 'package:flutter/material.dart';

/// 対応webサイト固有のIF
abstract class Site {
  // HashMap識別用のHashCode
  @override
  int get hashCode;

  // 小説サイト固有の文言
  String get identifier;

  // 小説サイトの名称
  String get siteName;

  // 小説サイトのテーマカラー
  Color get siteColor;

  // 小説サイトのテキストカラー
  Color get textColor;

  @override
  bool operator ==(other) =>
      other is Site && other.identifier == this.identifier;
}

/// 対応しているWebサイト
class AvailableSites {
  static final _Narou narou = _Narou();
  static final _Kakuyomu kakuyomu = _Kakuyomu();
  static final _Aozora aozora = _Aozora();
}

/// 小説家になろう
class _Narou implements Site {
  static const _identifier = "narou";

  @override
  String get identifier {
    return _identifier;
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

  @override
  int get hashCode {
    return 1;
  }

  @override
  bool operator ==(other) =>
      other is Site && other.identifier == this.identifier;
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

  @override
  int get hashCode {
    return 2;
  }

  @override
  bool operator ==(other) =>
      other is Site && other.identifier == this.identifier;
}

/// 青空文庫
class _Aozora implements Site {
  @override
  String get identifier {
    return "aozora";
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
    return "青空文庫";
  }

  @override
  int get hashCode {
    return 3;
  }

  @override
  bool operator ==(other) =>
      other is Site && other.identifier == this.identifier;
}
