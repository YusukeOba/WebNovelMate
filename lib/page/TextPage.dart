import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouTextDataStore.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

// 画面遷移時のスタイ
enum TextPageTransitionType {
  // 続きから読む
  readContinue,
  // 最初から読む
  readTop,
  // 最後から読む
  readBottom
}

class TextPage extends StatefulWidget {
  final List<EpisodeEntity> _episodes;

  final EpisodeEntity _currentEpisode;

  TextPage(this._episodes, this._currentEpisode);

  @override
  _TextState createState() {
    return _TextState(_TextViewModel(_episodes, _currentEpisode));
  }
}

class _TextViewModel {
  /// この小説の総エピソード
  List<EpisodeEntity> _episodes;

  /// 現在読んでいるエピソード
  EpisodeEntity _currentEpisode;

  /// エピソードの本文
  Future<List<String>> _texts;

  /// AppBar, BottomBarを出すかどうか
  bool shownOuterView = true;

  PageController _scrollController;

  /// Sliderに表示するスクロール位置
  double get scrollOffset {
    if (!_scrollController.hasClients) {
      print("hasClient");
      return 0;
    }

    // 下にオーバースクロールしている
    bool overScrollDown =
        _scrollController.offset > _scrollController.position.maxScrollExtent;

    // 上にオーバースクロールしている
    bool overScrollUp = _scrollController.offset < 0;

    if (overScrollDown) {
      print("over scroll down.");
      return _scrollController.position.maxScrollExtent;
    }
    if (overScrollUp) {
      print("over scroll up.");
      return 0;
    }

    // 通常スクロール中
    return _scrollController.offset;
  }

  /// 現在の話のインデックス値
  int get _index {
    int currentIndex = _episodes.indexWhere((episode) =>
        episode.episodeIdentifier == _currentEpisode.episodeIdentifier);

    // 閲覧している話が話一覧に含まれていないのでエラーを返却する
    if (currentIndex == -1) {
      throw Exception("Error. This episode is not contained.");
    }

    return currentIndex;
  }

  /// 次のエピソード
  /// 最後のエピソードの場合はnullを返却する
  EpisodeEntity get _nextEpisode {
    int currentIndex = _index;

    //　最後のエピソード
    if (currentIndex + 1 >= _episodes.length) {
      return null;
    } else {
      return _episodes[currentIndex + 1];
    }
  }

  /// 前のエピソード
  /// 最初のエピソードの場合はnullを返却する
  EpisodeEntity get _prevEpisode {
    int currentIndex = _index;

    //　最初のエピソード
    if (currentIndex == 0) {
      return null;
    } else {
      return _episodes[currentIndex - 1];
    }
  }

  /// タイトルを表示するかどうか
  bool get _isShownTitle {
    int currentIndex = _episodes.indexWhere((episode) =>
        episode.episodeIdentifier == _currentEpisode.episodeIdentifier);

    // 閲覧している話が話一覧に含まれていないのでエラーを返却する
    if (currentIndex == -1) {
      throw Exception("Error. This episode is not contained.");
    }

    if (currentIndex == 0) {
      return true;
    } else {
      return false;
    }
  }

  _TextViewModel(this._episodes, this._currentEpisode) {
    this._scrollController = PageController(initialPage: _index);
  }

  void showTexts() {
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
    shownOuterView = !shownOuterView;
  }

  void setOuterViewVisibility(bool visibility) {
    shownOuterView = visibility;
  }
}

class _TextState extends State<TextPage> with TickerProviderStateMixin {
  _TextViewModel _viewModel;

  _TextState(this._viewModel);

  @override
  void initState() {
    super.initState();
    print("initState");
    setState(() {
      _viewModel.showTexts();
      _viewModel._scrollController.addListener(this._scrollListener);
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

  _scrollListener() {
    setState(() {
      // スクロール検知時、SliderのUIを更新する
      // また、スクロールダウンした時はAppBarとSliderは非表示にする
      if (!this.mounted) {
        return;
      }
      bool isScrollDown =
          _viewModel._scrollController.position.userScrollDirection ==
              ScrollDirection.reverse;
      if (isScrollDown) {
        _viewModel.setOuterViewVisibility(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
//            body: PageView.builder(
//                scrollDirection: Axis.vertical,
//                controller: _viewModel._scrollController,
//                itemCount: _viewModel._episodes.length,
//                itemBuilder: (context, position) {
//                  return Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                          child: _buildTexts(),
//                          top: _viewModel.shownOuterView ? kToolbarHeight : 0,
//                          bottom: 0),
//                      /*Below is the new AppBar code. Without Positioned widget AppBar will fill entire screen*/
//                      Positioned(
//                        top: 0.0,
//                        left: 0.0,
//                        right: 0.0,
//                        child: _buildAppBar(),
//                        /*You can't put null in the above line since Stack won't allow that*/
//                      )
//                    ],
//                  );
//                }),
            body: Stack(children: <Widget>[
              Positioned.fill(
                  top: _viewModel.shownOuterView ? kToolbarHeight : 0,
                  bottom: 0,
                  child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _viewModel._scrollController,
                      itemCount: _viewModel._episodes.length,
                      itemBuilder: (context, position) {
                        return _buildTexts();
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
    if (_viewModel.shownOuterView) {
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
    bool isScrollBarAttached = _viewModel._scrollController.hasClients;
    Widget bottomBar;
    if (_viewModel.shownOuterView && isScrollBarAttached) {
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
                          value: _viewModel.scrollOffset,
                          min: _viewModel
                              ._scrollController.position.minScrollExtent,
                          max: _viewModel
                              ._scrollController.position.maxScrollExtent,
                          onChanged: (value) {
                            setState(() {
                              _viewModel._scrollController.jumpTo(value);
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

        return Scrollbar(
//            child: SmartRefresher(
//                enablePullDown: _viewModel._prevEpisode != null,
//                enablePullUp: _viewModel._nextEpisode != null,
//                headerBuilder: (context, index) {
//                  if (_viewModel._prevEpisode != null) {
//                    return SafeArea(
//                        child: Container(
//                            color: sNMAccentColor,
//                            padding: EdgeInsets.fromLTRB(
//                                16, kToolbarHeight + 32, 16, 16),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.stretch,
//                              children: <Widget>[
//                                Text("前のエピソードへ",
//                                    style: TextStyle(
//                                        color: Colors.black, fontSize: 12.0)),
//                                Text(_viewModel._prevEpisode.episodeName,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 14.0,
//                                        fontWeight: FontWeight.bold)),
//                                IconButton(
//                                    onPressed: () {},
//                                    icon: Icon(Icons.arrow_upward)),
//                              ],
//                            )));
//                  } else {
//                    return Container(height: 0);
//                  }
//                },
//                footerConfig: RefreshConfig(triggerDistance: 50.0),
//                headerConfig: RefreshConfig(triggerDistance: 50.0),
//                // 更新時の処理
//                onRefresh: (isUp) {
//                  if (isUp) {
//                    setState(() {
////                      _viewModel = _TextViewModel(
////                          _viewModel._episodes, _viewModel._prevEpisode);
//                    });
//                    print("show previous episode!!");
//                  } else {
//                    setState(() {
////                      _viewModel = _TextViewModel(
////                          _viewModel._episodes, _viewModel._nextEpisode);
//                    });
//                    print("show next episode!!");
//                  }
//
////                  _viewModel._scrollController = ScrollController();
////                  _viewModel.showTexts();
//                },
//                footerBuilder: (context, index) {
//                  if (_viewModel._nextEpisode != null) {
//                    return Container(
//                        color: sNMAccentColor,
//                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
//                          children: <Widget>[
//                            Text("前のエピソードへ",
//                                style: TextStyle(
//                                    color: Colors.black, fontSize: 12.0)),
//                            Text(_viewModel._nextEpisode.episodeName,
//                                style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 14.0,
//                                    fontWeight: FontWeight.bold)),
//                            IconButton(
//                                onPressed: () {},
//                                icon: Icon(Icons.arrow_downward)),
//                          ],
//                        ));
//                  } else {
//                    return Container(height: 0);
//                  }
//                },
            child: ListView.builder(
                controller: ScrollController(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final text = snapShot.data[index];

                  Widget textWidget;
                  bool isLastLength = index == snapShot.data.length - 1;
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
                                setState(() {
                                  this
                                      ._viewModel
                                      ._scrollController
                                      .animateToPage(1,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInBack);
                                });
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
                            Text(_viewModel._currentEpisode.episodeName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            Container(height: 32),
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
//                            _viewModel.toggleOuterView();
                      });
                    },
                    child: textWidget,
                  );
                },
                physics: BouncingScrollPhysics(),
                itemCount: snapShot.data.length));
      },
    );
  }
}
