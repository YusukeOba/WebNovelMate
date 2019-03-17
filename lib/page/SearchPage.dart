import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final RankingRepository _repository;

  SearchPage(this._repository);

  @override
  _SearchPageState createState() {
    return new _SearchPageState(_SearchPageViewModel(_repository));
  }
}

class _SearchPageViewModel {
  final RankingRepository _repository;

  /// 表示中のサイト種別
  Site showingSite = Site.narou;

  /// 入力中の文言
  String inputtedText = "田中";

  /// 表示中のランキングデータ
  Future<List<RankingEntity>> rankings;

  _SearchPageViewModel(this._repository);

  /// ランキングの表示
  void showRankings() {
    this.rankings = _repository.fetchLatest(showingSite);
  }

  /// 文字列の入力
  void inputText(String text) {
    inputtedText = text;
    print("inputed = $text");
  }

  void onRefresh() {
    this.rankings = _repository.setDirty(showingSite).then((_) {
      return _repository.find(showingSite, 0, 50, inputtedText);
    });
  }
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final _SearchPageViewModel _viewModel;

  _SearchPageState(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel.showRankings();
  }

  /// 検索ボックス
  Widget _buildSearchBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
      color: sNMAccentColor,
      child: Column(
        children: <Widget>[
          Text(
            "好きな小説を、様々な方法で探してみましょう！",
            style: TextStyle(fontSize: 16.0),
          ),
          Container(height: 8.0),
          TextFormField(
            autocorrect: true,
            onFieldSubmitted: (text) {
              _viewModel.inputText(text);
            },
            controller: TextEditingController(text: _viewModel.inputtedText),
            style: TextStyle(fontWeight: FontWeight.normal),
            cursorColor: sNMPrimaryColor,
            maxLines: 1,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "小説名・ユーザーを検索...",
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
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
            Container(
              height: 32,
              child: Divider(),
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
          if (!snapShot.hasData) {
            print("nodata");
            return Center(child: CircularProgressIndicator());
          }
          print("hasData");
          return Column(children: <Widget>[
            Column(
              children: snapShot.data.map((novel) {
                return Column(children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: sNMAccentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(novel.rank.toString())),
                    ),
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
                    subtitle: Text(
                      novel.novelHeader.novelStory,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {},
                  ),
                  Divider()
                ]);
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("もっと見る"),
                  onPressed: () {},
                )
              ],
            )
          ]);
        });
  }
}
