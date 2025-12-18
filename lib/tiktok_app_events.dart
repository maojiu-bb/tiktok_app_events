import 'package:tiktok_app_events/interface/tiktok_config.dart';

import 'tiktok_app_events_platform_interface.dart';

class TiktokAppEvents {
  Future<String?> getPlatformVersion() {
    return TiktokAppEventsPlatform.instance.getPlatformVersion();
  }

  Future<bool?> initSDK(TikTokConfig config) {
    return TiktokAppEventsPlatform.instance.initSDK(config);
  }

  /// 普通事件打点
  Future<void> logEvent(String eventName, {Map<String, dynamic>? properties}) {
    return TiktokAppEventsPlatform.instance.logEvent(eventName, properties: properties);
  }

  /// 开始免费试用事件打点
  Future<void> logStartFreeTrial() {
    return TiktokAppEventsPlatform.instance.logStartFreeTrial();
  }

  /// 订阅事件打点
  /// [contentId]：内容 ID
  /// [contentType]：内容类型
  /// [value]：金额
  /// [currency]：货币
  Future<void> logSubscription({
    required String contentId,
    required String contentType,
    required double value,
    required String currency,
  }) {
    return TiktokAppEventsPlatform.instance.logSubscription(
      contentId: contentId,
      contentType: contentType,
      value: value,
      currency: currency,
    );
  }
}
