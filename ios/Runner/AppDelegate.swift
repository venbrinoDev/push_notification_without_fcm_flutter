import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController

       
        let tokenChannel = FlutterEventChannel(
            name: "com.example.app/device_token",
            binaryMessenger: controller.binaryMessenger
        )
        
        tokenChannel.setStreamHandler(TokenStreamHandler.shared)

      
        let notificationChannel = FlutterMethodChannel(
            name: "com.example.app/notifications",
            binaryMessenger: controller.binaryMessenger
        )
        
        setUpNotificationMethodChannel(channel: notificationChannel)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    
    func setUpNotificationMethodChannel(channel: FlutterMethodChannel) {
      channel.setMethodCallHandler { [weak self] (call, result) in
          guard let self = self else { return }
          
          if call.method == "registerForPushNotifications" {
              self.registerForPushNotifications(result: result)
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
    }
    
    
    private func registerForPushNotifications(result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                result(FlutterError(code: "PERMISSION_ERROR", message: error.localizedDescription, details: nil))
                return
            }
            
            if granted {
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                result(true)
            } else {
                result(false)
            }
        }
    }

    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        print("This is a new token: \(token)")
        
        TokenStreamHandler.shared.sendToken(token: token)
    }
}

class TokenStreamHandler: NSObject, FlutterStreamHandler {
    static let shared = TokenStreamHandler() // Singleton instance

    private var eventSink: FlutterEventSink?
    private var cachedToken: String? // Cache for token

    private override init() {
    
    }

    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("Flutter started listening")
        
        self.eventSink = eventSink
        
        if let token = cachedToken { // Send cached token if available
            eventSink(token)
            cachedToken = nil
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("Flutter stopped listening")
        eventSink = nil
        return nil
    }

    func sendToken(token: String) {
        print("Sending token to Flutter: \(token)")
        if let sink = eventSink {
            sink(token)
        } else {
            print("No active listener. Caching token: \(token)")
            cachedToken = token // Cache if no listener
        }
    }
}

