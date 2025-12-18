import 'package:tiktok_app_events/interface/tiktok_config.dart';
import 'package:tiktok_app_events/interface/tiktok_event_types.dart';

import 'tiktok_app_events_platform_interface.dart';

export 'interface/tiktok_config.dart';
export 'interface/tiktok_event_types.dart';

/// TikTok App Events SDK Flutter Plugin
///
/// A Flutter plugin for integrating TikTok's App Events SDK to track
/// and report user events to TikTok's advertising platform.
///
/// This plugin supports:
/// - SDK initialization and configuration
/// - 20+ standard event types (e-commerce, subscription, gaming, etc.)
/// - Custom event tracking
/// - User identity management
///
/// Example usage:
/// ```dart
/// final tiktokEvents = TiktokAppEvents();
///
/// // Initialize SDK
/// await tiktokEvents.initSDK(TikTokConfig(
///   appId: 'YOUR_APP_ID',
///   tiktokAppId: 'YOUR_TIKTOK_APP_ID',
///   accessToken: 'YOUR_ACCESS_TOKEN',
///   isDebug: true,
/// ));
///
/// // Track events
/// await tiktokEvents.logPurchase(TikTokPurchaseEvent(...));
/// ```
class TiktokAppEvents {
  /// Returns the current platform version
  Future<String?> getPlatformVersion() {
    return TiktokAppEventsPlatform.instance.getPlatformVersion();
  }

  /// Initializes the TikTok Business SDK
  ///
  /// Must be called before any event tracking.
  /// Returns `true` if initialization succeeds, `false` otherwise.
  ///
  /// [config] - SDK configuration containing app credentials
  Future<bool?> initSDK(TikTokConfig config) {
    return TiktokAppEventsPlatform.instance.initSDK(config);
  }

  // ==================== Generic Events ====================

  /// Tracks a custom event with the given name and optional properties
  ///
  /// Use this method for custom events not covered by standard event methods.
  ///
  /// [eventName] - The name of your custom event
  /// [properties] - Optional key-value pairs of event properties
  Future<void> logEvent(String eventName, {Map<String, dynamic>? properties}) {
    return TiktokAppEventsPlatform.instance
        .logEvent(eventName, properties: properties);
  }

  /// Tracks a standard event using the predefined event type enum
  ///
  /// [eventType] - One of the predefined TikTokEventType values
  /// [properties] - Optional event properties
  Future<void> logStandardEvent(TikTokEventType eventType,
      {Map<String, dynamic>? properties}) {
    return TiktokAppEventsPlatform.instance
        .logEvent(eventType.value, properties: properties);
  }

  // ==================== E-commerce Events ====================

  /// Tracks when a user views content (product page, article, etc.)
  ///
  /// Essential for retargeting campaigns and understanding user interests.
  Future<void> logViewContent(TikTokViewContentEvent event) {
    return TiktokAppEventsPlatform.instance
        .logEvent(TikTokEventType.viewContent.value, properties: event.toMap());
  }

  /// Tracks when a user adds an item to their shopping cart
  ///
  /// Critical for e-commerce conversion optimization and cart abandonment analysis.
  Future<void> logAddToCart(TikTokAddToCartEvent event) {
    return TiktokAppEventsPlatform.instance
        .logEvent(TikTokEventType.addToCart.value, properties: event.toMap());
  }

  /// Tracks when a user adds an item to their wishlist
  ///
  /// [contentId] - Unique identifier for the product/content
  /// [contentType] - Type of content (e.g., 'product')
  /// [contentName] - Optional name of the content
  /// [price] - Optional price of the item
  /// [currency] - Optional currency code (ISO 4217)
  Future<void> logAddToWishlist({
    required String contentId,
    required String contentType,
    String? contentName,
    double? price,
    String? currency,
  }) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.addToWishlist.value,
      properties: {
        'content_id': contentId,
        'content_type': contentType,
        if (contentName != null) 'content_name': contentName,
        if (price != null) 'price': price,
        if (currency != null) 'currency': currency,
      },
    );
  }

  /// Tracks when a user initiates the checkout process
  ///
  /// Helps identify checkout abandonment for optimization.
  Future<void> logInitiateCheckout(TikTokInitiateCheckoutEvent event) {
    return TiktokAppEventsPlatform.instance.logEvent(
        TikTokEventType.initiateCheckout.value,
        properties: event.toMap());
  }

  /// Tracks when a user adds payment information
  ///
  /// [currency] - Optional currency code
  /// [value] - Optional monetary value
  Future<void> logAddPaymentInfo({String? currency, double? value}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.addPaymentInfo.value,
      properties: {
        if (currency != null) 'currency': currency,
        if (value != null) 'value': value,
      },
    );
  }

  /// Tracks when a user completes a payment
  ///
  /// [currency] - Currency code (ISO 4217)
  /// [value] - Payment amount
  /// [orderId] - Optional order identifier
  Future<void> logCompletePayment({
    required String currency,
    required double value,
    String? orderId,
  }) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.completePayment.value,
      properties: {
        'currency': currency,
        'value': value,
        if (orderId != null) 'order_id': orderId,
      },
    );
  }

  /// Tracks when a user places an order (before payment completion)
  ///
  /// [currency] - Currency code (ISO 4217)
  /// [value] - Order total
  /// [orderId] - Optional order identifier
  /// [contents] - Optional list of items in the order
  Future<void> logPlaceAnOrder({
    required String currency,
    required double value,
    String? orderId,
    List<TikTokContentItem>? contents,
  }) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.placeAnOrder.value,
      properties: {
        'currency': currency,
        'value': value,
        if (orderId != null) 'order_id': orderId,
        if (contents != null) 'contents': contents.map((e) => e.toMap()).toList(),
      },
    );
  }

  /// Tracks a completed purchase
  ///
  /// This is the most important e-commerce event for conversion tracking.
  Future<void> logPurchase(TikTokPurchaseEvent event) {
    return TiktokAppEventsPlatform.instance
        .logEvent(TikTokEventType.purchase.value, properties: event.toMap());
  }

  // ==================== Subscription Events ====================

  /// Tracks when a user starts a free trial
  ///
  /// Important for subscription-based apps to track trial conversions.
  Future<void> logStartFreeTrial() {
    return TiktokAppEventsPlatform.instance.logStartFreeTrial();
  }

  /// Tracks a subscription event
  ///
  /// [contentId] - Subscription plan identifier
  /// [contentType] - Type of subscription
  /// [value] - Subscription price
  /// [currency] - Currency code (ISO 4217)
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

  // ==================== User Behavior Events ====================

  /// Tracks when a user completes registration
  ///
  /// [event] - Optional registration details including method used
  Future<void> logCompleteRegistration(
      [TikTokCompleteRegistrationEvent? event]) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.completeRegistration.value,
      properties: event?.toMap(),
    );
  }

  /// Tracks when a user logs in
  Future<void> logLogin() {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.login.value,
    );
  }

  /// Tracks a search event
  ///
  /// Helps understand user intent for better targeting.
  Future<void> logSearch(TikTokSearchEvent event) {
    return TiktokAppEventsPlatform.instance
        .logEvent(TikTokEventType.search.value, properties: event.toMap());
  }

  /// Tracks when a user initiates contact
  Future<void> logContact() {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.contact.value,
    );
  }

  /// Tracks when a user submits a form
  Future<void> logSubmitForm() {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.submitForm.value,
    );
  }

  /// Tracks when a user downloads content
  Future<void> logDownload() {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.download.value,
    );
  }

  /// Tracks when a user clicks a specific button
  ///
  /// [buttonId] - Optional unique button identifier
  /// [buttonName] - Optional button label/name
  Future<void> logClickButton({String? buttonId, String? buttonName}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.clickButton.value,
      properties: {
        if (buttonId != null) 'button_id': buttonId,
        if (buttonName != null) 'button_name': buttonName,
      },
    );
  }

  // ==================== Gaming Events ====================

  /// Tracks when a user achieves a level
  ///
  /// [level] - The level number achieved
  Future<void> logAchieveLevel({required int level}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.achieveLevel.value,
      properties: {'level': level},
    );
  }

  /// Tracks when a user creates a group
  ///
  /// [groupId] - Optional unique group identifier
  Future<void> logCreateGroup({String? groupId}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.createGroup.value,
      properties: {
        if (groupId != null) 'group_id': groupId,
      },
    );
  }

  /// Tracks when a user creates a character/role
  ///
  /// [roleId] - Optional unique role identifier
  Future<void> logCreateRole({String? roleId}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.createRole.value,
      properties: {
        if (roleId != null) 'role_id': roleId,
      },
    );
  }

  /// Tracks when a user spends virtual currency/credits
  ///
  /// [value] - Amount of credits spent
  /// [contentType] - Optional type of purchase
  /// [contentId] - Optional item purchased
  Future<void> logSpendCredits({
    required double value,
    String? contentType,
    String? contentId,
  }) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.spendCredits.value,
      properties: {
        'value': value,
        if (contentType != null) 'content_type': contentType,
        if (contentId != null) 'content_id': contentId,
      },
    );
  }

  /// Tracks when a user unlocks an achievement
  ///
  /// [achievementId] - Unique identifier for the achievement
  Future<void> logUnlockAchievement({required String achievementId}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.unlockAchievement.value,
      properties: {'achievement_id': achievementId},
    );
  }

  // ==================== Other Events ====================

  /// Tracks a lead generation event
  ///
  /// [currency] - Optional currency code
  /// [value] - Optional lead value
  Future<void> logGenerateLead({String? currency, double? value}) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.generateLead.value,
      properties: {
        if (currency != null) 'currency': currency,
        if (value != null) 'value': value,
      },
    );
  }

  /// Tracks when a user rates content or the app
  ///
  /// [ratingValue] - The rating given
  /// [maxRatingValue] - Optional maximum possible rating
  /// [contentType] - Optional type of content rated
  /// [contentId] - Optional identifier of content rated
  Future<void> logRate({
    required double ratingValue,
    double? maxRatingValue,
    String? contentType,
    String? contentId,
  }) {
    return TiktokAppEventsPlatform.instance.logEvent(
      TikTokEventType.rate.value,
      properties: {
        'rating_value': ratingValue,
        if (maxRatingValue != null) 'max_rating_value': maxRatingValue,
        if (contentType != null) 'content_type': contentType,
        if (contentId != null) 'content_id': contentId,
      },
    );
  }

  // ==================== User Identity ====================

  /// Sets user identity information for enhanced tracking
  ///
  /// This helps TikTok match events to specific users for better
  /// attribution and audience building. Email and phone number
  /// are automatically hashed (SHA256) by the SDK before sending.
  ///
  /// [externalId] - Your system's unique user identifier
  /// [externalUserName] - Optional username in your system
  /// [email] - User's email address (will be hashed)
  /// [phoneNumber] - User's phone number (will be hashed)
  Future<void> setUserIdentity({
    String? externalId,
    String? externalUserName,
    String? email,
    String? phoneNumber,
  }) {
    return TiktokAppEventsPlatform.instance.setUserIdentity(
      externalId: externalId,
      externalUserName: externalUserName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  /// Clears user identity and logs out the current user
  ///
  /// Call this when the user logs out of your app to ensure
  /// subsequent events are not attributed to the previous user.
  Future<void> logout() {
    return TiktokAppEventsPlatform.instance.logout();
  }
}
