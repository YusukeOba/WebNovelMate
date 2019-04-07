import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/page/BookshelfTabPage.dart';
import 'package:NovelMate/page/EpisodeIndexPage.dart';
import 'package:NovelMate/page/SearchPage.dart';
import 'package:NovelMate/page/TextPagerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// 本棚に表示する小説
///
class BookshelfPage extends StatefulWidget {
  final BookshelfTab _tab;
  final ValueNotifier<bool> _deleteMode;

  BookshelfPage(this._tab, this._deleteMode);

  @override
  _BookshelfState createState() {
    return _BookshelfState(_BookshelfViewModel(_tab, _deleteMode));
  }
}

class _BookshelfViewModel {
  /// 表示しているタブ
  final BookshelfTab _tab;

  /// 対応リポジトリ
  final _repository = RepositoryFactory.shared.getBookshelfRepository();

  /// 表示している小説
  Future<List<SubscribedNovelEntity>> _novels;

  final ValueNotifier<bool> _deleteMode;

  /// 削除対象のindex, 削除フラグ
  List<SubscribedNovelEntity> _deleteCandidates = [];

  _BookshelfViewModel(this._tab, this._deleteMode);

  /// 選択中のタブに応じたListの状態変更
  void refreshLists() {
    switch (_tab) {
      case BookshelfTab.updateAt:
        print("sort by update at");
        _novels = _repository.findAll().then((novels) {
          novels.sort((lhs, rhs) =>
              rhs.novelHeader.lastUpdatedAt - lhs.novelHeader.lastUpdatedAt);
          return Future.value(novels);
        });
        break;
      case BookshelfTab.readAt:
        print("sort by read at");
        _novels = _repository.findAll().then((novels) {
          novels.sort((lhs, rhs) => rhs.lastReadAt - lhs.lastReadAt);
          return Future.value(novels);
        });
        break;
    }
  }

  /// 削除候補か
  isDeleteByNovel(SubscribedNovelEntity novel) {
    return _deleteCandidates.contains(novel);
  }

  /// 削除候補に追加
  putDelete(SubscribedNovelEntity novel, bool isDelete) {
    if (isDelete) {
      _deleteCandidates.add(novel);
    } else {
      _deleteCandidates.remove(novel);
    }
  }

  /// 削除の確定
  confirmDelete() async {
    _deleteCandidates.forEach((novel) async {
      await RepositoryFactory.shared
          .getBookshelfRepository()
          .delete([novel].toList());
      print("index deleting...");
      await RepositoryFactory.shared
          .getEpisodeRepository()
          .deleteByNovel(novel.novelHeader.identifier);
      print("ep deleting...");
      await RepositoryFactory.shared
          .getTextRepository()
          .deleteByNovel(novel.novelHeader.identifier);
      print("txt deleting...");
    });

    refreshLists();
  }
}

class _BookshelfState extends State<BookshelfPage> {
  final _BookshelfViewModel _viewModel;

  _BookshelfState(this._viewModel);

  @override
  void initState() {
    super.initState();
    setState(() {
      this._viewModel.refreshLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          child: Scrollbar(
              child: CustomScrollView(slivers: <Widget>[_buildNovelLists()])),
          onRefresh: () {
            return Future(() {
              setState(() {
                this._viewModel.refreshLists();
              });
            });
          }),
      bottomNavigationBar: _buildConfirm(),
    );
  }

  Widget _buildNovelLists() {
    return FutureBuilder<List<SubscribedNovelEntity>>(
      future: _viewModel._novels,
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

        // エラーケース
        if (snapShot.hasError) {
          return Text("Error Occured.");
        }

        if (snapShot.data == null || snapShot.data.isEmpty) {
          return SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Container(
              height: 256,
              child: Center(
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) {
                                  return SearchPage();
                                })).then((_) {
                          // 検索から戻ってきたら本棚を更新する
                          this._viewModel.refreshLists();
                        });
                      },
                      child: Text("まずは小説を検索してみましょう！"))),
            )
          ]));
        }

        // データが存在する
        List<Widget> widgets = [];

        snapShot.data.asMap().forEach((index, novel) {
          widgets.add(_buildListTile(index, novel));
        });

        SliverList novelLists =
            SliverList(delegate: SliverChildListDelegate(widgets));

        return novelLists;
      },
    );
  }

  Widget _buildListTile(int index, SubscribedNovelEntity novel) {
    if (_viewModel._deleteMode.value) {
      return InkWell(
          onTap: () {
            setState(() {
              _viewModel.putDelete(novel, !_viewModel.isDeleteByNovel(novel));
            });
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // タイトル
                          Text(novel.novelHeader.novelName,
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                          // 作者名
                          Text(
                            novel.novelHeader.writer,
                            style: TextStyle(
                                color: Colors.black87, fontSize: 12.0),
                          ),
                          Container(
                            height: 4.0,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
//                      // 未読数
//                      _buildUnreadChip(novel),
                              // 完結済かどうか
                              Text(
                                novel.novelHeader.isComplete ? "完結済" : "連載中",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 12.0),
                              ),
                              Container(width: 4.0),
                              // 掲載話数
                              Text(
                                novel.episodeCount.toString() + "話",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 12.0),
                              ),
                              _buildCircle(),
                              // 更新日
                              _buildLastUpdateLabel(novel),
                            ],
                          )
                        ]),
                    flex: 9,
                  ),
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      activeColor: sNMPrimaryColor,
                      value: _viewModel.isDeleteByNovel(novel),
                      onChanged: (value) {
                        setState(() {
                          _viewModel.putDelete(novel, value);
                        });
                      },
                    ),
                  )
                ],
              )));
    } else {
      return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (novel.novelHeader.isShortStory) {
                return TextPagerPage(
                    [
                      EpisodeEntity(
                          novel.novelHeader.identifier,
                          "1",
                          DateTime.now().millisecondsSinceEpoch,
                          DateTime.now().millisecondsSinceEpoch,
                          novel.novelHeader.novelName,
                          1,
                          novel.novelHeader.novelName)
                    ].toList(),
                    0);
              } else {
                return EpisodeIndexPage(novel.novelHeader);
              }
            })).then((_) {
              setState(() {
                _viewModel.refreshLists();
              });
            });
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // タイトル
                    Text(novel.novelHeader.novelName,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    // 作者名
                    Text(
                      novel.novelHeader.writer,
                      style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    ),
                    Container(
                      height: 4.0,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
//                      // 未読数
//                      _buildUnreadChip(novel),
                        // 完結済かどうか
                        Text(
                          novel.novelHeader.isComplete ? "完結済" : "連載中",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        Container(width: 4.0),
                        // 掲載話数
                        Text(
                          novel.episodeCount.toString() + "話",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        _buildCircle(),
                        // 更新日
                        _buildLastUpdateLabel(novel),
                      ],
                    )
                  ])));
    }
  }

  /// TODO: 対応
  /// 未読数の生成
  Widget _buildUnreadChip(SubscribedNovelEntity novel) {
    if (novel.unreadCount > 0) {
      return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "未読" + novel.unreadCount.toString() + "話",
                style: TextStyle(color: sNMPrimaryColor, fontSize: 11.0),
              ),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(4.0),
                  border: Border.all(color: sNMPrimaryColor)),
            ),
            _buildCircle()
          ]);
    } else {
      return Container();
    }
  }

  /// 丸の作成
  Widget _buildCircle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 4.0,
      height: 4.0,
      decoration: new BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
      ),
    );
  }

  /// 掲載話数の生成
  Widget _buildLastUpdateLabel(SubscribedNovelEntity novel) {
    // フォーマット済更新日
    final date =
        DateTime.fromMillisecondsSinceEpoch(novel.novelHeader.lastUpdatedAt);

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

    return Text(
      formattedDate,
      style: TextStyle(color: Colors.black87, fontSize: 12.0),
    );
  }

  /// 小説削除の確定
  Widget _buildConfirm() {
    if (_viewModel._deleteMode.value) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: new BoxDecoration(
            border:
                new Border(top: BorderSide(width: 0.5, color: Colors.black26))),
        child: Wrap(alignment: WrapAlignment.center, children: <Widget>[
          SizedBox(
              width: 200,
              child: RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _viewModel.confirmDelete();
                    });
                  },
                  child: Text("削除する")))
        ]),
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }
}
