import Flutter
import UIKit
import TikTokBusinessSDK

/// TikTok App Events Flutter Plugin
///
/// This plugin provides a bridge between Flutter and TikTok's Business SDK for iOS,
/// enabling event tracking and user identification for TikTok advertising campaigns.
public class TiktokAppEventsPlugin: NSObject, FlutterPlugin {

    /// Registers the plugin with the Flutter engine
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tiktok_app_events", binaryMessenger: registrar.messenger())
        let instance = TiktokAppEventsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /// Handles method calls from the Flutter side
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initSDK":
            handleInitSDK(call: call, result: result)

        case "logEvent":
            handleLogEvent(call: call, result: result)

        case "logStartFreeTrial":
            handleLogStartFreeTrial(result: result)

        case "logSubscription":
            handleLogSubscription(call: call, result: result)

        case "setUserIdentity":
            handleSetUserIdentity(call: call, result: result)

        case "logout":
            handleLogout(result: result)

        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - SDK Initialization

    /// Initializes the TikTok Business SDK with the provided configuration
    ///
    /// Required parameters:
    /// - appId: Your application's unique identifier
    /// - tiktokAppId: The TikTok App ID from TikTok Ads Manager
    /// - accessToken: API access token for authentication
    /// - isDebug: Enable debug mode for development
    private func handleInitSDK(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let config = call.arguments as? [String: Any],
              let appId = config["appId"] as? String,
              let tiktokAppId = config["tiktokAppId"] as? String,
              let accessToken = config["accessToken"] as? String,
              let isDebug = config["isDebug"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing init params", details: nil))
            return
        }

        let tiktokConfig = TikTokConfig(accessToken: accessToken, appId: appId, tiktokAppId: tiktokAppId)

        // Enable debug mode for development and testing
        if isDebug {
            tiktokConfig?.enableDebugMode()
            tiktokConfig?.setLogLevel(TikTokLogLevelDebug)
        }

        TikTokBusiness.initializeSdk(tiktokConfig) { success, error in
            if (!success) {
                print("TikTok SDK Init Error: \(error?.localizedDescription ?? "Unknown error")")
                result(FlutterError(code: "INIT_ERROR", message: "Init error: \(error?.localizedDescription ?? "Unknown")", details: nil))
                return
            }
            result(true)
        }
    }

    // MARK: - Event Tracking

    /// Tracks a custom event with the specified name and properties
    ///
    /// Parameters:
    /// - eventName: The name of the event to track
    /// - properties: Optional dictionary of event properties
    private func handleLogEvent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let eventName = args["eventName"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing eventName", details: nil))
            return
        }
        let properties = args["properties"] as? [String: Any]

        let customEvent = TikTokBaseEvent(name: eventName)
        if let properties = properties {
            // Add all properties to the event
            for (key, value) in properties {
                customEvent.addProperty(withKey: key, value: value)
            }
        }
        TikTokBusiness.trackTTEvent(customEvent)
        result(nil)
    }

    /// Tracks a free trial start event
    ///
    /// This is a standard TikTok event for subscription-based apps
    private func handleLogStartFreeTrial(result: @escaping FlutterResult) {
        let trialEvent = TikTokBaseEvent(name: TTEventName.startTrial.rawValue)
        TikTokBusiness.trackTTEvent(trialEvent)
        result(nil)
    }

    /// Tracks a subscription event with detailed information
    ///
    /// Parameters:
    /// - contentId: Subscription plan identifier
    /// - contentType: Type of subscription
    /// - value: Subscription price
    /// - currency: Currency code (ISO 4217)
    private func handleLogSubscription(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let contentId = args["contentId"] as? String,
              let contentType = args["contentType"] as? String,
              let value = args["value"] as? Double,
              let currency = args["currency"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing subscription params", details: nil))
            return
        }

        let subscribeEvent = TikTokBaseEvent(name: TTEventName.subscribe.rawValue)
        subscribeEvent.addProperty(withKey: "content_id", value: contentId)
        subscribeEvent.addProperty(withKey: "content_type", value: contentType)
        subscribeEvent.addProperty(withKey: "value", value: value)
        subscribeEvent.addProperty(withKey: "currency", value: currency)

        TikTokBusiness.trackTTEvent(subscribeEvent)
        result(nil)
    }

    // MARK: - User Identity

    /// Sets user identity for enhanced event attribution
    ///
    /// This method helps TikTok match events to specific users for better
    /// attribution and audience building. Email and phone number are
    /// automatically hashed by the SDK before transmission.
    ///
    /// Parameters:
    /// - externalId: Your system's unique user identifier
    /// - externalUserName: Optional username in your system
    /// - email: User's email address (will be hashed)
    /// - phoneNumber: User's phone number (will be hashed)
    private func handleSetUserIdentity(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing identity params", details: nil))
            return
        }

        let externalId = args["externalId"] as? String
        let externalUserName = args["externalUserName"] as? String
        let email = args["email"] as? String
        let phoneNumber = args["phoneNumber"] as? String

        // Call the TikTok SDK identify method
        TikTokBusiness.identify(withExternalID: externalId, externalUserName: externalUserName, phoneNumber: phoneNumber, email: email)

        result(nil)
    }

    /// Clears user identity and logs out the current user
    ///
    /// Call this when the user logs out of your app to ensure
    /// subsequent events are not attributed to the previous user.
    private func handleLogout(result: @escaping FlutterResult) {
        TikTokBusiness.logout()
        result(nil)
    }
}
