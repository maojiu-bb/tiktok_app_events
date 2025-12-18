# tiktok_app_events

A Flutter plugin for integrating TikTok's App Events SDK to track and report user events to TikTok's advertising platform.

## Features

- SDK initialization and configuration
- 20+ standard event types (e-commerce, subscription, gaming, etc.)
- Custom event tracking with flexible properties
- User identity management for enhanced attribution
- Complete e-commerce event funnel support

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  tiktok_app_events:
    git:
      url: https://github.com/your-repo/tiktok_app_events.git
```

### iOS Setup

1. Ensure minimum iOS version is 12.0 in `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

2. Add App Tracking Transparency (ATT) description to `ios/Runner/Info.plist`:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>Your tracking usage description here</string>
```

3. Run `pod install` in the `ios` directory.

## Getting Started

### Prerequisites

To use this plugin, you need:
1. A TikTok Ads Manager account
2. An app registered in TikTok Ads Manager
3. App ID, TikTok App ID, and Access Token from your app settings

### Initialize the SDK

```dart
import 'package:tiktok_app_events/tiktok_app_events.dart';

final tiktokAppEvents = TiktokAppEvents();

// Initialize SDK (call this early in your app lifecycle)
await tiktokAppEvents.initSDK(
  TikTokConfig(
    appId: 'YOUR_APP_ID',
    tiktokAppId: 'YOUR_TIKTOK_APP_ID',
    accessToken: 'YOUR_ACCESS_TOKEN',
    isDebug: true, // Set to false in production
  ),
);
```

## Usage

### User Identity

Set user identity for better attribution and audience building:

```dart
await tiktokAppEvents.setUserIdentity(
  externalId: 'user_12345',
  externalUserName: 'john_doe',
  email: 'user@example.com',      // Will be hashed automatically
  phoneNumber: '+1234567890',      // Will be hashed automatically
);

// Clear identity when user logs out
await tiktokAppEvents.logout();
```

### E-commerce Events

Track the complete purchase funnel:

```dart
// View Content
await tiktokAppEvents.logViewContent(
  TikTokViewContentEvent(
    contentId: 'product_001',
    contentType: 'product',
    contentName: 'iPhone 15 Pro',
    price: 999.0,
    currency: 'USD',
  ),
);

// Add to Cart
await tiktokAppEvents.logAddToCart(
  TikTokAddToCartEvent(
    contentId: 'product_001',
    contentType: 'product',
    price: 999.0,
    quantity: 1,
    currency: 'USD',
    value: 999.0,
  ),
);

// Initiate Checkout
await tiktokAppEvents.logInitiateCheckout(
  TikTokInitiateCheckoutEvent(
    contents: [
      TikTokContentItem(
        contentId: 'product_001',
        contentType: 'product',
        price: 999.0,
        quantity: 1,
      ),
    ],
    currency: 'USD',
    value: 999.0,
  ),
);

// Complete Purchase
await tiktokAppEvents.logPurchase(
  TikTokPurchaseEvent(
    contents: [
      TikTokContentItem(
        contentId: 'product_001',
        contentType: 'product',
        price: 999.0,
        quantity: 1,
      ),
    ],
    currency: 'USD',
    value: 999.0,
    orderId: 'ORDER_12345',
  ),
);
```

### Subscription Events

```dart
// Start Free Trial
await tiktokAppEvents.logStartFreeTrial();

// Subscribe
await tiktokAppEvents.logSubscription(
  contentId: 'premium_monthly',
  contentType: 'subscription',
  value: 9.99,
  currency: 'USD',
);
```

### User Behavior Events

```dart
// Complete Registration
await tiktokAppEvents.logCompleteRegistration(
  TikTokCompleteRegistrationEvent(registrationMethod: 'email'),
);

// Login
await tiktokAppEvents.logLogin();

// Search
await tiktokAppEvents.logSearch(
  TikTokSearchEvent(
    query: 'wireless headphones',
    contentType: 'product',
  ),
);

// Contact
await tiktokAppEvents.logContact();

// Submit Form
await tiktokAppEvents.logSubmitForm();

// Download
await tiktokAppEvents.logDownload();
```

### Gaming Events

```dart
// Achieve Level
await tiktokAppEvents.logAchieveLevel(level: 10);

// Spend Credits
await tiktokAppEvents.logSpendCredits(
  value: 100.0,
  contentType: 'virtual_currency',
  contentId: 'gold_coins',
);

// Unlock Achievement
await tiktokAppEvents.logUnlockAchievement(achievementId: 'first_win');

// Create Role
await tiktokAppEvents.logCreateRole(roleId: 'warrior');

// Create Group
await tiktokAppEvents.logCreateGroup(groupId: 'guild_001');
```

### Custom Events

```dart
// Track any custom event
await tiktokAppEvents.logEvent(
  'CustomEventName',
  properties: {
    'custom_param_1': 'value1',
    'custom_param_2': 123,
    'custom_param_3': true,
  },
);

// Or use the standard event type enum
await tiktokAppEvents.logStandardEvent(
  TikTokEventType.viewContent,
  properties: {'content_id': 'article_001'},
);
```

## Supported Standard Events

| Event Type | Method | Description |
|------------|--------|-------------|
| ViewContent | `logViewContent()` | User views content |
| AddToCart | `logAddToCart()` | User adds item to cart |
| AddToWishlist | `logAddToWishlist()` | User adds item to wishlist |
| InitiateCheckout | `logInitiateCheckout()` | User starts checkout |
| AddPaymentInfo | `logAddPaymentInfo()` | User adds payment info |
| CompletePayment | `logCompletePayment()` | User completes payment |
| PlaceAnOrder | `logPlaceAnOrder()` | User places order |
| Purchase | `logPurchase()` | User completes purchase |
| StartTrial | `logStartFreeTrial()` | User starts free trial |
| Subscribe | `logSubscription()` | User subscribes |
| CompleteRegistration | `logCompleteRegistration()` | User completes registration |
| Login | `logLogin()` | User logs in |
| Search | `logSearch()` | User performs search |
| Contact | `logContact()` | User initiates contact |
| SubmitForm | `logSubmitForm()` | User submits form |
| Download | `logDownload()` | User downloads content |
| ClickButton | `logClickButton()` | User clicks button |
| AchieveLevel | `logAchieveLevel()` | User achieves level |
| CreateGroup | `logCreateGroup()` | User creates group |
| CreateRole | `logCreateRole()` | User creates role |
| SpendCredits | `logSpendCredits()` | User spends credits |
| UnlockAchievement | `logUnlockAchievement()` | User unlocks achievement |
| GenerateLead | `logGenerateLead()` | Lead generation event |
| Rate | `logRate()` | User rates content |

## Best Practices

1. **Initialize Early**: Call `initSDK()` as early as possible in your app lifecycle.
2. **Set User Identity**: Call `setUserIdentity()` after user login for better attribution.
3. **Clear on Logout**: Always call `logout()` when users sign out.
4. **Use Standard Events**: Prefer standard events over custom events when possible.
5. **Include Value**: Always include `currency` and `value` for monetary events.
6. **Debug Mode**: Use `isDebug: true` during development, set to `false` in production.

## Troubleshooting

### Common Issues

1. **SDK not initializing**: Ensure all required parameters (appId, tiktokAppId, accessToken) are correct.
2. **Events not appearing**: Check if ATT permission is granted on iOS 14+.
3. **Build errors on iOS**: Run `pod install` after adding the dependency.

### Debug Mode

Enable debug mode to see detailed logs:

```dart
TikTokConfig(
  // ... other params
  isDebug: true,
)
```

## References

- [TikTok App Events SDK Documentation](https://ads.tiktok.com/help/article/about-the-tiktok-app-events-sdk)
- [Integrate App Events SDK](https://ads.tiktok.com/help/article/how-to-integrate-tiktok-app-events-sdk)
- [Supported In-App Events](https://ads.tiktok.com/help/article/all-supported-in-app-events)
- [Standard Events and Parameters](https://ads.tiktok.com/help/article/standard-events-parameters)
- [TikTok Business iOS SDK (GitHub)](https://github.com/tiktok/tiktok-business-ios-sdk)

## License

MIT License
