import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TextPage extends StatefulWidget {
  /// 話の名前
  final String episodeName;

  /// 実際の話
  final List<String> texts;

  /// スクロールの最小、最大値
  SliderConfigCallback _sliderConfigCallback;

  /// ページがタップされた
  final OnTapCallback _onTapCallback;

  /// スクロール位置
  ValueNotifier<double> manualScrollOffset;

  /// 次の話の名前
  String _nextEpisodeName;

  /// 前の話の名前
  String _prevEpisodeName;

  /// 次の話を表示する
  NextActionCallback _nextActionCallback;

  /// 前の話を表示する
  PrevActionCallback _prevActionCallback;

  TextPage(this.episodeName, this.texts, this._onTapCallback,
      this._sliderConfigCallback, this.manualScrollOffset,
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
        _sliderConfigCallback, manualScrollOffset,
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

  /// スクロール位置
  ValueNotifier<double> manualScrollOffset;

  /// 次の話の名前
  String _nextEpisodeName;

  /// 前の話の名前
  String _prevEpisodeName;

  /// 次の話を表示する
  NextActionCallback _nextActionCallback;

  /// 前の話を表示する
  PrevActionCallback _prevActionCallback;

  ScrollController _scrollController = ScrollController();

  _TextPageViewModel(this.episodeName, this.texts, this._onTapCallback,
      this._sliderConfigCallback, this.manualScrollOffset,
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
    print("min = " +
        _viewModel._scrollController.position.minScrollExtent.toString());
    print("max = " +
        _viewModel._scrollController.position.maxScrollExtent.toString());
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
                    child: Column(
                      children: <Widget>[
                        Text(text),
                        // 最後は余白を付ける
                        Container(height: 64),
                        RaisedButton(
                          onPressed: () {
//                              this._viewModel.showByDown();
//                              this._viewModel._pageController.animateToPage(
//                                  this._viewModel._index,
//                                  duration: Duration(milliseconds: 500),
//                                  curve: Curves.easeInSine);
                            _viewModel._nextActionCallback();
                          },
                          child: Text("hoge"),
                        )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0));
              } else if (isFirstLength) {
                textWidget = Container(
                    child: Column(
                      children: <Widget>[
                        // 最初は余白を付ける
                        Container(height: 32),
                        Text(_viewModel.episodeName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                        Container(height: 32),
                        RaisedButton(
                            onPressed: () {
                              _viewModel._prevActionCallback();
//                                this._viewModel.showByUp();
//                                this._viewModel._pageController.animateToPage(
//                                    this._viewModel._index,
//                                    duration: Duration(milliseconds: 500),
//                                    curve: Curves.easeInSine);
                            },
                            child: Text("hoge")),
                        Text(text),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0));
              } else {
                textWidget = Container(
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
}
