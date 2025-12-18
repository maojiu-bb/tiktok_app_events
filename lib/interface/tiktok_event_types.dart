/// TikTok Standard Event Types
///
/// These are predefined event types supported by TikTok's advertising platform.
/// Using standard events enables better optimization for your ad campaigns.
///
/// Reference: https://ads.tiktok.com/help/article/standard-events-parameters
enum TikTokEventType {
  /// User reached a specific level in a game or app
  achieveLevel('AchieveLevel'),

  /// User added payment information during checkout
  addPaymentInfo('AddPaymentInfo'),

  /// User added an item to the shopping cart
  addToCart('AddToCart'),

  /// User added an item to their wishlist
  addToWishlist('AddToWishlist'),

  /// User clicked a button (for tracking specific UI interactions)
  clickButton('ClickButton'),

  /// User completed a payment transaction
  completePayment('CompletePayment'),

  /// User completed the registration process
  completeRegistration('CompleteRegistration'),

  /// User initiated contact (e.g., clicked contact button, started chat)
  contact('Contact'),

  /// User created a group (common in social/gaming apps)
  createGroup('CreateGroup'),

  /// User created a character or role (common in gaming apps)
  createRole('CreateRole'),

  /// User downloaded content or a file
  download('Download'),

  /// User action that indicates potential customer interest
  generateLead('GenerateLead'),

  /// User started the checkout process
  initiateCheckout('InitiateCheckout'),

  /// App was launched by the user
  launch('LaunchAPP'),

  /// User logged into the app
  login('Login'),

  /// User placed an order (before payment completion)
  placeAnOrder('PlaceAnOrder'),

  /// User completed a purchase
  purchase('Purchase'),

  /// User rated content or the app
  rate('Rate'),

  /// User performed a search
  search('Search'),

  /// User spent virtual currency or credits
  spendCredits('SpendCredits'),

  /// User started a free trial
  startTrial('StartTrial'),

  /// User subscribed to a service or content
  subscribe('Subscribe'),

  /// User submitted a form
  submitForm('SubmitForm'),

  /// User unlocked an achievement
  unlockAchievement('UnlockAchievement'),

  /// User viewed specific content (product, article, etc.)
  viewContent('ViewContent');

  /// The string value sent to TikTok's API
  final String value;
  const TikTokEventType(this.value);
}

/// Standard parameter keys for TikTok events
///
/// Use these constants to ensure correct parameter naming
/// when building custom event properties.
class TikTokEventParams {
  /// Unique identifier for the content/product
  static const String contentId = 'content_id';

  /// Type/category of content (e.g., 'product', 'article', 'video')
  static const String contentType = 'content_type';

  /// Name or title of the content
  static const String contentName = 'content_name';

  /// Category classification of the content
  static const String contentCategory = 'content_category';

  /// Currency code in ISO 4217 format (e.g., 'USD', 'CNY', 'EUR')
  static const String currency = 'currency';

  /// Total monetary value of the event
  static const String value = 'value';

  /// Price of a single item
  static const String price = 'price';

  /// Number of items
  static const String quantity = 'quantity';

  /// Additional description or details
  static const String description = 'description';

  /// Search query string
  static const String query = 'query';

  /// Level reached in game/app
  static const String level = 'level';

  /// Unique order identifier
  static const String orderId = 'order_id';

  /// Shop or store identifier
  static const String shopId = 'shop_id';
}

/// Purchase Event Data
///
/// Use this class to track completed purchases with detailed
/// product information for better ad optimization.
class TikTokPurchaseEvent {
  /// List of purchased items
  final List<TikTokContentItem> contents;

  /// Currency code (ISO 4217)
  final String currency;

  /// Total purchase value
  final double value;

  /// Optional order identifier
  final String? orderId;

  /// Optional shop/store identifier
  final String? shopId;

  /// Optional purchase description
  final String? description;

  TikTokPurchaseEvent({
    required this.contents,
    required this.currency,
    required this.value,
    this.orderId,
    this.shopId,
    this.description,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'contents': contents.map((e) => e.toMap()).toList(),
      'currency': currency,
      'value': value,
      if (orderId != null) 'order_id': orderId,
      if (shopId != null) 'shop_id': shopId,
      if (description != null) 'description': description,
    };
  }
}

/// Content Item Data
///
/// Represents a single product or content item in events
/// that involve multiple items (cart, checkout, purchase).
class TikTokContentItem {
  /// Unique product/content identifier
  final String contentId;

  /// Type of content (e.g., 'product', 'sku')
  final String contentType;

  /// Product/content name
  final String? contentName;

  /// Product category
  final String? contentCategory;

  /// Unit price
  final double? price;

  /// Quantity of items
  final int? quantity;

  TikTokContentItem({
    required this.contentId,
    required this.contentType,
    this.contentName,
    this.contentCategory,
    this.price,
    this.quantity,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'content_id': contentId,
      'content_type': contentType,
      if (contentName != null) 'content_name': contentName,
      if (contentCategory != null) 'content_category': contentCategory,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
    };
  }
}

/// Add to Cart Event Data
///
/// Track when users add items to their shopping cart.
/// This event is crucial for e-commerce conversion optimization.
class TikTokAddToCartEvent {
  /// Product identifier
  final String contentId;

  /// Product type
  final String contentType;

  /// Product name
  final String? contentName;

  /// Product category
  final String? contentCategory;

  /// Unit price
  final double? price;

  /// Quantity added
  final int? quantity;

  /// Currency code
  final String? currency;

  /// Total value
  final double? value;

  TikTokAddToCartEvent({
    required this.contentId,
    required this.contentType,
    this.contentName,
    this.contentCategory,
    this.price,
    this.quantity,
    this.currency,
    this.value,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'content_id': contentId,
      'content_type': contentType,
      if (contentName != null) 'content_name': contentName,
      if (contentCategory != null) 'content_category': contentCategory,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (currency != null) 'currency': currency,
      if (value != null) 'value': value,
    };
  }
}

/// View Content Event Data
///
/// Track when users view specific content like product pages,
/// articles, or videos. Essential for retargeting campaigns.
class TikTokViewContentEvent {
  /// Content identifier
  final String contentId;

  /// Content type
  final String contentType;

  /// Content name/title
  final String? contentName;

  /// Content category
  final String? contentCategory;

  /// Price (for products)
  final double? price;

  /// Currency code
  final String? currency;

  /// Monetary value
  final double? value;

  TikTokViewContentEvent({
    required this.contentId,
    required this.contentType,
    this.contentName,
    this.contentCategory,
    this.price,
    this.currency,
    this.value,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'content_id': contentId,
      'content_type': contentType,
      if (contentName != null) 'content_name': contentName,
      if (contentCategory != null) 'content_category': contentCategory,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (value != null) 'value': value,
    };
  }
}

/// Initiate Checkout Event Data
///
/// Track when users begin the checkout process.
/// Helps identify checkout abandonment for optimization.
class TikTokInitiateCheckoutEvent {
  /// Items in checkout
  final List<TikTokContentItem> contents;

  /// Currency code
  final String currency;

  /// Total checkout value
  final double value;

  /// Optional description
  final String? description;

  TikTokInitiateCheckoutEvent({
    required this.contents,
    required this.currency,
    required this.value,
    this.description,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'contents': contents.map((e) => e.toMap()).toList(),
      'currency': currency,
      'value': value,
      if (description != null) 'description': description,
    };
  }
}

/// Complete Registration Event Data
///
/// Track successful user registrations with optional metadata
/// about the registration method used.
class TikTokCompleteRegistrationEvent {
  /// How the user registered (e.g., 'email', 'phone', 'google', 'facebook')
  final String? registrationMethod;

  /// Currency (if registration has monetary value)
  final String? currency;

  /// Value (if registration has monetary value, e.g., paid membership)
  final double? value;

  TikTokCompleteRegistrationEvent({
    this.registrationMethod,
    this.currency,
    this.value,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      if (registrationMethod != null) 'registration_method': registrationMethod,
      if (currency != null) 'currency': currency,
      if (value != null) 'value': value,
    };
  }
}

/// Search Event Data
///
/// Track search queries to understand user intent
/// and optimize for search-related conversions.
class TikTokSearchEvent {
  /// The search query string
  final String query;

  /// Type of content being searched
  final String? contentType;

  /// Category filter applied to search
  final String? contentCategory;

  TikTokSearchEvent({
    required this.query,
    this.contentType,
    this.contentCategory,
  });

  /// Converts to map for native platform communication
  Map<String, dynamic> toMap() {
    return {
      'query': query,
      if (contentType != null) 'content_type': contentType,
      if (contentCategory != null) 'content_category': contentCategory,
    };
  }
}
