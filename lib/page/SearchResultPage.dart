import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/page/EpisodeIndexPage.dart';
import 'package:NovelMate/page/SearchResultTabPage.dart';
import 'package:NovelMate/page/TextPagerPage.dart';
import 'package:NovelMate/widget/GeneralError.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultPage extends StatefulWidget {
  final SearchResultTab _tab;

  final Site _showingSite;

  final String _searchWord;

  SearchResultPage(this._tab, this._showingSite, this._searchWord);

  @override
  State createState() {
    return _SearchResultState(
        _SearchResultViewModel(_tab, _showingSite, _searchWord));
  }
}

class _SearchResultViewModel {
  final SearchResultTab _tab;

  final Site _showingSite;

  final String _searchWord;

  /// 対応リポジトリ
  final _repository = RepositoryFactory.shared.getIndexRepository();

  /// 表示している小説
  Future<List<RankingEntity>> _novels;

  _SearchResultViewModel(this._tab, this._showingSite, this._searchWord);

  void show() {
    _novels = _show();
  }

  Future<List<RankingEntity>> _show() {
    if (_tab == SearchResultTab.popular) {
      return _repository
          .find(this._showingSite, this._searchWord)
          .then((novels) {
        // 人気順にソート
        novels.sort((lhs, rhs) {
          return rhs.popularity - lhs.popularity;
        });
        return novels;
      });
    } else {
      return _repository
          .find(this._showingSite, this._searchWord)
          .then((novels) {
        // 更新日時順にソート
        novels.sort((lhs, rhs) {
          return rhs.novelHeader.lastUpdatedAt - lhs.novelHeader.lastUpdatedAt;
        });
        return novels;
      });
    }
  }

  refresh() async {
    await _repository.setDirtyIndex(this._showingSite);
    show();
  }

  showFirst() {
    _novels = _repository.setDirtyIndex(this._showingSite).then((_) {
      return _show();
    });
  }

  // 詳細ページの作成
  Future<Widget> createDetailPage(NovelHeader novelHeader) async {
    BookshelfRepository bkRepository =
        RepositoryFactory.shared.getBookshelfRepository();

    final novel = await bkRepository.find(novelHeader.identifier);

    if (novel == null) {
      // 登録していないので新規登録
      await bkRepository.save([
        SubscribedNovelEntity(
            novelHeader,
            DateTime.now().millisecondsSinceEpoch,
            novelHeader.episodeCount,
            novelHeader.episodeCount)
      ]);
    }

    if (novelHeader.isShortStory) {
      return TextPagerPage(
          [
            EpisodeEntity(
                novelHeader.identifier,
                "1",
                DateTime.now().millisecondsSinceEpoch,
                novelHeader.lastUpdatedAt,
                novelHeader.novelName,
                1,
                novelHeader.novelName)
          ].toList(),
          0);
    } else {
      return EpisodeIndexPage(novelHeader);
    }
  }
}

class _SearchResultState extends State<SearchResultPage> {
  final _SearchResultViewModel _viewModel;

  _SearchResultState(this._viewModel);

  @override
  void initState() {
    super.initState();
    setState(() {
      _viewModel.showFirst();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scrollbar(
            child: CustomScrollView(
          slivers: <Widget>[_buildNovelLists()],
        )),
        onRefresh: () {
          return Future(() {
            setState(() {
              _viewModel.refresh();
            });
          });
        });
  }

  Widget _buildNovelLists() {
    return FutureBuilder<List<RankingEntity>>(
        future: _viewModel._novels,
        builder: (context, snapShot) {
          print("snapShot = " + snapShot.toString());
          // 読み込み中
          if (snapShot.connectionState == ConnectionState.active ||
              snapShot.connectionState == ConnectionState.waiting ||
              snapShot.connectionState == ConnectionState.none) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                    heightFactor: 2.0, child: CircularProgressIndicator());
              }, childCount: 1),
            );
          }

          // エラー
          if (snapShot.hasError || !snapShot.hasData) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GeneralError.networkError(() {
                  setState(() {
                    print("refresh");
                    this._viewModel.refresh();
                  });
                });
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

            return InkWell(
                onTap: () async {
                  _showDetailPage(novel.novelHeader);
                },
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
                                        _buildTextLength(
                                            novel.novelHeader.textLength),
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

  TextSpan _buildTextLength(int textLength) {
    if (textLength != null && textLength != 0) {
      // 文字数
      String formattedTextLength = new NumberFormat().format(textLength);
      return TextSpan(
          text: "／" + formattedTextLength + "文字",
          style: TextStyle(color: Colors.black, fontSize: 11.0));
    } else {
      return TextSpan();
    }
  }

  _showDetailPage(NovelHeader novelHeader) async {
    final widget = await _viewModel.createDetailPage(novelHeader);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
