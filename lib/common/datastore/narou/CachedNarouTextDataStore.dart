import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/base/BaseCachedTextDataStore.dart';

class CachedNarouTextDataStore extends BaseCachedTextDataStore {

  @override
  Site get sourceSite => AvailableSites.narou;

}
