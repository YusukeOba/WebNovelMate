import 'dart:async';

/// 色テーマ
enum ColorPattern { white, black, sepia }

abstract class SettingRepository {
  /// フォントサイズの取得
  Future<double> getFontSize();

  /// フォントサイズの設定
  Future<void> setFontSize(double fontSize);

  /// ゴシック体かどうか
  Future<bool> isGothic();

  /// ゴシック体かどうかの設定
  Future<void> setGothic(bool useGothic);

  /// 色テーマの取得
  Future<ColorPattern> getColorPattern();

  /// 色テーマの設定
  Future<void> setColorPattern(ColorPattern colorPattern);

  /// 行間の設定
  Future<void> setLineHeight(double lineHeight);

  /// 行間の取得
  Future<double> getLineHeight();
}
