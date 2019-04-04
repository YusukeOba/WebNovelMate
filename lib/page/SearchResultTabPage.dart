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
import 'package:NovelMate/page/SearchResultPage.dart';
import 'package:NovelMate/page/TextPagerPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class SearchResultTabPage extends StatefulWidget {
  /// 検索サイト
  final Site _searchSite;

  /// 検索キーワード
  final String _searchWord;

  SearchResultTabPage(this._searchSite, this._searchWord);

  @override
  State createState() {
    return _SearchResultTabPageState(
        _SearchResultTabPageViewModel(_searchSite, _searchWord));
  }
}

/// 本棚にある小説を表示する順番
enum SearchResultTab {
  // 人気順
  popular,
  // 更新順
  updateAt
}

class _SearchResultTabPageViewModel {
  /// 検索キーワード
  final String _searchWord;

  /// 表示中のサイト
  Site _showningSite;

  /// 選択中タブ
  SearchResultTab _currentSelectedTab = SearchResultTab.popular;

  _SearchResultTabPageViewModel(this._showningSite, this._searchWord);

  String pageTitle() {
    return "$_searchWordを含む小説";
  }

  /// 選択タブに応じて更新する
  void _showWithSelectedTab(SearchResultTab tab) {
    this._currentSelectedTab = tab;
  }
}

class _SearchResultTabPageState extends State<SearchResultTabPage> {
  final _SearchResultTabPageViewModel _viewModel;

  _SearchResultTabPageState(this._viewModel);

  @override
  void initState() {
    super.initState();
    _viewModel._showWithSelectedTab(SearchResultTab.popular);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: SearchResultTab.values.length,
        initialIndex: _viewModel._currentSelectedTab.index,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_viewModel.pageTitle()),
            bottom: TabBar(
              tabs: [new Tab(text: "おすすめ順"), new Tab(text: "更新順")].toList(),
              indicatorColor: Colors.white,
              onTap: (index) {
                setState(() {
                  _viewModel
                      ._showWithSelectedTab(SearchResultTab.values[index]);
                });
              },
            ),
          ),
          body: TabBarView(
              children:
                  List<int>.generate(SearchResultTab.values.length, (i) => i)
                      .map((index) {
            return SearchResultPage(SearchResultTab.values[index],
                _viewModel._showningSite, _viewModel._searchWord);
          }).toList()),
        ));
  }
}
