import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/RepositoryFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// 本棚画面
///
class BookshelfPage extends StatefulWidget {
  @override
  _BookshelfState createState() {
    return _BookshelfState();
  }
}

/// 本棚にある小説を表示する順番
enum _BookshelfTab {
  // 更新順
  updateAt,
  // 閲覧順
  readAt
}

class _BookshelfViewModel {
  /// 選択中のタブ
  int _currentSelectedTabIndex = _BookshelfTab.updateAt.index;

  /// タブ数
  int _tabLength = _BookshelfTab.values.length;

  /// 対応リポジトリ
  final _repository = RepositoryFactory.shared.getBookshelfRepository();

  /// 表示している小説
  Future<List<SubscribedNovelEntity>> _novels;

  /// 選択中のタブに応じたListの状態変更
  void refreshLists() {
    final tab = _BookshelfTab.values[this._currentSelectedTabIndex];
    switch (tab) {
      case _BookshelfTab.updateAt:
        print("sort by update at");
        _novels = _repository.findAll().then((novels) {
          novels.sort((lhs, rhs) =>
              rhs.novelHeader.lastUpdatedAt - lhs.novelHeader.lastUpdatedAt);
          return Future.value(novels);
        });
        break;
      case _BookshelfTab.readAt:
        print("sort by read at");
        _novels = _repository.findAll().then((novels) {
          novels.sort((lhs, rhs) => rhs.lastReadAt - lhs.lastReadAt);
          return Future.value(novels);
        });
        break;
    }
  }

  /// タブの選択
  void onSelectTab(int index) {
    _currentSelectedTabIndex = index;
    refreshLists();
  }
}

class _BookshelfState extends State<BookshelfPage> {
  final _viewModel = _BookshelfViewModel();

  @override
  void initState() {
    super.initState();
    setState(() {
      this._viewModel.refreshLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _viewModel._tabLength,
        initialIndex: _viewModel._currentSelectedTabIndex,
        child: Scaffold(
          appBar: AppBar(
              title: Text("本棚"),
              bottom: TabBar(
                tabs: [Tab(text: "更新順"), Tab(text: "閲覧順")],
                indicatorColor: Colors.white,
                onTap: (index) {
                  setState(() {
                    this._viewModel.onSelectTab(index);
                  });
                },
              )),
          body: RefreshIndicator(
              child: CustomScrollView(slivers: <Widget>[
                SliverPadding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                _buildNovelLists()
              ]),
              onRefresh: () {
                return Future(() {
                  setState(() {
                    this._viewModel.refreshLists();
                  });
                });
              }),
        ));
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
    return Container(
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
              Row(
                children: <Widget>[
                  // 未読数
                  _buildUnreadChip(novel),
                  // 完結済かどうか
                  Text(
                    novel.novelHeader.isComplete ? "完結済" : "連載中",
                    style: TextStyle(color: Colors.black87, fontSize: 12.0),
                  ),
                  _buildCircle(),
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
            ]));
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
      width: 8.0,
      height: 8.0,
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
