import UIKit
import Flutter
import GoogleMaps
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() //add this before the code below
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    application.registerForRemoteNotifications()
    GMSServices.provideAPIKey("AIzaSyAJ-H6Mxxzq17dMgmJnMRMpNjnOC8f78kA")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for Apple Remote Notifications deviceToken:  \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
         //FCM TOken
         Messaging.messaging().token { token, error in
             if let error = error {
                 print("Error fetching FCM registration token: \(error)")
             } else if let token = token {
                 Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
                 print("token found")
                 print(token)
             }
         }
        // Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
  }

  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
 }

}
