import 'dart:io';

import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/common/repository/SettingRepository.dart';
import 'package:NovelMate/page/TextPage.dart';
import 'package:NovelMate/page/TextSettingPage.dart';
import 'package:NovelMate/widget/Alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// 画面遷移時のスタイ
enum TextPageTransitionType {
  // 続きから読む
  readContinue,
  // 最初から読む
  readTop,
  // 最後から読む
  readBottom
}

class TextPagerPage extends StatefulWidget {
  final List<EpisodeEntity> _episodes;

  final int _index;

  TextPagerPage(this._episodes, this._index);

  @override
  _TextPagerState createState() {
    return _TextPagerState(_TextPagerViewModel(_episodes, _index));
  }
}

class _TextPagerViewModel {
  /// この小説の総エピソード
  List<EpisodeEntity> _episodes;

  /// エピソードの本文
  Future<List<String>> _texts;

  /// 表示しているエピソードのインデックス値
  int _index;

  /// AppBar, BottomBarを出すかどうか
  bool _shownOuterView = true;

  PageController _pageController;

  double _rawSliderOffset = 0;
  double _sliderMin = 0;
  double _sliderMax = 0;

  FirstScrollPosition _firstScrollPosition = FirstScrollPosition.first;

  ValueNotifier<double> _sliderValueNotifier = ValueNotifier(0);

  bool _pageAnimating = false;

  bool _blockTapGesture = true;

  /// 文字色
  ValueNotifier<TextStyle> _textStyle = ValueNotifier(TextStyle());

  /// 背景色
  ValueNotifier<Color> _backgroundColor = ValueNotifier(sNMBackgroundColor);

  /// Sliderに表示するスクロール位置
  double get sliderOffset {
    print("sliderMax = " + _sliderMax.toString());
    print("sliderMin = " + _sliderMin.toString());
    print("sliderOffset = " + _rawSliderOffset.toString());
    // 下にオーバースクロールしている
    bool overScrollDown = _rawSliderOffset > _sliderMax;

    // 上にオーバースクロールしている
    bool overScrollUp = _rawSliderOffset < _sliderMin;

    if (overScrollDown) {
      print("over scroll down.");
      return _sliderMax - 1;
    }
    if (overScrollUp) {
      print("over scroll up.");
      return _sliderMin;
    }

    // 通常スクロール中
    return _rawSliderOffset;
  }

  /// 現在の話を取得
  EpisodeEntity get _currentEpisode {
    return _episodes[_index];
  }

  /// 次のエピソード
  /// 最後のエピソードの場合はnullを返却する
  int get _nextEpisodeIndex {
    int currentIndex = _index;

    //　最後のエピソード
    if (currentIndex + 1 >= _episodes.length) {
      return null;
    } else {
      return currentIndex + 1;
    }
  }

  /// 前のエピソード
  /// 最初のエピソードの場合はnullを返却する
  int get _prevEpisodeIndex {
    int currentIndex = _index;

    //　最初のエピソード
    if (currentIndex == 0) {
      return null;
    } else {
      return currentIndex - 1;
    }
  }

  String get _nextEpisodeName {
    if (_nextEpisodeIndex == null) {
      return null;
    }
    return _episodes[_nextEpisodeIndex].episodeName;
  }

  String get _prevEpisodeName {
    if (_prevEpisodeIndex == null) {
      return null;
    }
    return _episodes[_prevEpisodeIndex].episodeName;
  }

  _TextPagerViewModel(this._episodes, this._index) {
    this._pageController = PageController(initialPage: _index);
  }

  /// エピソード一覧から表示する(続きからよむもこのケース)
  void showByContinue() {
    print("start text fetch.");
    _texts = RepositoryFactory.shared
        .getTextRepository()
        .findByIdentifier(
            _currentEpisode.novelIdentifier, _currentEpisode.episodeIdentifier)
        .then((text) {
      print("finish text fetch.");
      // 大量の文字列を一気に表示するとViewのサイズが大きすぎるためListViewで表示したい
      // そのため改行コードで分割する
      List<String> texts = text.episodeText.split("\n");
      return Future.value(texts);
    });
  }

  void toggleOuterView() {
    _shownOuterView = !_shownOuterView;
    if (_shownOuterView) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      // フルスクリーン
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  void setOuterViewVisibility(bool visibility) {
    _shownOuterView = visibility;
    if (_shownOuterView) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      // フルスクリーン
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  /// フォント設定の変更
  void changeTextStyle(double fontSize, ColorPattern colorPattern,
      bool isGothic, double lineHeight) {
    Color textColor;
    switch (colorPattern) {
      case ColorPattern.white:
        textColor = Colors.black;
        _backgroundColor.value = Colors.white;
        break;
      case ColorPattern.black:
        textColor = Colors.white;
        _backgroundColor.value = Colors.black;
        break;
      case ColorPattern.sepia:
        textColor = Colors.black;
        _backgroundColor.value = sSepiaColor;
        break;
    }

    String fontFamily;
    if (isGothic) {
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
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: textColor,
        height: lineHeight);
    _textStyle.value = style;

    print("change. textStyle = " + style.toString());

    final repository = RepositoryFactory.shared.getSettingRepository();
    repository.setColorPattern(colorPattern);
    repository.setFontSize(fontSize);
    repository.setGothic(isGothic);
    repository.setLineHeight(lineHeight);
  }

  /// フォント設定の読み込み
  void loadInitialTextStyle() async {
    final repository = RepositoryFactory.shared.getSettingRepository();
    double fontSize = await repository.getFontSize();
    ColorPattern colorPattern = await repository.getColorPattern();
    bool isGothic = await repository.isGothic();
    double lineHeight = await repository.getLineHeight();
    changeTextStyle(fontSize, colorPattern, isGothic, lineHeight);
  }

  /// 最後に読んだエピソードの保存
  Future<void> updateReadingEpisode() {
    final repository = RepositoryFactory.shared.getBookshelfRepository();
    return repository.updateReadingEpisode(_currentEpisode.novelIdentifier,
        _currentEpisode.episodeIdentifier, _rawSliderOffset.toInt());
  }

  /// 画面に戻る前にフルスクリーン状態を解除し、最後に読んだエピソードを保存する
  willPop() async {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await updateReadingEpisode();
  }
}

class _TextPagerState extends State<TextPagerPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  _TextPagerViewModel _viewModel;

  _TextPagerState(this._viewModel);

  @override
  void initState() {
    super.initState();
    print("initState");
    setState(() {
      _viewModel.loadInitialTextStyle();
      _viewModel.showByContinue();

      // フルスクリーン
      SystemChrome.setEnabledSystemUIOverlays([]);
      WidgetsBinding.instance.addObserver(this);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _viewModel.updateReadingEpisode();
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: Stack(children: <Widget>[
              Positioned.fill(
                  top: _viewModel._shownOuterView ? kToolbarHeight : 0,
                  bottom: 0,
                  child: IgnorePointer(
                      ignoring: _viewModel._pageAnimating ||
                          _viewModel._blockTapGesture,
                      child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _viewModel._pageController,
                          itemCount: _viewModel._episodes.length,
                          itemBuilder: (context, position) {
                            return Container(
                                color: _viewModel._backgroundColor.value,
                                child: _buildTexts());
                          }))),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: _buildAppBar(),
                /*You can't put null in the above line since Stack won't allow that*/
              ),
            ]),
            bottomNavigationBar: _buildBottomBar()),
        onWillPop: () async {
          Navigator.pop(context, {
            "readingEpisodeIdentifier":
                _viewModel._currentEpisode.episodeIdentifier
          });
          return false;
        });
  }

  Widget _buildAppBar() {
    Widget appbar;
    Widget emptyBar;
    appbar = AppBar(
      title: IconButton(
          icon: Image.asset("images/font_sizing.png",
              width: 28, height: 28, color: Colors.white),
          onPressed: () {
            _showSetting();
          }),
      centerTitle: false,
    );
    emptyBar = SizedBox(height: 0);

    return _viewModel._shownOuterView ? appbar : emptyBar;
  }

  Widget _buildBottomBar() {
    Widget bottomBar;
    Widget emptyBar;
    bottomBar = SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: new BoxDecoration(
                border: new Border(
                    top: BorderSide(width: 0.5, color: Colors.black26))),
            child: Wrap(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(_viewModel._currentEpisode.episodeName,
                        style: TextStyle(fontSize: 11.0)),
                    Slider(
                        inactiveColor: sNMAccentColor,
                        activeColor: sNMPrimaryColor,
                        value: _viewModel.sliderOffset,
                        min: _viewModel._sliderMin,
                        max: _viewModel._sliderMax,
                        onChanged: (value) {
                          setState(() {
                            _viewModel._sliderValueNotifier.value = value;
                          });
                        })
                  ],
                )
              ],
            )));
    emptyBar = SizedBox(height: 0);

    return _viewModel._shownOuterView ? bottomBar : emptyBar;
  }

  Widget _buildTexts() {
    return FutureBuilder<List<String>>(
      future: _viewModel._texts,
      builder: (context, snapShot) {
        Widget rowWidget;
        // 読み込み中
        if (snapShot.connectionState == ConnectionState.active ||
            snapShot.connectionState == ConnectionState.none ||
            snapShot.connectionState == ConnectionState.waiting) {
          rowWidget = Container(
              color: _viewModel._backgroundColor.value,
              child: Center(child: CircularProgressIndicator()));
          _viewModel._blockTapGesture = true;
        } else {
          // エラー
          if (snapShot.hasError || !snapShot.hasData) {
            _viewModel._blockTapGesture = true;
            Future.delayed(Duration(milliseconds: 10), () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertUtils.networkError(context, () {
                      _viewModel.willPop();
                      Navigator.of(context).pop();
                    });
                  });
            });
            rowWidget = Container(
                color: _viewModel._backgroundColor.value,
                child: Center(child: CircularProgressIndicator()));
            _viewModel._blockTapGesture = true;
          } else {
            // 正常系
            _viewModel._blockTapGesture = false;
            rowWidget = TextPage(
              _viewModel._currentEpisode.episodeName,
              snapShot.data,
              // toggle tap
              () {
                setState(() {
                  _viewModel.toggleOuterView();
                });
              },
              // ScrollViewからの通知をSliderに反映
              (min, currentOffset, max) {
                setState(() {
                  _viewModel._sliderMin = min;
                  _viewModel._rawSliderOffset = currentOffset;
                  _viewModel._sliderMax = max;
                });
              },
              // Sliderからの通知をScrollViewに反映
              _viewModel._sliderValueNotifier,
              _viewModel._firstScrollPosition,
              _viewModel._backgroundColor,
              _viewModel._textStyle,
              nextActionCallback: () {
                setState(() {
                  showNextPage();
                });
              },
              prevActionCallback: () {
                setState(() {
                  showPrevPage();
                });
              },
              nextEpisodeName: _viewModel._nextEpisodeName,
              prevEpisodeName: _viewModel._prevEpisodeName,
            );
          }
        }

        // ちらつきを抑えるためクロスフェードで読み込み,実際のテキスト表示を切り替える
        return AnimatedSwitcher(
            child: rowWidget, duration: Duration(milliseconds: 200));
      },
    );
  }

  void showNextPage() async {
    if (_viewModel._nextEpisodeIndex != null) {
      setState(() {
        _viewModel._pageAnimating = true;
        _viewModel._index = _viewModel._nextEpisodeIndex;
        _viewModel._firstScrollPosition = FirstScrollPosition.first;
        _viewModel.showByContinue();
      });

      print((_viewModel._index).toString());
      await _viewModel._pageController
          .animateToPage(_viewModel._index,
              duration: Duration(milliseconds: 350), curve: Curves.easeInSine)
          .then((_) {
        setState(() {
          _viewModel._rawSliderOffset = 0;
          _viewModel._pageAnimating = false;
          _viewModel.updateReadingEpisode();
        });
      });
    }
  }

  void showPrevPage() async {
    if (_viewModel._prevEpisodeIndex != null) {
      setState(() {
        _viewModel._pageAnimating = true;
        _viewModel._index = _viewModel._prevEpisodeIndex;
        _viewModel._firstScrollPosition = FirstScrollPosition.bottom;
        _viewModel.showByContinue();
      });
      print((_viewModel._index).toString());
      await _viewModel._pageController
          .animateToPage(_viewModel._index,
              duration: Duration(milliseconds: 350), curve: Curves.easeInSine)
          .then((_) {
        setState(() {
          _viewModel._rawSliderOffset = 0;
          _viewModel._pageAnimating = false;
          _viewModel.updateReadingEpisode();
        });
      });
    }
  }

  void _showSetting() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(body: SettingContainer((double fontSize,
              ColorPattern colorPattern, bool isGothic, double lineHeight) {
            setState(() {
              _viewModel.changeTextStyle(
                  fontSize, colorPattern, isGothic, lineHeight);
            });
          }));
        });
  }
}
