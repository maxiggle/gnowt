import 'package:flutter_test/flutter_test.dart';
import 'package:gnowt_store/gnowt_store.dart';
import 'package:gnowt_store/gnowt_store_platform_interface.dart';
import 'package:gnowt_store/gnowt_store_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGnowtStorePlatform
    with MockPlatformInterfaceMixin
    implements GnowtStorePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GnowtStorePlatform initialPlatform = GnowtStorePlatform.instance;

  test('$MethodChannelGnowtStore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGnowtStore>());
  });

  test('getPlatformVersion', () async {
    GnowtStore gnowtStorePlugin = GnowtStore();
    MockGnowtStorePlatform fakePlatform = MockGnowtStorePlatform();
    GnowtStorePlatform.instance = fakePlatform;

    expect(await gnowtStorePlugin.getPlatformVersion(), '42');
  });
}
