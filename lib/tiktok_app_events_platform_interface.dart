import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tiktok_app_events/interface/tiktok_config.dart';

import 'tiktok_app_events_method_channel.dart';

abstract class TiktokAppEventsPlatform extends PlatformInterface {
  /// Constructs a TiktokAppEventsPlatform.
  TiktokAppEventsPlatform() : super(token: _token);

  static final Object _token = Object();

  static TiktokAppEventsPlatform _instance = MethodChannelTiktokAppEvents();

  /// The default instance of [TiktokAppEventsPlatform] to use.
  ///
  /// Defaults to [MethodChannelTiktokAppEvents].
  static TiktokAppEventsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TiktokAppEventsPlatform] when
  /// they register themselves.
  static set instance(TiktokAppEventsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> initSDK(TikTokConfig config) {
    throw UnimplementedError('initSDK() has not been implemented.');
  }

  Future<void> logEvent(String eventName, {Map<String, dynamic>? properties}) {
    throw UnimplementedError('logEvent() has not been implemented.');
  }

  Future<void> logStartFreeTrial() {
    throw UnimplementedError('logStartFreeTrial() has not been implemented.');
  }

  Future<void> logSubscription({
    required String contentId,
    required String contentType,
    required double value,
    required String currency,
  }) {
    throw UnimplementedError('logSubscription() has not been implemented.');
  }
}
