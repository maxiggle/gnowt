import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:gnowt_store/gnowt_store_platform_interface.dart';

/// An implementation of [GnowtStorePlatform] that uses method channels.
class MethodChannelGnowtStore extends GnowtStorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gnowt_store');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
