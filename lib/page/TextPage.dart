import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouTextDataStore.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:flutter/material.dart';
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

  void addScrollListener(Function listener(ScrollController controller)) {
    _scrollController.addListener(listener(_scrollController));
  }
}

class _TextState extends State<TextPage> {
  final _TextViewModel _viewModel;

  _TextState(this._viewModel);

  @override
  void initState() {
    super.initState();
    setState(() {
      _viewModel.showTexts();
      _viewModel.addScrollListener((controller) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildTexts(),
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildAppBar() {
    if (_viewModel.shownOuterView) {
      return AppBar();
    } else {
      return null;
    }
  }

  Widget _buildBottomBar() {
    bool isScrollBarAttached = _viewModel._scrollController.hasClients;
    if (_viewModel.shownOuterView && isScrollBarAttached) {
      return SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      top: BorderSide(width: 0.5, color: Colors.black26))),
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(_viewModel._episode.episodeName),
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
      return null;
    }
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
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          _viewModel.toggleOuterView();
                        });
                      },
                      child: Text(text));
                },
                itemCount: snapShot.data.length));
      },
    );
  }
}
