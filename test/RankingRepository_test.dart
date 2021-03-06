// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:NovelMate/common/datastore/CachedIndexDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteIndexDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/IndexRepository.dart';
import 'package:NovelMate/common/repository/IndexRepositoryImpl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'Utils.dart';

class MockCachedDataStore extends Mock implements CachedIndexDataStore {}

class MockRemoteDataStore extends Mock implements RemoteIndexDataStore {}

void main() {
  CachedIndexDataStore _cache;
  RemoteIndexDataStore _remote;
  IndexRepository _subject;

  final subjectNovelIdentifier = "dummy_code_1";

  final dummyNovel = RankingEntity.name(
      200,
      NovelHeader(
          NovelIdentifier(dummySite, subjectNovelIdentifier),
          "Dummy Title",
          "Dummy Story",
          "Dummy weriter",
          true,
          DateTime.now().millisecondsSinceEpoch,
          100,
          100,
          false));

  setUp(() {
    _cache = MockCachedDataStore();
    _remote = MockRemoteDataStore();
    _subject = IndexRepositoryImpl({dummySite: _cache}, {dummySite: _remote});
  });

  group("fetchLatest", () {
    test("キャッシュがない時はリモートデータを返却する", () async {
      when(_remote.fetchRanking(any, any, title: anyNamed("title")))
          .thenAnswer((invocation) {
        return Future.value([dummyNovel]);
      });

      when(_cache.hasCache(CacheType.ranking)).thenAnswer((invocation) {
        return Future.value(false);
      });

      await _subject.fetchRanking(dummySite).then((novels) {
        expect(novels.length, 1);
      });
    });

    test("キャッシュが有る時はキャッシュデータを返却する", () async {
      when(_cache.fetchAll(CacheType.ranking)).thenAnswer((_) {
        return Future.value([dummyNovel]);
      });

      when(_cache.hasCache(CacheType.ranking)).thenAnswer((_) {
        return Future.value(true);
      });

      await _subject.fetchRanking(dummySite);
    });

    group("fetchWithConditions", () {
      test("指定件数での取得ができること(Cache)", () async {
        // キャッシュは常にあるものとしておく
        when(_cache.hasCache(CacheType.search)).thenAnswer((_) {
          return Future.value(true);
        });

        when(_cache.fetchAll(CacheType.search)).thenAnswer((_) {
          return Future.value(List<int>.generate(100, (i) => i).map((_) {
            return dummyNovel;
          }).toList());
        });

        await _subject.find(dummySite, "").then((novels) {
          expect(novels.length, 100);
        });
      });

      test("検索結果が空でも落ちないこと(Cache)", () async {
        // キャッシュは常にあるものとしておく
        when(_cache.hasCache(CacheType.search)).thenAnswer((_) {
          return Future.value(true);
        });

        when(_cache.fetchAll(CacheType.search)).thenAnswer((_) {
          return Future.value([]);
        });

        await _subject.find(dummySite, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 0);
        });
      });

      test("指定件数での取得ができること(Network)", () async {
        // キャッシュは常にないものとしておく
        when(_cache.hasCache(CacheType.search)).thenAnswer((_) {
          return Future.value(false);
        });

        when(_remote.fetchIndex("")).thenAnswer((_) {
          return Future.value(List<int>.generate(100, (i) => i).map((_) {
            return dummyNovel;
          }).toList());
        });

        await _subject.find(dummySite, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 100);
        });
      });

      test("検索結果が空でも落ちないこと(Network)", () async {
        // キャッシュは常にないものとしておく
        when(_cache.hasCache(CacheType.search)).thenAnswer((_) {
          return Future.value(false);
        });

        when(_remote.fetchIndex("")).thenAnswer((_) {
          return Future.value([]);
        });

        await _subject.find(dummySite, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 0);
        });
      });
    });
  });
}
