//
//  SettingsVIew.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @EnvironmentObject var userInfo: UserInfo

    var body: some View {
        
            VStack{
                List{
                    NavigationLink {
                        LunchMenuView()
                    } label: {
                        HStack{
                            Image(systemName: "lock.shield")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("Privacy & Security")
                                .font(.system(size: 24))
                        }
                    }
                    .padding(.vertical,15)
                    NavigationLink {
                        LunchMenuView()
                    } label: {
                        HStack{
                            Image(systemName: "headphones")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("Help & Support")
                                .font(.system(size: 24))
                        }

                    }
                    .padding(.vertical,15)
                    NavigationLink {
                        StaffView()
                    } label: {
                        HStack{
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("About")
                                .font(.system(size: 24))
                        }
                    }
                    .padding(.vertical,15)
                    NavigationLink {
                        SocialView()
                    } label: {
                        HStack{
                            Image(systemName: "phone.circle")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("Contact Us")
                                .font(.system(size: 24))
                        }

                    }
                    .padding(.vertical,15)
                    Button {
                        do {
                            try Auth.auth().signOut()
                            userInfo.loginStatus = "none"
                        } catch let signOutError {
                            print("tried to sign out failed")
                            print(signOutError.localizedDescription)
                        }
                        
                    } label: {
                        HStack{
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("Sign Out")
                                .font(.system(size: 24))
                        }
                        .padding(.vertical,15)
                        .foregroundColor(.red)
                        }
                }
                .font(.system(size: 22, weight: .regular, design: .rounded))
            }
            .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
