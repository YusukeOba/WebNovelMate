import 'dart:convert';
import 'dart:math';

import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouEpisodeDataStore.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:collection/collection.dart';
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
}

class _EpisodeIndexState extends State<EpisodeIndexPage> {
  _EpisodeIndexViewModel _viewModel;

  _EpisodeIndexState(this._viewModel);

  @override
  void initState() {
    super.initState();
    _testRegist();
  }

  /// TODO: 抹消
  _testRegist() async {
    BookshelfRepository bkRepository =
        RepositoryFactory.shared.getBookshelfRepository();

    await bkRepository.save([
      SubscribedNovelEntity(
          _viewModel._novelHeader,
          DateTime.now().millisecondsSinceEpoch + Random().nextInt(99999999),
          _viewModel._novelHeader.episodeCount,
          _viewModel._novelHeader.episodeCount)
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
        _buildEpisodes()
      ])),
      bottomNavigationBar: SafeArea(child: _buildContinue()),
    );
  }

  /// 「続きから読む」
  Widget _buildContinue() {
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
                onPressed: () {},
                child: Text("続きから読む")))
      ]),
    );
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

  /// 話一覧
  Widget _buildEpisodes() {
    final lists = RemoteNarouEpisodeDataStore()
        .fetchEpisodeList(_viewModel._novelHeader.identifier);

    return FutureBuilder<List<EpisodeEntity>>(
        future: lists,
        builder: (context, snapShot) {
          // 読み込み中
          if (!snapShot.hasData ||
              snapShot.connectionState == ConnectionState.active ||
              snapShot.connectionState == ConnectionState.none ||
              snapShot.connectionState == ConnectionState.waiting) {
            return SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              Container(height: 8.0),
              Container(child: Center(child: CircularProgressIndicator()))
            ]));
          }

          final episodes = snapShot.data;

          List<Widget> listTargetWidgets = [];

          listTargetWidgets.add(Divider());

          Map<String, List<EpisodeEntity>> chapterEpisodeMaps = groupBy(
              episodes, (EpisodeEntity episode) => episode.nullableChapterName);

          chapterEpisodeMaps.forEach((chapter, episodesOfChapter) {
            // チャプタ名の追加
            if (chapter != null && chapter.isNotEmpty) {
              listTargetWidgets.add(
                Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom:
                                BorderSide(width: 0.5, color: Colors.black26))),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(chapter,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold))),
              );
            }

            // 話の一覧を構築
            List<Widget> episodeWidgets = episodesOfChapter.map((episode) {
              final postDate =
                  DateTime.fromMillisecondsSinceEpoch(episode.firstWriteAt);
              final lastUpdateDate =
                  DateTime.fromMillisecondsSinceEpoch(episode.lastUpdateAt);

              return InkWell(
                  onTap: () {},
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  width: 0.5, color: Colors.black26))),
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
                      )));
            }).toList();

            listTargetWidgets.addAll(episodeWidgets);
          });

          return SliverList(
            delegate: SliverChildListDelegate(listTargetWidgets),
          );
        });
  }
}
