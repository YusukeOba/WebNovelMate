import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/base/BaseCachedBookshelfDataStore.dart';

class CachedAozoraBookshelfDataStore extends BaseCachedBookshelfDataStore {
  @override
  Site get sourceSite => AvailableSites.aozora;
}
