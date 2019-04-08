import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';
import 'package:NovelMate/common/repository/IndexRepository.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/page/EpisodeIndexPage.dart';
import 'package:NovelMate/page/SearchResultTabPage.dart';
import 'package:NovelMate/page/TextPagerPage.dart';
import 'package:NovelMate/widget/GeneralError.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage();

  SearchPage.forDesignTime();

  @override
  _SearchPageState createState() {
    return new _SearchPageState(_SearchPageViewModel());
  }
}

class _SearchPageViewModel {
  final IndexRepository _repository =
      RepositoryFactory.shared.getIndexRepository();

  /// 表示中のサイト種別
  Site showingSite = AvailableSites.narou;

  /// 入力中の文言
  String inputtedText = "";

  /// 表示中のランキングデータ
  Future<List<RankingEntity>> rankings;

  /// 文字列の入力
  inputText(String text, BuildContext context) {
    inputtedText = text;
    print("inputed = $text");
    // 空の時は遷移させない
    if (text == null || text.isEmpty) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchResultTabPage(showingSite, inputtedText);
    }));
  }

  void onRefresh() {
    this.rankings = _repository.setDirtyRanking(showingSite).then((_) {
      return _repository.fetchRanking(showingSite);
    }).then((entities) {
      entities.sort((lhs, rhs) {
        return rhs.popularity - lhs.popularity;
      });
      return entities;
    });
  }

  // 初期表示
  void shownFirst() {
    this.rankings = _repository.fetchRanking(showingSite).then((entities) {
      entities.sort((lhs, rhs) {
        return rhs.popularity - lhs.popularity;
      });
      return entities;
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

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final _SearchPageViewModel _viewModel;

  _SearchPageState(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("検索")),
        body: RefreshIndicator(
          onRefresh: () {
            return Future(() {
              setState(() {
                _viewModel.onRefresh();
              });
            });
          },
          child: Scrollbar(
              child: ListView(
            children: <Widget>[_buildSearchBox(), _buildRanking()],
          )),
        ));
  }

  @override
  void initState() {
    super.initState();
    _viewModel.shownFirst();
  }

  /// 検索ボックス
  Widget _buildSearchBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
      color: sNMAccentColor,
      child: Column(
        children: <Widget>[
          Text(
            "好きな小説を探してみましょう！",
            style: TextStyle(fontSize: 16.0),
          ),
          Container(height: 8.0),
          TextFormField(
            autocorrect: true,
            onFieldSubmitted: (text) {
              _viewModel.inputText(text, context);
            },
            controller: TextEditingController(text: _viewModel.inputtedText),
            style: TextStyle(fontWeight: FontWeight.normal),
            cursorColor: sNMPrimaryColor,
            maxLines: 1,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "小説名を入力...",
                contentPadding: EdgeInsets.fromLTRB(8, 12, 8, 8),
                fillColor: sNMBackgroundColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.white, width: 0.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.white, width: 0.0))),
          ),
        ],
      ),
    );
  }

  /// ランキング
  Widget _buildRanking() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
      child: Column(
          // 横に引き伸ばし
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "ランキングから探す",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                )),
            Container(
              height: 16,
              child: Divider(height: 1),
            ),
            this._buildListTiles()
          ]),
    );
  }

  /// 読み込み中表示
  Widget _buildListTiles() {
    return FutureBuilder<List<RankingEntity>>(
        future: this._viewModel.rankings,
        builder: (context, snapShot) {
          print("will shown!!");
          // 読み込み中
          if (snapShot.connectionState == ConnectionState.active ||
              snapShot.connectionState == ConnectionState.waiting ||
              snapShot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          }

          // エラー
          if (snapShot.hasError || !snapShot.hasData) {
            return GeneralError.networkError(() {
              setState(() {
                print("refresh");
                this._viewModel.onRefresh();
              });
            });
          }

          print("hasData");
          return Column(children: <Widget>[
            Column(
              children: snapShot.data.map((novel) {
                return Column(children: <Widget>[
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
                    subtitle: _buildStory(novel.novelHeader.novelStory),
                    onTap: () {
                      _showDetailPage(novel.novelHeader);
                    },
                  ),
                  Divider(height: 1)
                ]);
              }).toList(),
            ),
            // TODO: もっと見る対応
          ]);
        });
  }

  Widget _buildStory(String story) {
    if (story.isEmpty) {
      return null;
    } else {
      return Text(
        story,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  _showDetailPage(NovelHeader novelHeader) async {
    Widget page = await _viewModel.createDetailPage(novelHeader);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
