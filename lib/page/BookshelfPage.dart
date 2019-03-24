import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouEpisodeDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:NovelMate/page/BookshelfTabPage.dart';
import 'package:NovelMate/page/EpisodeIndexPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// 本棚に表示する小説
///
class BookshelfPage extends StatefulWidget {
  final BookshelfTab _tab;

  BookshelfPage(this._tab);

  @override
  _BookshelfState createState() {
    return _BookshelfState(_tab);
  }
}

class _BookshelfViewModel {
  /// 表示しているタブ
  final BookshelfTab _tab;

  /// 対応リポジトリ
  final _repository = RepositoryFactory.shared.getBookshelfRepository();

  /// 表示している小説
  Future<List<SubscribedNovelEntity>> _novels;

  _BookshelfViewModel(this._tab);

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
}

class _BookshelfState extends State<BookshelfPage> {
  final BookshelfTab _tab;

  final _BookshelfViewModel _viewModel;

  _BookshelfState(this._tab) : _viewModel = _BookshelfViewModel(_tab);

  @override
  void initState() {
    super.initState();
    setState(() {
      this._viewModel.refreshLists();
    });
  }

  testCode(NovelIdentifier identifier) async {
    await RemoteNarouEpisodeDataStore().fetchEpisodeList(identifier);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scrollbar(
            child: CustomScrollView(slivers: <Widget>[_buildNovelLists()])),
        onRefresh: () {
          return Future(() {
            setState(() {
              this._viewModel.refreshLists();
            });
          });
        });
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

        // データが存在する
        SliverList novelLists = SliverList(
            delegate: SliverChildListDelegate(
                snapShot.data.map((novel) => _buildListTile(novel)).toList()));

        return novelLists;
      },
    );
  }

  Widget _buildListTile(SubscribedNovelEntity novel) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EpisodeIndexPage(novel.novelHeader);
          }));
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
                      // 未読数
                      _buildUnreadChip(novel),
                      // 完結済かどうか
                      Text(
                        novel.novelHeader.isComplete ? "完結済" : "連載中",
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
                      ),
                      Container(width: 4.0),
                      // 掲載話数
                      Text(
                        novel.episodeCount.toString() + "話",
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
                      ),
                      _buildCircle(),
                      // 更新日
                      _buildLastUpdateLabel(novel),
                    ],
                  )
                ])));
  }

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
}
