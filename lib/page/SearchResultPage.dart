import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  /// 検索キーワード
  final String _searchWord;

  /// 対応リポジトリ
  final RankingRepository _repository;

  SearchResultPage(this._searchWord, this._repository);

  @override
  State createState() {
    return _SearchResultPageState(
        _SearchResultPageViewModel(_searchWord, _repository));
  }
}

class _SearchResultPageViewModel {
  /// 検索キーワード
  final String _searchWord;

  /// 対応リポジトリ
  final RankingRepository _repository;

  _SearchResultPageViewModel(this._searchWord, this._repository);

  String pageTitle() {
    return "$_searchWordを含む小説";
  }
}

class _SearchResultPageState extends State<SearchResultPage> {
  final _SearchResultPageViewModel _viewModel;

  _SearchResultPageState(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(_viewModel.pageTitle()),
                pinned: false,
                bottom: TabBar(
                  tabs: [new Tab(text: "人気順"), new Tab(text: "更新順")].toList(),
                  indicatorColor: Colors.white,
                ),
              ),
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 8.0)),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "本好きの下剋上",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: "／" + "香月美夜",
                                      style: TextStyle(color: Colors.black))
                                ])),
                                Divider(),
                                Text(
                                  "ほげほげ",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(height: 4.0), // padding
                                Container(
                                    decoration: new BoxDecoration(
                                        color: sNMBackgroundColor,
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
                                              text: "連載中",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.0)),
                                          TextSpan(
                                              text: "／" + "1234文字",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.0)),
                                          TextSpan(
                                              text: "／" + "2019年3月13日 19:50 更新",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.0)),
                                          TextSpan(
                                              text: "／" + "小説家になろう",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.0))
                                        ]))
                                      ],
                                    ))
                              ],
                            ))));
              }, childCount: 20))
            ],
          ),
        ));
  }
}
