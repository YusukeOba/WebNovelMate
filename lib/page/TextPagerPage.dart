import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/page/TextPage.dart';
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
    _texts = RepositoryFactory.shared
        .getTextRepository()
        .findByIdentifier(
            _currentEpisode.novelIdentifier, _currentEpisode.episodeIdentifier)
        .then((text) {
      // 大量の文字列を一気に表示するとViewのサイズが大きすぎるためListViewで表示したい
      // そのため改行コードで分割する
      List<String> texts = text.episodeText.split("\n");
      return Future.value(texts);
    });
  }

  void toggleOuterView() {
    _shownOuterView = !_shownOuterView;
  }

  void setOuterViewVisibility(bool visibility) {
    _shownOuterView = visibility;
  }
}

class _TextPagerState extends State<TextPagerPage>
    with TickerProviderStateMixin {
  _TextPagerViewModel _viewModel;

  _TextPagerState(this._viewModel);

  @override
  void initState() {
    super.initState();
    print("initState");
    setState(() {
      _viewModel.showByContinue();
      // フルスクリーン
      SystemChrome.setEnabledSystemUIOverlays([]);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: Stack(children: <Widget>[
              Positioned.fill(
                  top: _viewModel._shownOuterView ? kToolbarHeight : 0,
                  bottom: 0,
                  child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _viewModel._pageController,
                      itemCount: _viewModel._episodes.length,
                      itemBuilder: (context, position) {
                        return Container(
                            color: sNMAccentColor, child: _buildTexts());
                      })),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: _buildAppBar(),
                /*You can't put null in the above line since Stack won't allow that*/
              )
            ]),
            bottomNavigationBar: _buildBottomBar()),
        onWillPop: () {
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          Navigator.of(context).pop();
        });
  }

  Widget _buildAppBar() {
    Widget appbar;
    if (_viewModel._shownOuterView) {
      appbar = AppBar(
        title: IconButton(
            icon: Image.asset("images/font_sizing.png",
                width: 28, height: 28, color: Colors.white),
            onPressed: () {
              // TODO: implement
            }),
        centerTitle: false,
      );
    } else {
      appbar = SizedBox(height: 0);
    }

    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 200),
      child: appbar,
      curve: Curves.ease,
    );
  }

  Widget _buildBottomBar() {
    Widget bottomBar;
    if (_viewModel._shownOuterView) {
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
    } else {
      bottomBar = SizedBox(height: 0);
    }

    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 200),
      child: bottomBar,
      curve: Curves.ease,
    );
  }

  Widget _buildTexts() {
    return FutureBuilder<List<String>>(
      future: _viewModel._texts,
      builder: (context, snapShot) {
        // 読み込み中
        if (!snapShot.hasData ||
            snapShot.connectionState == ConnectionState.active ||
            snapShot.connectionState == ConnectionState.none ||
            snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapShot.hasError) {
          return Text("エラーが発生しました");
        }

        return TextPage(
          _viewModel._currentEpisode.episodeName, snapShot.data,
          // toggle tap
          () {
            setState(() {
              _viewModel.toggleOuterView();
            });
          },
          (min, currentOffset, max) {
            setState(() {
              _viewModel._sliderMin = min;
              _viewModel._rawSliderOffset = currentOffset;
              _viewModel._sliderMax = max;
            });
          },
          _viewModel._sliderValueNotifier,
          _viewModel._firstScrollPosition,
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
      },
    );
  }

  void showNextPage() async {
    if (_viewModel._nextEpisodeIndex != null) {
      _viewModel._index = _viewModel._nextEpisodeIndex;
      _viewModel._firstScrollPosition = FirstScrollPosition.first;
      print((_viewModel._index).toString());
      await _viewModel._pageController
          .animateToPage(_viewModel._index,
              duration: Duration(milliseconds: 500), curve: Curves.easeInSine)
          .then((_) {
        setState(() {
          // 下から上にいくのでスライダー位置を最初に戻す
          _viewModel._rawSliderOffset = 0;
        });
      });
    }
  }

  void showPrevPage() async {
    if (_viewModel._prevEpisodeIndex != null) {
      _viewModel._index = _viewModel._prevEpisodeIndex;
      _viewModel._firstScrollPosition = FirstScrollPosition.bottom;
      print((_viewModel._index).toString());
      await _viewModel._pageController
          .animateToPage(_viewModel._index,
              duration: Duration(milliseconds: 500), curve: Curves.easeInSine)
          .then((_) {
        setState(() {});
      });
    }
  }
}
