import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class SearchResultPage extends StatefulWidget {
  /// 検索キーワード
  final String _searchWord;

  /// 対応リポジトリ
  final RankingRepository _repository;

  SearchResultPage(this._searchWord, this._repository);

  @override
  State createState() {
    return _SearchResultPageState(
        _SearchResultPageViewModel(_searchWord, _repository));
  }
}

class _SearchResultPageViewModel {
  /// 検索キーワード
  final String _searchWord;

  /// 対応リポジトリ
  final RankingRepository _repository;

  /// ListViewに表示する小説群
  Future<List<RankingEntity>> _novels;

  /// 選択中タブ
  int _currentSelectedTabIndex = 0;

  /// 表示中のサイト
  Site _showningSite = Narou();

  _SearchResultPageViewModel(this._searchWord, this._repository);

  bool visibleFav = false;

  String pageTitle() {
    return "$_searchWordを含む小説";
  }

  /// 人気順にソートする
  void showPopularity() {
    _novels = _repository.setDirty(this._showningSite).then((_) {
      return _repository.find(this._showningSite, 0, 500, this._searchWord);
    }).then((novels) {
      // 人気順にソート
      novels.sort((lhs, rhs) {
        return rhs.popularity - lhs.popularity;
      });
      return novels;
    });
  }

  /// 更新日時順にソートする
  void showUpdatedAt() {
    _novels = _repository.setDirty(this._showningSite).then((_) {
      return _repository.find(this._showningSite, 0, 500, this._searchWord);
    }).then((novels) {
      // 更新日時順にソート
      novels.sort((lhs, rhs) {
        return rhs.novelHeader.lastUpdatedAt - lhs.novelHeader.lastUpdatedAt;
      });
      return novels;
    });
  }

  /// 選択タブに応じて更新する
  void _showWithSelectedTabIndex(index) {
    this._currentSelectedTabIndex = index;
    if (index == 0) {
      showPopularity();
    } else if (index == 1) {
      showUpdatedAt();
    }
  }
}

class _SearchResultPageState extends State<SearchResultPage> {
  final _SearchResultPageViewModel _viewModel;

  _SearchResultPageState(this._viewModel);

  @override
  void initState() {
    super.initState();
    _viewModel._showWithSelectedTabIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: _viewModel._currentSelectedTabIndex,
        child: Scaffold(
          body: RefreshIndicator(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text(_viewModel.pageTitle()),
                    pinned: true,
                    bottom: TabBar(
                      tabs:
                          [new Tab(text: "人気順"), new Tab(text: "更新順")].toList(),
                      indicatorColor: Colors.white,
                      onTap: (index) {
                        setState(() {
                          _viewModel._showWithSelectedTabIndex(index);
                        });
                      },
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                  _buildNovelLists()
                ],
              ),
              onRefresh: () {
                return Future(() {
                  setState(() {
                    this._viewModel._showWithSelectedTabIndex(
                        this._viewModel._currentSelectedTabIndex);
                  });
                });
              }),
        ));
  }

  Widget _buildNovelLists() {
    return FutureBuilder<List<RankingEntity>>(
        future: _viewModel._novels,
        builder: (context, snapShot) {
          // 読み込み中はダイアログ表示
          if (!snapShot.hasData ||
              snapShot.connectionState == ConnectionState.waiting ||
              snapShot.connectionState == ConnectionState.none) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                    heightFactor: 2.0, child: CircularProgressIndicator());
              }, childCount: 1),
            );
          }

          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            // 小説情報
            final novel = snapShot.data[index];

            // フォーマット済更新日
            final date = DateTime.fromMillisecondsSinceEpoch(
                novel.novelHeader.lastUpdatedAt);
            print("lastUpdatedAt = " +
                novel.novelHeader.lastUpdatedAt.toString());

            final formattedDate = date.year.toString() +
                "年" +
                date.month.toString() +
                "月" +
                date.day.toString() +
                "日" +
                date.hour.toString() +
                "時" +
                date.minute.toString() +
                "分 更新";

            // 文字数
            String textLength =
                new NumberFormat().format(novel.novelHeader.textLength);

            return InkWell(
                onTap: () {},
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom:
                                BorderSide(width: 0.5, color: Colors.black26))),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: novel.novelHeader.novelName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            TextSpan(
                                text: "／" + novel.novelHeader.writer,
                                style: TextStyle(color: Colors.black))
                          ])),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                novel.novelHeader.novelStory,
                                maxLines: 3,
                                style: TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(height: 4.0), // padding
                              Container(
                                  decoration: new BoxDecoration(
                                      color: sBMDarkBackgroundColor,
                                      borderRadius:
                                          new BorderRadius.circular(4.0)),
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: novel.novelHeader.isComplete
                                                ? "完結済"
                                                : "連載中",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11.0)),
                                        TextSpan(
                                            text: "／" + textLength + "文字",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11.0)),
                                        TextSpan(
                                            text: "／" + formattedDate,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11.0)),
                                        TextSpan(
                                            text: "／" +
                                                novel.novelHeader.identifier
                                                    .site.siteName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11.0))
                                      ]))
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    )));
          }, childCount: snapShot.data.length));
        });
  }
}
