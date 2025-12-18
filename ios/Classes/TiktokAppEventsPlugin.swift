import Flutter
import UIKit
import TikTokBusinessSDK

public class TiktokAppEventsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tiktok_app_events", binaryMessenger: registrar.messenger())
        let instance = TiktokAppEventsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initSDK":
            guard let config = call.arguments as? [String: Any],
                  let appId = config["appId"] as? String,
                  let tiktokAppId = config["tiktokAppId"] as? String,
                  let accessToken = config["accessToken"] as? String,
                  let isDebug = config["isDebug"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing init params", details: nil))
                return
            }
            
            let tiktokConfig = TikTokConfig(accessToken: accessToken, appId: appId, tiktokAppId: tiktokAppId)
            
            // 调试模式
            if isDebug {
                tiktokConfig?.enableDebugMode()
                tiktokConfig?.setLogLevel(TikTokLogLevelDebug)
            }
            
            TikTokBusiness.initializeSdk(tiktokConfig) { success, error in
                if (!success) {
                    print("TikTok SDK Init Error: \(error!.localizedDescription)")
                    result(FlutterError(code: "INIT_ERROR", message: "Init error", details: nil))
                    return
                }
                result(true)
            }
            
        case "logEvent":
            guard let args = call.arguments as? [String: Any],
                  let eventName = args["eventName"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing eventName", details: nil))
                return
            }
            let properties = args["properties"] as? [String: Any]
            
            let customEvent = TikTokBaseEvent(name: eventName)
            if let properties = properties {
                customEvent.properties = properties
            }
            TikTokBusiness.trackTTEvent(customEvent)
            result(nil)
            
        case "logStartTrial":
            let trialEvent = TikTokBaseEvent(name: TTEventName.startTrial.rawValue)
            TikTokBusiness.trackTTEvent(trialEvent)
            result(nil)
            
        case "logSubscription":
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
            
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
