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
    @State var hasAdmin = false
    @StateObject var permissionsManager = permissionsDataManager()
    @State var hasAppeared = false
    @State var isAccountViewActive = false
    @State var isShowingAccountDetails = false
    var body: some View {
            NavigationView{
                List{
                    NavigationLink() {
                        // isShowingAccountDetails = true
                        AccountView()
                            .environmentObject(userInfo)
                    } label: {
                        if userInfo.loginStatus == "google" {
                            HStack {
                                AsyncImage(url: Auth.auth().currentUser?.photoURL) { phase in
                                    switch phase {
                                    case .empty:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(100)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(100)
                                    default:
                                        EmptyView()
                                    }
                                }
                                Text(userInfo.displayName) // if google login, do image + full name, otherwise do person.circle + guest
                            }.foregroundColor(.primary)
                        } else {
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Guest User")
                            }.foregroundColor(.primary)
                        }
                    }.padding(.vertical, 10)
                    
                    if hasAdmin {
                        NavigationLink {
                            PermissionsAdminView()
                        } label: {
                            Image(systemName: "lock")
                            Text("Edit Admin Permissions")
                                .padding(10)
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                        }.foregroundColor(.blue)

                    }
                    
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
                        ClassesListView()
                    } label: {
                        Image(systemName: "book")
                        Text("Courses Info")
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
                    
                    MyCustomListItemSubview()
                    
                    
                }
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .navigationBarTitle("Information")
                
                .sheet(isPresented: $isShowingAccountDetails) {
                    
                    VStack {
                        Text(userInfo.displayName)
                        Text(userInfo.email)
                        Text(Auth.auth().currentUser?.phoneNumber ?? "")
                        AsyncImage(url: Auth.auth().currentUser?.photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                            default:
                                EmptyView()
                            }
                        }
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
                                Spacer()
                                Text("Sign Out")
                                Spacer()
                            }
                            .padding(.vertical,5)
                            .foregroundColor(.red)
                        }
                        
                    }
                    
                }
                
            }
            
            
            .onAppear {
                
                if !hasAppeared {
                    
                    permissionsManager.checkPermissions(dataType: "Admin", user: userInfo.email) { bool in
                        hasAdmin = bool
                    }
                    
                    hasAppeared = true
                }
                
            }
    }
}


struct MyCustomListItemSubview: View {
    var body: some View {
        NavigationLink {
            SettingsView()
        } label: {
            Image(systemName: "book.closed")
            Text("Terms & Policies")
        }.padding(.vertical, 10)

        NavigationLink {
            JobInternshipView()
        } label: {
            Image(systemName: "magnifyingglass")
            Text("Jobs & Internships ")
        }
        .padding(.vertical,10)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView().environmentObject(UserInfo())
    }
}
    
