//
//  AccountView.swift
//  West High App
//
//  Created by August Andersen on 14/09/2023.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    
    @EnvironmentObject var userInfo: UserInfo // @StateObject
    @State var isPresentingLogoutConfirmation = false
    @State private var profileImage: Image?

    var body: some View {
                    
            VStack {
                Form {
                    if userInfo.loginStatus == "google" {
                    HStack {
                        AsyncImage(url: Auth.auth().currentUser?.photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
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
                        Text(userInfo.displayName)
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .padding(.vertical)
                    }
                    Text("Email: \(userInfo.email)")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                    } else {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .cornerRadius(100)
                            Text("Guest User")
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .padding(.vertical)
                        }.foregroundColor(.primary)
                        Text("You are logged in as a guest.")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                    }
                    Button {
                        isPresentingLogoutConfirmation = true
                    } label: {
                        HStack{
                            Spacer()
                            Text("Sign Out")
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                            Spacer()
                        }
                        .padding(.vertical,5)
                        .foregroundColor(.red)
                    }
                    
                }
            }.navigationTitle("User Info")
                .confirmationDialog("Log Out", isPresented: $isPresentingLogoutConfirmation) {
                    Button("Sign Out", role: .destructive) {
                        do {
                            print("trying to sign out.")
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
