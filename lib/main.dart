// Add a new route to hold the favorites.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/NmLocalization.dart';
import 'package:flutter_app_2/common/colors.dart';
import 'package:flutter_app_2/common/datastore/narou/NarouNetworkDataStore.dart';
import 'package:flutter_app_2/common/entities/narou/NarouNovelListEntity.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

/// アプリ全体のテーマカラーを決定する
final ThemeData _novelMateTheme = _buildNovelMateTheme();

ThemeData _buildNovelMateTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      accentColor: sNMSecondaryColor,
      primaryColor: sNMPrimaryColor,
      buttonColor: sNMSecondaryColor,
      scaffoldBackgroundColor: sNMBackgroundColor,
      textSelectionColor: sNMSecondaryColor,
      errorColor: sNMSecondaryColor,
      canvasColor: sNMBackgroundColor,
      textTheme: base.textTheme.apply(fontFamily: 'Hiragino Kaku Gothic ProN'),
      primaryTextTheme:
          base.primaryTextTheme.apply(fontFamily: 'Hiragino Kaku Gothic ProN'),
      accentTextTheme:
          base.accentTextTheme.apply(fontFamily: 'Hiragino Kaku Gothic ProN'));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          // アプリ固有のローカライゼーション
          NmLocalizationsDelegate(),
          // 事前組み込みのローカライゼーション
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: _novelMateTheme,
        home: new TodoPage(),
        supportedLocales: [
          const Locale('en', ""), // English
          const Locale('ja', ""), // Japanese
        ]);
  }
}

class TodoPage extends StatefulWidget {
  @override
  TodoState createState() {
    return new TodoState();
  }
}

class TodoViewModel {
  final StreamController<List<NarouNovelListEntity>> _entities =
      StreamController.broadcast();

  String inputedTitle = "";

  Stream<List<NarouNovelListEntity>> get entities {
    return _entities.stream;
  }

  void search(String title) {
    _entities.addStream(NarouNetworkDataStore().searchTest(title).asStream());
  }

  void dispose() {
    _entities.close();
  }
}

class TodoState extends State<TodoPage> {
  final TodoViewModel _viewModel = new TodoViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        new SliverAppBar(title: Text(NmLocalizations.of(context).appName), pinned: true, actions: <Widget>[
          new IconButton(icon: new Icon(Icons.favorite), onPressed: null)
        ]),
        new SliverList(
            delegate: SliverChildListDelegate([
          new TextFormField(
              initialValue: _viewModel.inputedTitle,
              onFieldSubmitted: (text) {
                _viewModel.inputedTitle = text;
              }),
          new RaisedButton(
              onPressed: () {
                this.setState(() {
                  _viewModel.search(_viewModel.inputedTitle);
                });
              },
              child: new Text("Search"))
        ])),
        new StreamBuilder<List<NarouNovelListEntity>>(
          stream: _viewModel.entities,
          builder: (context, novels) {
            print(novels);
            // データがない時
            if (!novels.hasData ||
                novels.connectionState == ConnectionState.waiting ||
                novels.connectionState == ConnectionState.none) {
              return SliverList(
                  delegate: SliverChildListDelegate(
                      [new Center(child: new CircularProgressIndicator())]));
            }
            return _buildListView(novels.data);
          },
        )
      ]),
//        body: new CustomScrollView(slivers: <Widget>[
//      new SliverAppBar(title: Text('todo'), pinned: true, actions: <Widget>[
//        new IconButton(icon: new Icon(Icons.favorite), onPressed: null)
//      ]),
//      new Column(
//        children: [
//          new TextField(
//            onChanged: (text) {
//              _viewModel.inputedTitle = text;
//            },
//          ),
//          new RaisedButton(
//              onPressed: () {
//                this.setState(() {
//                  _viewModel.search(_viewModel.inputedTitle);
//                });
//              },
//              child: new Text("Search")),
//          new StreamBuilder<List<NarouNovelListEntity>>(
//            stream: _viewModel.entities,
//            builder: (context, novels) {
//              print(novels);
//              // データがない時
//              if (!novels.hasData) {
//                return new Center(
//                  child: new CircularProgressIndicator(),
//                );
//              }
//              return _buildListView(novels.data);
//            },
//          )
//        ],
//      )
//    ])
    );
  }

  SliverList _buildListView(List<NarouNovelListEntity> novels) {
//    return Scrollbar(
//        child: ListView.separated(
//            shrinkWrap: true,
//            padding: EdgeInsets.all(16.0),
//            // 余白
//            itemBuilder: (context, index) {
//              final novel = novels[index];
//              return new ListTile(title: new Text(novel.title));
//            },
//            separatorBuilder: (context, index) {
//              return new Divider();
//            },
//            itemCount: novels.length));
    return new SliverList(
        delegate: new SliverChildBuilderDelegate((context, index) {
      final title = novels[index].title;
      final story = novels[index].story;
      return Column(children: <Widget>[
        new Divider(),
        new ListTile(
          title: new Text(title),
          subtitle: new Text(story),
        )
      ]);
    }, childCount: novels.length));
  }
}
