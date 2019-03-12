// Add a new route to hold the favorites.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/datastore/narou/NarouNetworkDataStore.dart';
import 'package:flutter_app_2/common/entities/narou/NarouNovelListEntity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo',
      home: new TodoPage(),
    );
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
        appBar: AppBar(title: Text('todo'), actions: <Widget>[
          new IconButton(icon: new Icon(Icons.favorite), onPressed: null)
        ]),
        body: Column(
          children: [
            new Flexible(child: new TextField(
              onChanged: (text) {
                _viewModel.inputedTitle = text;
              },
            )),
            new RaisedButton(
                onPressed: () {
                  this.setState(() {
                    _viewModel.search(_viewModel.inputedTitle);
                  });
                },
                child: new Text("Search")),
            new StreamBuilder<List<NarouNovelListEntity>>(
              stream: _viewModel.entities,
              builder: (context, novels) {
                print(novels);
                // データがない時
                if (!novels.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                }
                return _buildListView(novels.data);
              },
            )
          ],
        ));
  }

  Widget _buildListView(List<NarouNovelListEntity> novels) {
    return Scrollbar(
        child: ListView.separated(
            padding: EdgeInsets.all(16.0),
            // 余白
            itemBuilder: (context, index) {
              final novel = novels[index];
              return new ListTile(title: new Text(novel.title));
            },
            separatorBuilder: (context, index) {
              return new Divider();
            },
            itemCount: novels.length));
  }
}
