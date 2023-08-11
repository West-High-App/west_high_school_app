//
//  ContentView.swift
//  Login auth app
//
//  Created by August Andersen on 6/2/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var dataManager = DataManager()
    @State private var email = ""
    @State private var password = ""
    @State var messageText = ""
    @State var userIsLoggedIn = false
    @State var showingHelp = false

    var body: some View {
        if userInfo.loginStatus == "guest" {
            Text("put the guest login app here")
        }
        else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color.blue
            
            ZStack {
                VStack {
                    Text(messageText)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .padding(.top, -10)
                    TextField("Email", text: $email)
                        .font(.body)
                        .padding(.horizontal, 20)
                        .padding(.all)
                        .cornerRadius(9)
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .frame(width: 315, height: 50)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    SecureField("Password", text: $password)
                        .font(.body)
                        .padding(.horizontal, 20)
                        .padding(.all)
                        .cornerRadius(9)
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .frame(width: 315, height: 50)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    Button {
                        login()
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(9.0)
                                .frame(width: 315, height: 50)
                                .foregroundColor(.blue)
                            Text("Log In")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.all)
                                .cornerRadius(9)
                        }
                        
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .frame(width: 315, height: 50)
                            .foregroundColor(.blue))
                    }
                    
                }.padding([.leading, .trailing, .bottom])
                    .padding(.top, 100)
                    .background(Rectangle()
                        .cornerRadius(9.0)
                        .frame(width: 350)
                        .shadow(radius: 5, x: 3, y: 3)
                        .foregroundColor(.white))
                VStack {
                    Image("logo trans")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                    Spacer()
                        .frame(height: 290)
                }
            }
        }
        .ignoresSafeArea()
        
    }
    
    // register for signing up new users, not used in ui
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    // logs in to existing username and password in database
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            print(email)
            if error != nil { // ad email contains here
                print("Error!")
                print(error!.localizedDescription)
                switch error!.localizedDescription {
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    messageText = "No user found. Please try again."
                case "The password is invalid or the user does not have a password.":
                    messageText = "Invalid password. Please try again."
                case "The email address is badly formatted.":
                    messageText = "Bad email. Please try again."
                default:
                    messageText = "Error. Please try again."
                }
            }
            else {
                    messageText = ""
                    print("Login success!")
                    userIsLoggedIn = true
                }
            }
        }
        
    }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
