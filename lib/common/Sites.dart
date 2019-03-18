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

}

/// 対応しているWebサイト
final List<Site> sAvailableSites = [Narou(), Kakuyomu()];

/// 小説家になろう
class Narou implements Site {


  @override
  String get identifier {
    return "narou";
  }

  @override
  Color get siteColor {
    return Colors.cyanAccent;
  }

  @override
  String get siteName {
    return "小説家になろう";
  }
}

/// カクヨム
class Kakuyomu implements Site {

  @override
  String get identifier {
    return "kakuyomu";
  }

  @override
  Color get siteColor {
    return Colors.lightBlue;
  }

  @override
  String get siteName {
    return "カクヨム";
  }
}
