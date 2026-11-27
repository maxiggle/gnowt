import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gnowt_store_method_channel.dart';

abstract class GnowtStorePlatform extends PlatformInterface {
  /// Constructs a GnowtStorePlatform.
  GnowtStorePlatform() : super(token: _token);

  static final Object _token = Object();

  static GnowtStorePlatform _instance = MethodChannelGnowtStore();

  /// The default instance of [GnowtStorePlatform] to use.
  ///
  /// Defaults to [MethodChannelGnowtStore].
  static GnowtStorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GnowtStorePlatform] when
  /// they register themselves.
  static set instance(GnowtStorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
