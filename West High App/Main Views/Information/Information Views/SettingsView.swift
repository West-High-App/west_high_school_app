//
//  SettingsVIew.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @State var announcementNotifications = true
    @State var sportsNotifications = false
    @State var clubsNotifications = false
    @State var spotlightNotifications = false
    @State var lunchNotifications = false
    @State var selectedAppearance = 1
    @State var selectedLanguage = 1
    @EnvironmentObject var userInfo: UserInfo

    var body: some View {
        VStack {
            List {
                Section(header: Text("Notifications")) {
                    Toggle("Announcements", isOn: $announcementNotifications)
                    Toggle("Sports Updates", isOn: $sportsNotifications)
                    Toggle("Clubs Updates", isOn: $clubsNotifications)
                    Toggle("Student Spotlight", isOn: $spotlightNotifications)
                    Toggle("Daily Lunch Menu", isOn: $lunchNotifications)
                }
                Section(header: Text("Customization")) {
                    Picker("Appearance", selection: $selectedAppearance) {
                        Text("System Setting")
                            .tag(1)
                        Text("Light")
                            .tag(2)
                        Text("Dark")
                            .tag(3)
                    }
                    Picker("Language", selection: $selectedLanguage) {
                        Text("English")
                            .tag(1)
                        Text("Coming soon!")
                            .tag(2)
                    }
                }
                HStack {
                    Spacer()
                    Button("Sign Out", role: .destructive) {
                        do {
                            try Auth.auth().signOut()
                            userInfo.loginStatus = "none"
                        } catch let signOutError {
                            print("tried to sign out failed")
                            print(signOutError.localizedDescription)
                        }
                        
                    }
                    Spacer()
                }
            }
        }.navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
