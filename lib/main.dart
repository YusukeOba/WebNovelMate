// Add a new route to hold the favorites.

import 'package:NovelMate/common/NmLocalization.dart';
import 'package:NovelMate/common/colors.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouRankingDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouRankingDataStore.dart';
import 'package:NovelMate/common/repository/RankingRepositoryImpl.dart';
import 'package:NovelMate/page/SearchPage.dart';
import 'package:flutter/material.dart';
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
        theme: _buildNovelMateTheme(),
        home: MainPage(),
        supportedLocales: [
          const Locale('ja', ""), // Japanese
          const Locale('en', ""), // English
        ]);
  }
}

/// メイン画面
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  _MainPageViewModel _viewModel = new _MainPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NmLocalizations.of(context).appName)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text(NmLocalizations.of(context).tabSearch),
              icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              title: Text(NmLocalizations.of(context).tabBookShelf),
              icon: Icon(Icons.book)),
          BottomNavigationBarItem(
              title: Text(NmLocalizations.of(context).tabSettings),
              icon: Icon(Icons.settings))
        ],
        currentIndex: _viewModel.selectedTabIndex,
        onTap: (index) {
          // タブ更新
          setState(() {
            _viewModel.selectedTabIndex = index;
          });
        },
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    switch (_viewModel.selectedTabIndex) {
      case 0:
        return SearchPage(_MainPageViewModel.rankingRepository);
      case 1:
        return Text("NO PAGE 1");
      case 2:
        return Text("NO PAGE 2");
      default:
        break;
    }
  }
}

/// メイン画面のView状態を格納する
class _MainPageViewModel {
  /// 選択中タブ情報
  int selectedTabIndex = 0;

  /// ランキング取得用Repository
  static final rankingRepository = RankingRepositoryImpl(
      [CachedNarouRankingDataStore()], [RemoteNarouRankingDataStore()]);
}
