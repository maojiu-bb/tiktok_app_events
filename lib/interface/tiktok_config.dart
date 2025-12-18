/// TikTok SDK Configuration
///
/// This class holds all the necessary configuration parameters
/// required to initialize the TikTok Business SDK.
///
/// To obtain these values:
/// 1. Log in to TikTok Ads Manager
/// 2. Navigate to Assets > Events > App Events
/// 3. Create or select your app to get the required IDs
class TikTokConfig {
  /// Your application's unique identifier in your system
  final String appId;

  /// The TikTok App ID assigned to your app in TikTok Ads Manager
  /// This can be found in the App Events setup page
  final String tiktokAppId;

  /// The access token for authenticating API requests
  /// Generated in TikTok Ads Manager under App Events settings
  final String accessToken;

  /// Enable debug mode for development and testing
  /// When enabled, the SDK will output detailed logs
  /// Set to false in production builds
  final bool isDebug;

  TikTokConfig({
    required this.appId,
    required this.tiktokAppId,
    required this.accessToken,
    required this.isDebug,
  });

  /// Converts the configuration to a map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'appId': appId,
      'tiktokAppId': tiktokAppId,
      'accessToken': accessToken,
      'isDebug': isDebug,
    };
  }
}
