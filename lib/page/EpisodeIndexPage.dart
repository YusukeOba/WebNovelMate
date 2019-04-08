import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/page/TextPagerPage.dart';
import 'package:NovelMate/widget/GeneralError.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 小説の話一覧ページ
class EpisodeIndexPage extends StatefulWidget {
  /// 表示する小説
  final NovelHeader _novelHeader;

  EpisodeIndexPage(this._novelHeader);

  @override
  _EpisodeIndexState createState() {
    return _EpisodeIndexState(_EpisodeIndexViewModel(_novelHeader));
  }
}

class _EpisodeIndexViewModel {
  NovelHeader _novelHeader;

  final _repository = RepositoryFactory.shared.getEpisodeRepository();

  _EpisodeIndexViewModel(this._novelHeader);

  /// タイトル
  String get _appBarTitle {
    return _novelHeader.novelName;
  }

  /// 作者名
  String get writerName {
    return _novelHeader.writer;
  }

  /// あらすじ
  String get story {
    return _novelHeader.novelStory;
  }

  Future<List<EpisodeEntity>> _episodes;

  Future<List<EpisodeEntity>> get episodes {
    return _episodes;
  }

  void showEpisodes() {
    _episodes = _repository.findEpisodesByNovel(this._novelHeader.identifier);
  }

  String readingEpisodeIdentifier;

  // 最後に読んでいたエピソードの更新
  void showReadingContinue() {
    RepositoryFactory.shared
        .getBookshelfRepository()
        .find(_novelHeader.identifier)
        .then((novel) {
      if (novel.readingEpisodeIdentifier != null) {
        print("reading episode is found.");
        print("identifier = " + novel.readingEpisodeIdentifier);
        readingEpisodeIdentifier = novel.readingEpisodeIdentifier;
      } else {
        print("reading episode is not found.");
      }
    });
  }

  // 閲覧画面から戻ってきたときに「続きから読む」などをアップデートする
  void refreshReadingStatus() {
    showReadingContinue();
  }
}

class _EpisodeIndexState extends State<EpisodeIndexPage> {
  _EpisodeIndexViewModel _viewModel;

  _EpisodeIndexState(this._viewModel);

  @override
  void initState() {
    super.initState();

    setState(() {
      this._viewModel.showEpisodes();
      this._viewModel.showReadingContinue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  /// 「続きから読む」
  Widget _buildContinue(List<EpisodeEntity> episodes) {
    if (_viewModel.readingEpisodeIdentifier != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: new BoxDecoration(
            border:
                new Border(top: BorderSide(width: 0.5, color: Colors.black26))),
        child: Wrap(alignment: WrapAlignment.center, children: <Widget>[
          SizedBox(
              width: 200,
              child: RaisedButton(
                  color: sNMPrimaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    // 読んでいる話のindex位置を探索
                    int index = episodes.indexWhere((episode) {
                      return episode.episodeIdentifier ==
                          _viewModel.readingEpisodeIdentifier;
                    });
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return TextPagerPage(episodes, index);
                                },
                                fullscreenDialog: true))
                        .then((_) {
                      setState(() {
                        _viewModel.refreshReadingStatus();
                      });
                    });
                  },
                  child: Text("続きから読む")))
        ]),
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  /// 作者
  Widget _buildWriter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "作者: ",
              style: TextStyle(color: Colors.black87, fontSize: 12)),
          TextSpan(
              text: _viewModel.writerName,
              style: TextStyle(color: Colors.black87)),
        ]),
      ),
    );
  }

  /// あらすじ
  Widget _buildStory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "あらすじ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 8.0,
            ),
            Text(
              _viewModel.story,
              style: TextStyle(fontSize: 12.0, color: Colors.black),
//              overflow: TextOverflow.ellipsis,
            )
          ]),
    );
  }

  Widget _buildContainer() {
    return FutureBuilder<List<EpisodeEntity>>(
        future: _viewModel._episodes,
        builder: (context, snapShot) {
          // 読み込み中
          if (snapShot.connectionState == ConnectionState.active ||
              snapShot.connectionState == ConnectionState.none ||
              snapShot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text(_viewModel._appBarTitle),
              ),
              body: Scrollbar(
                  child: CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(height: 16.0),
                  _buildWriter(),
                  Divider(),
                  _buildStory(),
                  Container(height: 8.0),
                  Container(child: Center(child: CircularProgressIndicator()))
                ])),
              ])),
            );
          }

          // エラー
          if (snapShot.hasError || !snapShot.hasData) {
            print("hasError");
            return Scaffold(
              appBar: AppBar(
                title: Text(_viewModel._appBarTitle),
              ),
              body: Scrollbar(
                  child: CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(height: 16.0),
                  _buildWriter(),
                  Divider(),
                  _buildStory(),
                  Container(height: 8.0),
                  GeneralError.networkError(() {
                    setState(() {
                      print("refresh");
                      this._viewModel.showEpisodes();
                      this._viewModel.showReadingContinue();
                    });
                  })
                ])),
              ])),
            );
          }

          snapShot.data.sort((lhs, rhs) => lhs.displayOrder - rhs.displayOrder);
          final episodes = snapShot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(_viewModel._appBarTitle),
            ),
            body: Scrollbar(
                child: CustomScrollView(slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(height: 16.0),
                _buildWriter(),
                Divider(),
                _buildStory(),
              ])),
              _buildEpisodes(episodes)
            ])),
            bottomNavigationBar: SafeArea(child: _buildContinue(episodes)),
          );
        });
  }

  /// 話一覧
  SliverList _buildEpisodes(List<EpisodeEntity> episodes) {
    List<Widget> listTargetWidgets = [];

    listTargetWidgets.add(Divider());

    episodes.sort((lhs, rhs) => lhs.firstWriteAt - rhs.firstWriteAt);

    String candidateChapterName = "";

    episodes.asMap().forEach((index, episode) {
      // 新規チャプター
      if (episode.nullableChapterName.isNotEmpty &&
          episode.nullableChapterName != candidateChapterName) {
        candidateChapterName = episode.nullableChapterName;
        final chapter = episode.nullableChapterName;
        listTargetWidgets.add(
          Container(
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(chapter,
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
        );
      }

      // エピソード
      final postDate =
          DateTime.fromMillisecondsSinceEpoch(episode.firstWriteAt);
      final lastUpdateDate =
          DateTime.fromMillisecondsSinceEpoch(episode.lastUpdateAt);

      Widget episodeWidget = InkWell(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return TextPagerPage(episodes, index);
                        },
                        fullscreenDialog: true))
                .then((_) {
              setState(() {
                _viewModel.readingEpisodeIdentifier = episode.episodeIdentifier;
              });
            });
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            episode.episodeName,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(height: 4),
                          Text(
                              "投稿時刻: " +
                                  postDate.year.toString() +
                                  "年" +
                                  postDate.month.toString() +
                                  "月" +
                                  postDate.day.toString() +
                                  "日" +
                                  postDate.hour.toString() +
                                  "時" +
                                  postDate.minute.toString() +
                                  "分",
                              style: TextStyle(
                                  fontSize: 11.0, color: Colors.black87)),
                          Container(height: 4),
                          Text(
                              "改稿時刻: " +
                                  lastUpdateDate.year.toString() +
                                  "年" +
                                  lastUpdateDate.month.toString() +
                                  "月" +
                                  lastUpdateDate.day.toString() +
                                  "日" +
                                  lastUpdateDate.hour.toString() +
                                  "時" +
                                  lastUpdateDate.minute.toString() +
                                  "分",
                              style: TextStyle(
                                  fontSize: 11.0, color: Colors.black87))
                        ],
                      ),
                      flex: 9),
                  _buildReadingEpisodeIcon(episode)
                ],
              )));

      listTargetWidgets.add(episodeWidget);
    });

    return SliverList(
      delegate: SliverChildListDelegate(listTargetWidgets),
    );
  }

  Widget _buildReadingEpisodeIcon(EpisodeEntity episode) {
    if (episode.episodeIdentifier == _viewModel.readingEpisodeIdentifier) {
      return Expanded(
          child: Icon(Icons.bookmark, color: sNMPrimaryColor), flex: 1);
    } else {
      return Expanded(
        child: Container(),
        flex: 1,
      );
    }
  }
}
