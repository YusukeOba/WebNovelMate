import 'dart:async';

import 'package:NovelMate/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  int _initialScrollPosition;

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
      this._initialScrollPosition,
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
        _initialScrollPosition,
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
  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

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
  int _initialScrollPosition;

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

  _TextPageViewModel(
      this.episodeName,
      this.texts,
      this._onTapCallback,
      this._sliderConfigCallback,
      this.manualScrollOffset,
      this._initialScrollPosition,
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
  }
}

class _TextPageState extends State<TextPage> {
  final _TextPageViewModel _viewModel;

  _TextPageState(this._viewModel);

  _manualScrollValueListener() {
    _viewModel._webViewController.future.then((controller) {
      print("scroll manual.");
      controller.evaluateJavascript("window.scroll(" +
          _viewModel.manualScrollOffset.value.toString() +
          ");");
    });
  }

  _textStyleListener() {
    return _viewModel._webViewController.future.then((controller) {
      controller.evaluateJavascript("window.setFontColor('#" +
          _viewModel._textStyle.value.color.value
              .toRadixString(16)
              .substring(2) +
          "');");
      controller.evaluateJavascript("window.setFontSize(" +
          _viewModel._textStyle.value.fontSize.toString() +
          ");");
      controller.evaluateJavascript("window.setTypeface('" +
          _viewModel._textStyle.value.fontFamily.toString() +
          "');");
      controller.evaluateJavascript("window.setLineHeight('" +
          _viewModel._textStyle.value.height.toString() +
          "');");
    });
  }

  _colorListener() {
    return _viewModel._webViewController.future.then((controller) {
      final query = "window.setBackgroundColor('#" +
          _viewModel._color.value.value.toRadixString(16).substring(2) +
          "');";
      print("query" + query);
      controller.evaluateJavascript(query);
    });
  }

  @override
  void initState() {
    super.initState();
    _viewModel.manualScrollOffset.addListener(_manualScrollValueListener);
    _viewModel._textStyle.addListener(_textStyleListener);
    _viewModel._color.addListener(_colorListener);

    // viewのbuild完了時に一度だけ呼ばれる.
    // ScrollViewの準備完了時、Sliderのmin,maxを伝えるため。
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("now mounted.");
      if (_viewModel._firstScrollPosition == FirstScrollPosition.bottom) {
        // TODO: 一番下までスクロール
      } else {}
    });
  }

  @override
  void dispose() {
    _viewModel.manualScrollOffset.removeListener(_manualScrollValueListener);
    _viewModel._textStyle.removeListener(_textStyleListener);
    _viewModel._color.removeListener(_colorListener);
    super.dispose();
  }

  Future<void> onRefresh() {
    return Future.value(_viewModel._prevActionCallback());
  }

  Future<void> loadMore() {
    return Future.value(_viewModel._nextActionCallback());
  }

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      initialUrl: 'html/index.html',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _viewModel._webViewController.complete(webViewController);
      },
      javascriptChannels: {
        JavascriptChannel(
            name: "Msg",
            onMessageReceived: (JavascriptMessage msg) {
              if (msg.message == "LOADED") {
                _viewModel._webViewController.future.then((controller) {
                  final text = _viewModel.texts.join();
                  _textStyleListener();
                  _colorListener();
                  print("start!!");
                  controller
                      .evaluateJavascript("window.setText('" + text + "');")
                      .then((_) {
                    print("finished!!");
                  });
                });
              }

              if (msg.message == "TAP") {
                _viewModel._onTapCallback();
              }

              if (msg.message.contains("SCROLL")) {
                print(msg.message);
                final msgs = msg.message.split(",");
                _viewModel._sliderConfigCallback(
                    0, double.parse(msgs[1]), double.parse(msgs[2]));

                if (this.firstTime) {
                  this.firstTime = false;
                  print("initial scroll offset = " +
                      _viewModel._initialScrollPosition.toString());
                  _viewModel._webViewController.future.then((controller) {
                    controller.evaluateJavascript("window.scroll(" +
                        _viewModel._initialScrollPosition.toString() +
                        ");");
                  });
                }
              }
            })
      },
    ));
  }
}
