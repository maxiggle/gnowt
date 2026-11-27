import 'package:gnowt_store/gnowt_store_platform_interface.dart';

/// Placeholder API from the plugin template, replaced by the seed store.
class GnowtStore {
  /// Returns the host platform version reported by the native side.
  Future<String?> getPlatformVersion() {
    return GnowtStorePlatform.instance.getPlatformVersion();
  }
}
