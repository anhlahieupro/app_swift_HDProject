import UIKit
import UserNotifications

// TODO: Add GoogleService-Info.plist
// MARK: - Configure
//       - add Push Notifications - Capabilities in xcode project
//       - developer.apple.com
//          - create Certificates
//              - create CSR from keychain on mac
//              - upload CSR
//          - download and open *.cer file
//          - export *.p12 from keychain on mac
//       - firebase.google.com
//          - pod install: 'Firebase/Core', 'Firebase/Messaging'
//          - create project
//          - download and import GoogleService-Info.plist
//          - upload *.p12 to firebase

// add: HDNotification.shared.requestAuthorization(), FirebaseApp.configure()
// to: AppDelegate
// application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool

// MARK: - HDNotification

public class HDNotification: NSObject {
    public static let shared = HDNotification()
    
    private override init() { }
}

public extension HDNotification {
    // AppDelegate.swift
    // application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in })
        UNUserNotificationCenter.current().delegate = HDNotification.shared
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func schedule(identifier: String = UUID().uuidString,
                  date: Date         = Date(),
                  title: String      = Bundle.main.appName,
                  body: String,
                  categoryIdentifier: String = "",
                  userInfo: [String: Any]    = [:]) {
        let content                 = UNMutableNotificationContent()
        content.sound               = .default
        content.title               = title
        content.body                = body
        content.categoryIdentifier  = categoryIdentifier
        content.userInfo            = userInfo
        
        let timeIntervalSince1970       = date.timeIntervalSince1970 - Date().timeIntervalSince1970
        let timeInterval: TimeInterval  = (timeIntervalSince1970 <= 0 ? 10 : timeIntervalSince1970)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func handlePendingNotificationRequests(completionHandler: @escaping (_ requests: [UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            completionHandler(requests)
        }
    }
    
    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func handleUserInfo(_ userInfo: [AnyHashable: Any]) {
        guard let urlString = userInfo["urlString"] as? String, !urlString.isEmpty else { return }
        HDUtilities.open(urlString: urlString)
    }
}

extension HDNotification: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleUserInfo(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}
