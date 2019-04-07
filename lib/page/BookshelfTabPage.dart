import 'package:NovelMate/page/BookshelfPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 本棚にある小説を表示する順番
enum BookshelfTab {
  // 更新順
  updateAt,
  // 閲覧順
  readAt
}

///
/// 本棚画面
///
class BookshelfTabPage extends StatefulWidget {
  @override
  _BookshelfTabState createState() {
    return _BookshelfTabState();
  }
}

class _BookshelfViewModel {
  /// 選択中のタブ
  int _currentSelectedTabIndex = BookshelfTab.updateAt.index;

  /// タブ数
  int _tabLength = BookshelfTab.values.length;

  /// 削除モードか
  ValueNotifier<bool> _deleting = ValueNotifier(false);

  /// タブの選択
  void onSelectTab(int index) {
    _currentSelectedTabIndex = index;
  }

  String title() {
    if (_deleting.value) {
      return "本棚から削除";
    } else {
      return "本棚";
    }
  }
}

class _BookshelfTabState extends State<BookshelfTabPage> {
  final _viewModel = _BookshelfViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _viewModel._tabLength,
        initialIndex: _viewModel._currentSelectedTabIndex,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_viewModel.title()),
            bottom: TabBar(
              tabs: [Tab(text: "更新順"), Tab(text: "閲覧順")],
              indicatorColor: Colors.white,
              onTap: (index) {
                setState(() {
                  this._viewModel.onSelectTab(index);
                });
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _viewModel._deleting.value = !_viewModel._deleting.value;
                  });
                },
              )
            ],
          ),
          body: TabBarView(
              children: List<int>.generate(BookshelfTab.values.length, (i) => i)
                  .map((index) {
            print("index = " + index.toString());
            return BookshelfPage(
                BookshelfTab.values[index], _viewModel._deleting);
          }).toList()),
        ));
  }
}
