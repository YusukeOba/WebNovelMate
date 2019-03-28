import 'package:NovelMate/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 初期スクロール位置
enum FirstScrollPosition { first, bottom }

class TextPage extends StatefulWidget {
  /// 話の名前
  final String episodeName;

  /// 実際の話
  final List<String> texts;

  /// スクロールの最小、最大値
  SliderConfigCallback _sliderConfigCallback;

  /// ページがタップされた
  final OnTapCallback _onTapCallback;

  /// 初期スクロール位置
  FirstScrollPosition _firstScrollPosition;

  /// 現在のスクロール位置
  ValueNotifier<double> manualScrollOffset;

  /// 次の話の名前
  String _nextEpisodeName;

  /// 前の話の名前
  String _prevEpisodeName;

  /// 次の話を表示する
  NextActionCallback _nextActionCallback;

  /// 前の話を表示する
  PrevActionCallback _prevActionCallback;

  TextPage(
      this.episodeName,
      this.texts,
      this._onTapCallback,
      this._sliderConfigCallback,
      this.manualScrollOffset,
      this._firstScrollPosition,
      {String nextEpisodeName,
      String prevEpisodeName,
      NextActionCallback nextActionCallback,
      PrevActionCallback prevActionCallback}) {
    _nextEpisodeName = nextEpisodeName;
    _prevEpisodeName = prevEpisodeName;
    _nextActionCallback = nextActionCallback;
    _prevActionCallback = prevActionCallback;
  }

  @override
  _TextPageState createState() {
    return _TextPageState(_TextPageViewModel(episodeName, texts, _onTapCallback,
        _sliderConfigCallback, manualScrollOffset, _firstScrollPosition,
        nextEpisodeName: _nextEpisodeName,
        prevEpisodeName: _prevEpisodeName,
        nextActionCallback: _nextActionCallback,
        prevActionCallback: _prevActionCallback));
  }
}

typedef PrevActionCallback = Function();
typedef NextActionCallback = Function();
typedef OnTapCallback = Function();
typedef SliderConfigCallback = Function(
    double min, double current, double value);

class _TextPageViewModel {
  /// 話の名前
  final String episodeName;

  /// 実際の話
  final List<String> texts;

  /// スクロールの最小、最大値
  SliderConfigCallback _sliderConfigCallback;

  /// ページがタップされた
  final OnTapCallback _onTapCallback;

  /// 初期スクロール位置
  FirstScrollPosition _firstScrollPosition;

  /// 現在のスクロール位置
  ValueNotifier<double> manualScrollOffset;

  /// 次の話の名前
  String _nextEpisodeName;

  /// 前の話の名前
  String _prevEpisodeName;

  /// 次の話を表示する
  NextActionCallback _nextActionCallback;

  /// 前の話を表示する
  PrevActionCallback _prevActionCallback;

  ScrollController _scrollController;

  _TextPageViewModel(
      this.episodeName,
      this.texts,
      this._onTapCallback,
      this._sliderConfigCallback,
      this.manualScrollOffset,
      this._firstScrollPosition,
      {String nextEpisodeName,
      String prevEpisodeName,
      NextActionCallback nextActionCallback,
      PrevActionCallback prevActionCallback}) {
    print("vm initialize");
    _nextEpisodeName = nextEpisodeName;
    _prevEpisodeName = prevEpisodeName;
    _nextActionCallback = nextActionCallback;
    _prevActionCallback = prevActionCallback;

    double firstScrollPos = 0;
    if (_firstScrollPosition == FirstScrollPosition.bottom) {
      firstScrollPos = 30000; // TODO: 初期表示位置が最後の場合は、明らかに大きすぎる位置としておく
    }
    _scrollController = ScrollController(initialScrollOffset: firstScrollPos);
  }
}

class _TextPageState extends State<TextPage> {
  final _TextPageViewModel _viewModel;

  _TextPageState(this._viewModel);

  _scrollListener() {
    bool isScrollDown =
        _viewModel._scrollController.position.userScrollDirection ==
            ScrollDirection.reverse;
    if (isScrollDown) {
      // FIXME: ひとまずタップイベントを発火しておくが、本来はScrollDownCallback等を実装するべき
//      _viewModel._onTapCallback();
    }

    _viewModel._sliderConfigCallback(
        _viewModel._scrollController.position.minScrollExtent,
        _viewModel._scrollController.offset,
        _viewModel._scrollController.position.maxScrollExtent);
  }

  _manualScrollValueListener() {
    if (!_viewModel._scrollController.hasClients) {
      print("Client not found.");
      return;
    }
    _viewModel._scrollController.jumpTo(_viewModel.manualScrollOffset.value);
  }

  @override
  void initState() {
    super.initState();
    _viewModel._scrollController.addListener(this._scrollListener);
    _viewModel.manualScrollOffset.addListener(_manualScrollValueListener);
  }

  @override
  void dispose() {
    _viewModel.manualScrollOffset.removeListener(_manualScrollValueListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
            controller: _viewModel._scrollController,
            itemBuilder: (context, index) {
              final text = _viewModel.texts[index];

              Widget textWidget;
              bool isLastLength = index == _viewModel.texts.length - 1;
              bool isFirstLength = index == 0;
              if (isLastLength) {
                textWidget = Container(
                  color: sNMBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Column(
                            children: <Widget>[
                              Text(text),
                              Container(height: 64),
                            ],
                          )),
                      _buildNextEpisode()
                    ],
                  ),
                );
              } else if (isFirstLength) {
                textWidget = Container(
                  child: Column(
                    children: <Widget>[
                      _buildPreviousEpisode(),
                      Container(
                          color: sNMBackgroundColor,
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Column(
                            children: <Widget>[
                              Container(height: 32),
                              Text(_viewModel.episodeName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                              Container(height: 32),
                            ],
                          )),
                    ],
                  ),
                );
              } else {
                textWidget = Container(
                  color: sNMBackgroundColor,
                  child: Text(text),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                );
              }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _viewModel._onTapCallback();
                  });
                },
                child: textWidget,
              );
            },
            physics: BouncingScrollPhysics(),
            itemCount: _viewModel.texts.length));
  }

  Widget _buildNextEpisode() {
    if (_viewModel._nextEpisodeName != null) {
      return Container(
          child: Column(
        children: <Widget>[
          Container(height: 32),
          Container(
              color: sNMAccentColor,
              child: Column(
                children: <Widget>[
                  Container(height: 16.0),
                  Text("次の話: " + _viewModel._nextEpisodeName),
                  Container(height: 16.0),
                  IconButton(
                      color: sNMPrimaryColor,
                      icon: Icon(Icons.arrow_downward),
                      onPressed: () {
                        _viewModel._nextActionCallback();
                      }),
                  Container(height: 16),
                ],
              ))
        ],
      ));
    } else {
      return Container();
    }
  }

  Widget _buildPreviousEpisode() {
    if (_viewModel._prevEpisodeName != null) {
      return Container(
          child: Column(
        children: <Widget>[
          Container(height: 32),
          Container(
              color: sNMAccentColor,
              child: Column(
                children: <Widget>[
                  Container(height: 16.0),
                  Text("次の話: " + _viewModel._prevEpisodeName),
                  Container(height: 16.0),
                  IconButton(
                      color: sNMPrimaryColor,
                      icon: Icon(Icons.arrow_upward),
                      onPressed: () {
                        _viewModel._prevActionCallback();
                      }),
                  Container(height: 16),
                ],
              ))
        ],
      ));
    } else {
      return Container();
    }
  }
}
