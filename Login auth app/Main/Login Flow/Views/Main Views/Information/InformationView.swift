//
//  ProfileView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI
import Firebase

struct InformationView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var isPresentingLogoutConfirmation = false
    var body: some View {
            NavigationView{
                List{
                    
                    NavigationLink {
                        StaffView()
                    } label: {
                        Image(systemName: "phone")
                        Text("School Contacts")
                    }
                    .padding(.vertical,10)
                    
                    
                    NavigationLink {
                        LunchMenuView()
                    } label: {
                        Image(systemName: "fork.knife")
                        Text("Lunch Menu")
                    }
                    .padding(.vertical,10)
                    
                    
                    NavigationLink {
                        TransportationView()
                    } label: {
                        Image(systemName: "bus.fill")
                        Text("Transportation")
                    }
                    .padding(.vertical,10)
                    
                    
                    NavigationLink {
                        ClassesView()
                    } label: {
                        Image(systemName: "menucard")
                        Text("Class List")
                    }
                    .padding(.vertical,10)
                    
                    
                    NavigationLink {
                        SchoolPolicyGuideView()
                    } label: {
                        HStack{
                            Image(systemName: "list.bullet")
                                .padding(.leading,3)
                            Text("School Policy Guide")
                                .padding(.leading,3)
                        }
                    }
                    .padding(.vertical,10)
                    
                    
                    NavigationLink {
                        MentalHealthView()
                    } label: {
                        Image(systemName: "heart")
                        Text("Mental Health Resources")
                    }
                    .padding(.vertical,10)
                    
                    
                    NavigationLink {
                        HelpSupportView()
                    } label: {
                        Image(systemName: "questionmark.circle")
                        Text("Help & Support")
                    }.padding(.vertical, 10)
                    
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "book.closed")
                        Text("Terms & Policies")
                    }.padding(.vertical, 10)
                    
                    Button {
                        isPresentingLogoutConfirmation = true
                        
                    } label: {
                        HStack{
                            Spacer()
                            Text("Sign Out")
                            Spacer()
                        }
                        .padding(.vertical,5)
                        .foregroundColor(.red)
                        }
                    
                    
                }
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .navigationBarTitle("Information")
                
                
                .confirmationDialog("Log Out", isPresented: $isPresentingLogoutConfirmation) {
                    Button("Sign Out", role: .destructive) {
                        do {
                            try Auth.auth().signOut()
                            userInfo.loginStatus = "none"
                        } catch let signOutError {
                            print("tried to sign out failed")
                            print(signOutError.localizedDescription)
                        }
                    }
                }
            }
    }
}
    

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
    
