import 'package:NovelMate/common/Sites.dart';
import 'package:flutter/material.dart';

final dummySite = DummySite();

class DummySite extends Site {
  @override
  String get identifier => "DummyNovels";

  @override
  Color get textColor => Colors.red;

  @override
  Color get siteColor => Colors.amber;

  @override
  String get siteName => "ダミー小説サイト";

  DummySite();
}
