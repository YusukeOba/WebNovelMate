import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouTextDataStore.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TextPage extends StatefulWidget {
  final EpisodeEntity _episode;

  TextPage(this._episode);

  @override
  _TextState createState() {
    return _TextState(_TextViewModel(_episode));
  }
}

class _TextViewModel {
  final EpisodeEntity _episode;

  /// 文言
  Future<List<String>> _texts;

  /// AppBar, BottomBarを出すかどうか
  bool shownOuterView = true;

  final ScrollController _scrollController = ScrollController();

  double get scrollOffset {
    if (!_scrollController.hasClients) {
      return 0;
    }

    // 下にオーバースクロールしている
    bool overScrollDown =
        _scrollController.offset > _scrollController.position.maxScrollExtent;

    // 上にオーバースクロールしている
    bool overScrollUp = _scrollController.offset < 0;

    if (overScrollDown) {
      return _scrollController.position.maxScrollExtent;
    }
    if (overScrollUp) {
      return 0;
    }

    // 通常スクロール中
    return _scrollController.offset;
  }

  _TextViewModel(this._episode);

  void showTexts() {
    _texts = RemoteNarouTextDataStore()
        .findByEpisodeId(_episode.novelIdentifier, _episode.episodeIdentifier)
        .then((text) {
      // 大量の文字列を一気に表示するとViewのサイズが大きすぎるためListViewで表示したい
      // そのため改行コードで分割する
      List<String> texts = text.split("\n");
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
  final _TextViewModel _viewModel;

  _TextState(this._viewModel);

  @override
  void initState() {
    setState(() {
      _viewModel.showTexts();
      _viewModel._scrollController.addListener(this._scrollListener);
      // フルスクリーン
      SystemChrome.setEnabledSystemUIOverlays([]);
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    _viewModel._scrollController.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  _scrollListener() {
    setState(() {
      // スクロール検知時、SliderのUIを更新する
      // また、スクロールダウンした時はAppBarとSliderは非表示にする
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
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
                child: _buildTexts(),
                top: _viewModel.shownOuterView ? kToolbarHeight : 0,
                bottom: 0),
            /*Below is the new AppBar code. Without Positioned widget AppBar will fill entire screen*/
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: _buildAppBar(),
              /*You can't put null in the above line since Stack won't allow that*/
            )
          ],
        ),
        bottomNavigationBar: _buildBottomBar());
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
                      Text(_viewModel._episode.episodeName,
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

        return Scrollbar(
            child: ListView.builder(
                controller: _viewModel._scrollController,
                itemBuilder: (context, index) {
                  final text = snapShot.data[index];

                  final textWidget = GestureDetector(
                    onTap: () {
                      setState(() {
                        _viewModel.toggleOuterView();
                      });
                    },
                    child: Container(
                        child: Text(text),
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0)),
                  );

                  bool isLastLength = index == snapShot.data.length - 1;
                  if (isLastLength) {
                    return Column(
                      children: <Widget>[
                        textWidget,
                        Container(
                            height: 150,
                            child: Center(
                                child: RaisedButton(
                                    onPressed: () {}, child: Text("続きをみる"))))
                      ],
                    );
                  } else {
                    return textWidget;
                  }
                },
                physics: BouncingScrollPhysics(),
                itemCount: snapShot.data.length));
      },
    );
  }
}
