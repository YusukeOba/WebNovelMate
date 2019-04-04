import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/base/BaseCachedTextDataStore.dart';

class CachedAozoraTextDataStore extends BaseCachedTextDataStore {
  @override
  Site get sourceSite => AvailableSites.aozora;
}
