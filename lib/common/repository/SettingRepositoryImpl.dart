import 'package:NovelMate/common/repository/SettingRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepositoryImpl extends SettingRepository {
  final String keyFontSize = "key_font_size";
  final String keyColorPattern = "key_color_pattern";
  final String keyIsGothic = "key_is_gothic";
  final String keyLineHeight = "key_line_height";

  @override
  Future<double> getFontSize() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getDouble(keyFontSize) ?? 14;
    });
  }

  @override
  Future<void> setColorPattern(ColorPattern colorPattern) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(keyColorPattern, colorPattern.index);
  }

  @override
  Future<ColorPattern> getColorPattern() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawColorPattern = prefs.getInt(keyColorPattern) ?? 0;
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
    return prefs.getBool(keyIsGothic) ?? true;
  }

  @override
  Future<void> setFontSize(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (fontSize < 5 || fontSize > 40) {
      return Future.value();
    }
    return prefs.setDouble(keyFontSize, fontSize);
  }

  @override
  Future<double> getLineHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyLineHeight) ?? 1.0;
  }

  @override
  Future<void> setLineHeight(double lineHeight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lineHeight < 0 || lineHeight > 3) {
      return Future.value();
    }
    return prefs.setDouble(keyLineHeight, lineHeight);
  }
}
