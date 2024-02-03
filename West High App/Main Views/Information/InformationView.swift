//
//  ProfileView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI
import Firebase

struct InformationView: View {
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @EnvironmentObject var userInfo: UserInfo
    @State var isPresentingLogoutConfirmation = false
    @State var hasAppeared = false
    @State var isAccountViewActive = false
    @State var isShowingAccountDetails = false
    
    @StateObject var linkManager = LinkManager.shared
    
    var body: some View {
            NavigationView{
                List{
                    NavigationLink() {
                        // isShowingAccountDetails = true
                        AccountView()
                            .environmentObject(userInfo)
                    } label: {
                        if userInfo.loginStatus == "Google" {
                            HStack {
                                AsyncImage(url: Auth.auth().currentUser?.photoURL) { phase in
                                    switch phase {
                                    case .empty:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
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
                                .padding(.trailing, 10)
                                Text(userInfo.displayName ?? "User") // if google login, do image + full name, otherwise do person.circle + guest
                            }.foregroundColor(.primary)
                        } else {
                            HStack {
                                Image("guest-user-pfp")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(100)
                                    .padding(.trailing, 10)
                                Text("Guest User")
                            }.foregroundColor(.primary)
                        }
                    }
                    
                    if hasPermission.admin {
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
                        Image(systemName: "fork.knife.circle")
                            .scaleEffect(1.1)

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
                            Image(systemName: "list.bullet.clipboard")
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
                    
                    MyCustomListItemSubview()
                    
                }
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .navigationBarTitle("Information")
                
                .sheet(isPresented: $isShowingAccountDetails) {
                    
                    VStack {
                        Text(userInfo.displayName ?? "User")
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
                                userInfo.loginStatus = "None"
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
            
    }
}


struct MyCustomListItemSubview: View {
    var body: some View {

        NavigationLink {
            JobInternshipView()
        } label: {
            Image(systemName: "magnifyingglass")
            Text("Jobs & Internships ")
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
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView().environmentObject(UserInfo())
    }
}
    
