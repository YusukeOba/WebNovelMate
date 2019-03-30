import 'dart:io';

import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/common/repository/SettingRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnSettingChanged = void Function(double fontSize,
    ColorPattern _colorPattern, bool _isGothic, double lineHeight);

/// 設定ページ
class SettingPage extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }
}

/// 設定ページ
class SettingState extends State<SettingPage> {
  double _fontSize;
  ColorPattern _colorPattern;
  bool _isGothic;
  double _lineHeight;

  @override
  void initState() {
    refreshPreview();
    super.initState();
  }

  refreshPreview() {
    setState(() {
      final repository = RepositoryFactory.shared.getSettingRepository();
      repository.getFontSize().then((value) {
        setState(() {
          _fontSize = value;
        });
      });
      repository.isGothic().then((isGothic) {
        setState(() {
          _isGothic = isGothic;
        });
      });
      repository.getColorPattern().then((colorPattern) {
        setState(() {
          _colorPattern = colorPattern;
        });
      });
      repository.getLineHeight().then((lineHeight) {
        setState(() {
          _lineHeight = lineHeight;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定"),
      ),
      body: Column(
        children: <Widget>[
          Container(height: 16.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "文字設定のプレビュー",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          _buildPreview(),
          Divider(),
          Expanded(child: Scrollbar(child: SingleChildScrollView(child:
              SettingContainer((fontSize, colorPattern, isGothic, lineHeight) {
            save(fontSize, colorPattern, isGothic, lineHeight);
          }))))
          // TODO: プレビュー実装
        ],
      ),
    );
  }

  Widget _buildPreview() {
    Color textColor;
    Color backgroundColor;

    if (_fontSize == null ||
        _colorPattern == null ||
        _isGothic == null ||
        _lineHeight == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    switch (_colorPattern) {
      case ColorPattern.white:
        textColor = Colors.black;
        backgroundColor = Colors.white;
        break;
      case ColorPattern.black:
        textColor = Colors.white;
        backgroundColor = Colors.black;
        break;
      case ColorPattern.sepia:
        textColor = Colors.black;
        backgroundColor = sSepiaColor;
        break;
    }

    String fontFamily;
    if (_isGothic) {
      if (Platform.isAndroid) {
        fontFamily = "";
      } else if (Platform.isIOS) {
        fontFamily = "Hiragino";
      }
    } else {
      if (Platform.isAndroid) {
        fontFamily = "SawarabiMincho";
      } else if (Platform.isIOS) {
        fontFamily = "Hiragino Mincho ProN";
      }
    }

    TextStyle style = TextStyle(
        fontSize: _fontSize,
        fontFamily: fontFamily,
        color: textColor,
        height: _lineHeight);

    return Container(
      color: backgroundColor,
      height: 128,
      padding: EdgeInsets.all(16),
      child: Text(
        "吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。"
            "何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。"
            "吾輩はここで始めて人間というものを見た。"
            "しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。"
            "この書生というのは時々我々を捕まえて煮て食うという話である。",
        style: style,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 設定値の保存
  save(double fontSize, ColorPattern colorPattern, bool isGothic,
      double lineHeight) async {
    final repository = RepositoryFactory.shared.getSettingRepository();
    repository.setColorPattern(colorPattern);
    repository.setFontSize(fontSize);
    repository.setGothic(isGothic);
    repository.setLineHeight(lineHeight);
    refreshPreview();
  }
}

/// 小説ページからでもつかえるように外部公開する
class SettingContainer extends StatefulWidget {
  final OnSettingChanged _onSettingChanged;

  SettingContainer(this._onSettingChanged);

  @override
  _SettingContainerState createState() {
    return _SettingContainerState(
        _SettingContainerViewModel(_onSettingChanged));
  }
}

class _SettingContainerViewModel {
  double _fontSize;

  ColorPattern _colorPattern;

  bool _isGothic;

  double _lineHeight;

  final OnSettingChanged _onSettingChanged;

  _SettingContainerViewModel(this._onSettingChanged);

  /// 設定値の読み込み
  void loadConfig() async {
    configLoaded = Future(() async {
      final repository = RepositoryFactory.shared.getSettingRepository();
      print("config load start.");
      _fontSize = await repository.getFontSize();
      print("load fontSize");
      _colorPattern = await repository.getColorPattern();
      print("load colorPattern");
      _isGothic = await repository.isGothic();
      print("load isGothic");
      _lineHeight = await repository.getLineHeight();
      print("load lineHeight");
      return Future.value(1);
    });
  }

  Future<int> configLoaded;
}

class _SettingContainerState extends State<SettingContainer> {
  final _SettingContainerViewModel _viewModel;

  _SettingContainerState(this._viewModel);

  @override
  void initState() {
    super.initState();

    setState(() {
      _viewModel.loadConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _viewModel.configLoaded,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return SingleChildScrollView(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: <Widget>[
                        _buildFontSize(),
                        _buildFontType(),
                        _buildColorPattern(),
                        _buildLineHeight()
                      ],
                    )));
          } else {
            return Container();
          }
        });
  }

  Widget _buildFontSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("文字サイズ",
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        ListTile(
          leading: Icon(Icons.exposure_plus_1),
          title: Text("大きくする"),
          onTap: () {
            _viewModel._fontSize += 1;
            _viewModel._onSettingChanged(
                _viewModel._fontSize,
                _viewModel._colorPattern,
                _viewModel._isGothic,
                _viewModel._lineHeight);
          },
        ),
        ListTile(
          leading: Icon(Icons.exposure_neg_1),
          title: Text("小さくする"),
          onTap: () {
            _viewModel._fontSize -= 1;
            _viewModel._onSettingChanged(
                _viewModel._fontSize,
                _viewModel._colorPattern,
                _viewModel._isGothic,
                _viewModel._lineHeight);
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _buildFontType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("フォント",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ListTile(
          leading: _viewModel._isGothic
              ? Icon(Icons.radio_button_unchecked)
              : Icon(Icons.radio_button_checked),
          title: Text("明朝体"),
          onTap: () {
            setState(() {
              _viewModel._isGothic = false;
              _viewModel._onSettingChanged(
                  _viewModel._fontSize,
                  _viewModel._colorPattern,
                  _viewModel._isGothic,
                  _viewModel._lineHeight);
            });
          },
        ),
        ListTile(
          leading: _viewModel._isGothic
              ? Icon(Icons.radio_button_checked)
              : Icon(Icons.radio_button_unchecked),
          title: Text("ゴシック体"),
          onTap: () {
            setState(() {
              _viewModel._isGothic = true;
              _viewModel._onSettingChanged(
                  _viewModel._fontSize,
                  _viewModel._colorPattern,
                  _viewModel._isGothic,
                  _viewModel._lineHeight);
            });
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _buildColorPattern() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("配色",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: RaisedButton(
                      child: Text("白"),
                      onPressed: () {
                        _viewModel._colorPattern = ColorPattern.white;
                        _viewModel._onSettingChanged(
                            _viewModel._fontSize,
                            _viewModel._colorPattern,
                            _viewModel._isGothic,
                            _viewModel._lineHeight);
                      },
                      color: Colors.white,
                      textColor: Colors.black,
                    ))),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: RaisedButton(
                    child: Text("黒"),
                    onPressed: () {
                      _viewModel._colorPattern = ColorPattern.black;
                      _viewModel._onSettingChanged(
                          _viewModel._fontSize,
                          _viewModel._colorPattern,
                          _viewModel._isGothic,
                          _viewModel._lineHeight);
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                  ),
                )),
            Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: RaisedButton(
                    child: Text("セピア"),
                    onPressed: () {
                      _viewModel._colorPattern = ColorPattern.sepia;
                      _viewModel._onSettingChanged(
                          _viewModel._fontSize,
                          _viewModel._colorPattern,
                          _viewModel._isGothic,
                          _viewModel._lineHeight);
                    },
                    color: sSepiaColor,
                    textColor: Colors.black,
                  )),
            ),
          ],
        ),
        Container(height: 8)
      ],
    );
  }

  /// 行間設定
  Widget _buildLineHeight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("行間",
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        ListTile(
          leading: Icon(Icons.exposure_plus_1),
          title: Text("大きくする"),
          onTap: () {
            _viewModel._lineHeight += 0.1;
            _viewModel._onSettingChanged(
                _viewModel._fontSize,
                _viewModel._colorPattern,
                _viewModel._isGothic,
                _viewModel._lineHeight);
          },
        ),
        ListTile(
          leading: Icon(Icons.exposure_neg_1),
          title: Text("小さくする"),
          onTap: () {
            _viewModel._lineHeight -= 0.1;
            _viewModel._onSettingChanged(
                _viewModel._fontSize,
                _viewModel._colorPattern,
                _viewModel._isGothic,
                _viewModel._lineHeight);
          },
        ),
        Divider(),
      ],
    );
  }
}
