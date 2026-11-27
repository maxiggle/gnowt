import 'gnowt_store_platform_interface.dart';

class GnowtStore {
  Future<String?> getPlatformVersion() {
    return GnowtStorePlatform.instance.getPlatformVersion();
  }
}
