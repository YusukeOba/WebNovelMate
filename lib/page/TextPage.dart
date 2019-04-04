import 'package:NovelMate/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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

  /// スライダー経由で設定されたスクロール位置
  ValueNotifier<double> manualScrollOffset;

  /// 初期スクロール位置
  FirstScrollPosition _firstScrollPosition;

  /// 次の話の名前
  String _nextEpisodeName;

  /// 前の話の名前
  String _prevEpisodeName;

  /// 次の話を表示する
  NextActionCallback _nextActionCallback;

  /// 前の話を表示する
  PrevActionCallback _prevActionCallback;

  /// 背景色
  ValueNotifier<Color> _color;

  /// テキスト設定
  ValueNotifier<TextStyle> _textStyle;

  TextPage(
      this.episodeName,
      this.texts,
      this._onTapCallback,
      this._sliderConfigCallback,
      this.manualScrollOffset,
      this._firstScrollPosition,
      this._color,
      this._textStyle,
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
    return _TextPageState(_TextPageViewModel(
        episodeName,
        texts,
        _onTapCallback,
        _sliderConfigCallback,
        manualScrollOffset,
        _firstScrollPosition,
        _color,
        _textStyle,
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
  List<String> texts;

  /// スクロールの最小、最大値
  SliderConfigCallback _sliderConfigCallback;

  /// ページがタップされた
  final OnTapCallback _onTapCallback;

  /// スライダー経由で設定されたスクロール位置
  ValueNotifier<double> manualScrollOffset;

  /// 初期スクロール位置
  FirstScrollPosition _firstScrollPosition;

  /// 次の話の名前
  String _nextEpisodeName;

  /// 前の話の名前
  String _prevEpisodeName;

  /// 次の話を表示する
  NextActionCallback _nextActionCallback;

  /// 前の話を表示する
  PrevActionCallback _prevActionCallback;

  /// 背景色
  ValueNotifier<Color> _color;

  /// テキスト設定
  ValueNotifier<TextStyle> _textStyle;

  ScrollController _scrollController;

  _TextPageViewModel(
      this.episodeName,
      this.texts,
      this._onTapCallback,
      this._sliderConfigCallback,
      this.manualScrollOffset,
      this._firstScrollPosition,
      this._color,
      this._textStyle,
      {String nextEpisodeName,
      String prevEpisodeName,
      NextActionCallback nextActionCallback,
      PrevActionCallback prevActionCallback}) {
    print("vm initialize");
    _nextEpisodeName = nextEpisodeName;
    _prevEpisodeName = prevEpisodeName;
    _nextActionCallback = nextActionCallback;
    _prevActionCallback = prevActionCallback;
    _scrollController = ScrollController(keepScrollOffset: false);
  }

  void notifySliderConfig() {
    _sliderConfigCallback(_scrollController.position.minScrollExtent,
        _scrollController.offset, _scrollController.position.maxScrollExtent);
  }
}

class _TextPageState extends State<TextPage> {
  final _TextPageViewModel _viewModel;

  _TextPageState(this._viewModel);

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  _scrollListener() {
    _viewModel.notifySliderConfig();
    print("min = " +
        _viewModel._scrollController.position.minScrollExtent.toString());
    print("max = " +
        _viewModel._scrollController.position.maxScrollExtent.toString());
    print("current = " + _viewModel._scrollController.offset.toString());
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

    // viewのbuild完了時に一度だけ呼ばれる.
    // ScrollViewの準備完了時、Sliderのmin,maxを伝えるため。
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("now mounted.");
      if (_viewModel._scrollController.hasClients) {
        if (_viewModel._firstScrollPosition == FirstScrollPosition.bottom) {
          // TODO: 一番下までスクロール
          _viewModel.notifySliderConfig();
        } else {
          _viewModel.notifySliderConfig();
        }
      } else {
        print("scrollview is not mounted...");
      }
    });
  }

  @override
  void dispose() {
    _viewModel.manualScrollOffset.removeListener(_manualScrollValueListener);
    super.dispose();
  }

  Future<void> onRefresh() {
    return Future.value(_viewModel._prevActionCallback());
  }

  Future<void> loadMore() {
    return Future.value(_viewModel._nextActionCallback());
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: EasyRefresh(
            key: _easyRefreshKey,
            onRefresh: _viewModel._prevEpisodeName != null ? onRefresh : null,
            loadMore: _viewModel._nextEpisodeName != null ? loadMore : null,
            refreshHeader: BallPulseHeader(
              key: _headerKey,
              color: _viewModel._textStyle.value.color,
            ),
            refreshFooter: BallPulseFooter(
              key: _footerKey,
              color: _viewModel._textStyle.value.color,
            ),
            child: ListView.builder(
                controller: _viewModel._scrollController,
                itemBuilder: (context, index) {
                  final text = _viewModel.texts[index];
                  Widget textWidget;
                  bool isLastLength = index == _viewModel.texts.length - 1;
                  bool isFirstLength = index == 0;
                  if (isLastLength) {
                    textWidget = Container(
                      color: _viewModel._color.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Column(
                                children: <Widget>[
                                  Text(text,
                                      style: _viewModel._textStyle.value),
                                  Container(height: 164),
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
                              color: _viewModel._color.value,
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Column(
                                children: <Widget>[
                                  Container(height: 128),
                                  Text(_viewModel.episodeName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: _viewModel
                                              ._textStyle.value.color)),
                                  Container(height: 32),
                                ],
                              )),
                        ],
                      ),
                    );
                  } else {
                    textWidget = Container(
                      color: _viewModel._color.value,
                      child: Text(text, style: _viewModel._textStyle.value),
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
                itemCount: _viewModel.texts.length)));
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
                  Container(height: 32.0),
                  Text("次の話: "),
                  Container(
                    child: Text(_viewModel._nextEpisodeName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Container(height: 32.0),
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
          Container(
              color: sNMAccentColor,
              child: Column(
                children: <Widget>[
                  Container(height: 32.0),
                  Text("前の話: "),
                  Container(
                    child: Text(_viewModel._prevEpisodeName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Container(height: 32.0),
                ],
              ))
        ],
      ));
    } else {
      return Container();
    }
  }
}
