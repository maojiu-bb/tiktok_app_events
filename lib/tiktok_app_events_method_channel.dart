import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_app_events/interface/tiktok_config.dart';

import 'tiktok_app_events_platform_interface.dart';

/// An implementation of [TiktokAppEventsPlatform] that uses method channels.
class MethodChannelTiktokAppEvents extends TiktokAppEventsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tiktok_app_events');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> initSDK(TikTokConfig config) async {
    final result =
        await methodChannel.invokeMethod<bool>('initSDK', config.toMap());
    return result;
  }

  @override
  Future<void> logEvent(String eventName,
      {Map<String, dynamic>? properties}) async {
    await methodChannel.invokeMethod<void>('logEvent', {
      'eventName': eventName,
      'properties': properties,
    });
  }

  @override
  Future<void> logStartFreeTrial() async {
    await methodChannel.invokeMethod<void>('logStartFreeTrial');
  }

  @override
  Future<void> logSubscription({
    required String contentId,
    required String contentType,
    required double value,
    required String currency,
  }) async {
    await methodChannel.invokeMethod<void>('logSubscription', {
      'contentId': contentId,
      'contentType': contentType,
      'value': value,
      'currency': currency,
    });
  }

  @override
  Future<void> setUserIdentity({
    String? externalId,
    String? externalUserName,
    String? email,
    String? phoneNumber,
  }) async {
    await methodChannel.invokeMethod<void>('setUserIdentity', {
      'externalId': externalId,
      'externalUserName': externalUserName,
      'email': email,
      'phoneNumber': phoneNumber,
    });
  }

  @override
  Future<void> logout() async {
    await methodChannel.invokeMethod<void>('logout');
  }
}
