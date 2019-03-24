// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:NovelMate/common/datastore/CachedRankingDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';
import 'package:NovelMate/common/repository/RankingRepositoryImpl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'Utils.dart';

class MockCachedDataStore extends Mock implements CachedRankingDataStore {}

class MockRemoteDataStore extends Mock implements RemoteRankingDataStore {}

void main() {
  CachedRankingDataStore _cache;
  RemoteRankingDataStore _remote;
  RankingRepository _subject;

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
          100));

  setUp(() {
    _cache = MockCachedDataStore();
    _remote = MockRemoteDataStore();
    _subject = RankingRepositoryImpl({dummySite: _cache}, {dummySite: _remote});
  });

  group("fetchLatest", () {
    test("キャッシュがない時はリモートデータを返却する", () async {
      when(_remote.fetchRanking(any, any, title: anyNamed("title")))
          .thenAnswer((invocation) {
        return Future.value([dummyNovel]);
      });

      when(_cache.hasCache()).thenAnswer((invocation) {
        return Future.value(false);
      });

      await _subject.fetchLatest(dummySite).then((novels) {
        expect(novels.length, 1);
      });
    });

    test("キャッシュが有る時はキャッシュデータを返却する", () async {
      when(_cache.fetchAll()).thenAnswer((_) {
        return Future.value([dummyNovel]);
      });

      when(_cache.hasCache()).thenAnswer((_) {
        return Future.value(true);
      });

      await _subject.fetchLatest(dummySite);
    });

    group("fetchWithConditions", () {
      test("指定件数での取得ができること(Cache)", () async {
        // キャッシュは常にあるものとしておく
        when(_cache.hasCache()).thenAnswer((_) {
          return Future.value(true);
        });

        when(_cache.fetchAll()).thenAnswer((_) {
          return Future.value(List<int>.generate(100, (i) => i).map((_) {
            return dummyNovel;
          }).toList());
        });

        await _subject.find(dummySite, 0, 50, "").then((novels) {
          expect(novels.length, 50);
        });

        await _subject.find(dummySite, 0, 0, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 0);
        });
      });

      test("検索結果が空でも落ちないこと(Cache)", () async {
        // キャッシュは常にあるものとしておく
        when(_cache.hasCache()).thenAnswer((_) {
          return Future.value(true);
        });

        when(_cache.fetchAll()).thenAnswer((_) {
          return Future.value([]);
        });

        await _subject.find(dummySite, 0, 0, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 0);
        });
      });

      test("指定件数での取得ができること(Network)", () async {
        // キャッシュは常にないものとしておく
        when(_cache.hasCache()).thenAnswer((_) {
          return Future.value(false);
        });

        when(_remote.fetchRanking(any, any, title: anyNamed("title")))
            .thenAnswer((_) {
          return Future.value(List<int>.generate(100, (i) => i).map((_) {
            return dummyNovel;
          }).toList());
        });

        await _subject.find(dummySite, 0, 50, "").then((novels) {
          expect(novels.length, 50);
        });

        await _subject.find(dummySite, 0, 0, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 0);
        });
      });

      test("検索結果が空でも落ちないこと(Network)", () async {
        // キャッシュは常にないものとしておく
        when(_cache.hasCache()).thenAnswer((_) {
          return Future.value(false);
        });

        when(_remote.fetchRanking(any, any, title: anyNamed("title")))
            .thenAnswer((_) {
          return Future.value([]);
        });

        await _subject.find(dummySite, 0, 0, "").then((novels) {
          expect(novels, isNotNull);
          expect(novels.length, 0);
        });
      });
    });
  });
}
