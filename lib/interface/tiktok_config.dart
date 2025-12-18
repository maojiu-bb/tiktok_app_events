/// TikTok 配置
/// [appId]：应用 ID
/// [tiktokAppId]：TikTok 应用 ID
/// [accessToken]：TikTok 访问令牌
class TikTokConfig {
  final String appId;
  final String tiktokAppId;
  final String accessToken;
  final bool isDebug;

  TikTokConfig({
    required this.appId,
    required this.tiktokAppId,
    required this.accessToken,
    required this.isDebug,
  });

  Map<String, dynamic> toMap() {
    return {
      'appId': appId,
      'tiktokAppId': tiktokAppId,
      'accessToken': accessToken,
      'isDebug': isDebug,
    };
  }
}
