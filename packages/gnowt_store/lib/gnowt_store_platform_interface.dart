import 'package:gnowt_store/gnowt_store_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that platform implementations of gnowt_store extend.
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

  /// Returns the host platform version reported by the native side.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
