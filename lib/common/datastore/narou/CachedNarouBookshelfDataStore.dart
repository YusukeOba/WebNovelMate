import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/base/BaseCachedBookshelfDataStore.dart';

class CachedNarouBookshelfDataStore extends BaseCachedBookshelfDataStore {
  @override
  Site get sourceSite => AvailableSites.narou;
}
