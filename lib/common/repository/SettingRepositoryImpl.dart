import 'package:NovelMate/common/repository/SettingRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepositoryImpl extends SettingRepository {
  final String keyFontSize = "key_font_size";
  final String keyColorPattern = "key_color_pattern";
  final String keyIsGothic = "key_is_gothic";

  @override
  Future<double> getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyFontSize);
  }

  @override
  Future<void> setColorPattern(ColorPattern colorPattern) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(keyColorPattern, colorPattern.index);
  }

  @override
  Future<ColorPattern> getColorPattern() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawColorPattern = prefs.getInt(keyColorPattern);
    return ColorPattern.values[rawColorPattern];
  }

  @override
  Future<void> setGothic(bool useGothic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyIsGothic, useGothic);
  }

  @override
  Future<bool> isGothic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsGothic);
  }

  @override
  Future<void> setFontSize(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(keyFontSize, fontSize);
  }
}
