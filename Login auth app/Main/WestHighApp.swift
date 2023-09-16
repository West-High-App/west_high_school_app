//  Login_auth_appApp.swift
//  Login auth app
//
//  Created by August Andersen on 6/2/23.
// github repo test

// CURRENT PROJECT

import SwiftUI
import Firebase
@main // main function, runs app
struct WestHighApp: App {
    init() {
        let centerl = UNUserNotificationCenter.current()
        centerl.requestAuthorization(options: [.alert, .sound, .badge]) {result, error in
            if let error = error{
                print(error)
            }
        }
        
        struct todaysdate {
            
            var daysToAdd: Int
            
            func isWeekday() -> Bool {
                let dayFormatter = DateFormatter()
                let todaysDate = Date()
                dayFormatter.dateFormat = "EEEE"
                var dateComponent = DateComponents()
                dateComponent.day = daysToAdd
                let day = dayFormatter.string(from: Calendar.current.date(byAdding: dateComponent, to: todaysDate)!)
                var returnValue = true
                if day == "Saturday" || day == "Sunday" {
                    returnValue = false
                }
                return returnValue
            }
        }
        
        
        if todaysdate(daysToAdd: 0).isWeekday(){
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Good Morning Regents!"
            content.body = "Check the app for your daily announcements!"
            
            var dateInfo = DateComponents()
            dateInfo.hour = 8
            dateInfo.minute = 15
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            
            //creating request
            let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
            
            center.add(request){error in
                if let error = error {
                    print(error)
                }
            }
        }
        FirebaseApp.configure()
    }
    
    @StateObject var userInfo = UserInfo.shared
        
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // SplashScreenView -- Splash Screen View - Leads to AuthView
                .environmentObject(userInfo)

        }
    }
}
