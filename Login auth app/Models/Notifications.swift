import Foundation
import UserNotifications
import SwiftUI

class NotificationsManager: Identifiable {
    
    init() {
        print("Handling notification permissions...")
        // NotificationsManager.handlePermissions() should be this but using the other func for testing
        NotificationsManager.requestPermissions()
    }
    
    static func requestPermissions() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                // Save the permission status to UserDefaults
                UserDefaults.standard.set(true, forKey: "notificationPermission")
            } else {
                UserDefaults.standard.set(false, forKey: "notificationPermission")
            }
        }
    }
    
    static func checkPermissions() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    // Notifications are already authorized
                } else if settings.authorizationStatus == .denied {
                    // Notifications are denied
                } else {
                    // Request permissions
                    self.requestPermissions()
                }
            }
        }
    }
    
    static func handlePermissions() {
        if let _ = UserDefaults.standard.object(forKey: "notificationPermission") {
            print("Permissions already accepted.")
            // Notification permissions already requested
        } else {
            checkPermissions()
            print("Requesting permissions.")
        }
    }
    
    // sends a notification to people who are logged in with google ** DOESN"T WORK AIDENT EITHER FIX oR DELETE THIS
    func sendNotification(title: String, body: String) {
        let userInfo = UserInfo()
        
        if userInfo.loginStatus == "google" {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false) // sends after 2 seconds
            
            let request = UNNotificationRequest(identifier: "googleUserNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if let error = error {
                    print("Error sending notification: \(error.localizedDescription)")
                } else {
                    print("Notification sent")
                }
            })
        }
    }
}
