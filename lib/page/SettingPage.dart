import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/common/repository/SettingRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnSettingChanged = void Function(
    double fontSize, ColorPattern _colorPattern, bool _isGothic);

class SettingContainer extends StatefulWidget {
  OnSettingChanged _onSettingChanged;

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
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: <Widget>[
                        _buildFontSize(),
                        _buildFontType(),
                        _buildColorPattern()
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
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        Divider(),
        ListTile(
          leading: Icon(Icons.exposure_plus_1),
          title: Text("大きくする"),
          onTap: () {
            _viewModel._fontSize += 1;
            _viewModel._onSettingChanged(
              _viewModel._fontSize,
              _viewModel._colorPattern,
              _viewModel._isGothic,
            );
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
            );
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
        Divider(),
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
              );
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
              );
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
        Divider(),
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
                        );
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
                      );
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
                      );
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
}
