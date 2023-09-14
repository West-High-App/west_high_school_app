//
//  FirstView.swift
//  Login auth app
//
//  Created by August Andersen on 7/8/23. fhello
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

// MARK: SIGN IN FUNCTIONS
func SignInGoogle(tokens: GoogleSignInResultModel, bypass: Bool) async throws -> Bool {
    print("Signing in to Google.")
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    let _ = try await Auth.auth().signIn(with: credential)
    let allowedDomain = "@madison.k12.wi.us"
    //if Auth.auth().currentUser?.email?.contains(allowedDomain) != nil && bypass == false {
    //    print("Incorrect domain.")
    //    try Auth.auth().signOut()
    //    return false
    //}
    // else {
        print("Domain verified.")
        return true
    // }
    }


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInWithGoogle(bypassing: Bool) async throws -> Bool {
        
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost) // top view controller window
        }
        
        let SignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC) // signs in all that stuff
        
        guard let idToken = SignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = SignInResult.user.accessToken.tokenString // these two match to verify login
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        
        print("Verifying...")
        return try await SignInGoogle(tokens: tokens, bypass: bypassing) // tokens: tokens
    }
    
}

struct AuthView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State var messageText = ""
    @State var userIsLoggedIn = false
    @State var count = 0
    @State var showingDomainError = false
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    @StateObject private var viewModel = AuthenticationViewModel()
    @StateObject var dataManager = DataManager()
    @StateObject var userInfo = UserInfo()
    
    var body: some View {
        
        if userInfo.loginStatus == "google" {
            MenuView()
                .environmentObject(userInfo)
                .onAppear {
                    userInfo.displayName = Auth.auth().currentUser?.displayName ?? "student"
                    userInfo.email = Auth.auth().currentUser?.email ?? "no email found"
                }
        }
        
        else if userInfo.loginStatus == "guest" {
            MenuView()
                .environmentObject(userInfo)
                .onAppear {
                    userInfo.displayName = "guest"
                    userInfo.email = Auth.auth().currentUser?.email ?? "no email found"
                }
        }
        
        else {
            NavigationView {
                ZStack {
                    westblue
                    VStack {
                        
                         // GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                        Text("West High School")
                            .foregroundColor(.black)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .padding(.horizontal)
                            .padding(.bottom, 5.0)
                            .padding(.top, 25.0)
                        Button {
                            Task {
                                do {
                                    if count == 0 {
                                        if try await viewModel.signInWithGoogle(bypassing: false) {
                                            
                                            print("User logged in with Google. Email: \(Auth.auth().currentUser!.email ?? "No email found.")")
                                            
                                            userInfo.loginStatus = "google"
                                            count = 1
                                        }
                                        else {
                                            print("Unsuccesful login.")
                                            showingDomainError = true
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label : {
                            HStack {
                                Spacer()
                                Image("Google Logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 35)
                                    .background(
                                    Circle()
                                        .foregroundColor(.white)
                                    )
                                Text("Sign in With Google")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .cornerRadius(9)
                                Spacer()
                            }.background(
                                Rectangle()
                                    .cornerRadius(9.0)
                                    .frame(width: 315, height: 50)
                                    .foregroundColor(Color.blue)
                            )
                            .padding(.all)
                        }
                        
                        Button {
                            
                            userInfo.loginStatus = "guest"
                            print("Logged in as guest.")
                            
                        } label: {
                            Text("Continue as Guest")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.all)
                                .cornerRadius(9)
                                .background(
                                    Rectangle()
                                        .cornerRadius(9.0)
                                        .frame(width: 315, height: 50)
                                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
                                )
                        }
                        
                    }.accentColor(westblue)
                        .padding([.leading, .trailing, .bottom])
                        .padding(.top, 50)
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .frame(width: 350)
                            .shadow(radius: 5, x: 3, y: 3)
                            .foregroundColor(.white))
                    VStack {
                        Image("Regents Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Spacer()
                            .frame(height: 290)
                    }
                }.ignoresSafeArea()
            }.accentColor(.white)
                .environmentObject(userInfo)
            
                .alert(isPresented: $showingDomainError) {
                    Alert (
                        title: Text("Incorrect Domain"),
                        message: Text("You must have a 'madison.k12.wi.us' email to sign in with Google."),
                        primaryButton: .destructive(Text("Bypass Domain Verification")) {
                            print("Bypassing Domain Verification...")
                            
                            Task {
                                do {
                                    if count == 0 {
                                        if try await viewModel.signInWithGoogle(bypassing: true) {
                                            print("User logged in with Google. Email: \(Auth.auth().currentUser!.email ?? "No email found.")")
                                            userInfo.loginStatus = "google"
                                            count = 1
                                        }
                                        else {
                                            print("Unsuccesful login.")
                                            showingDomainError = true
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                        },
                        secondaryButton: .default(Text("Cancel")) {
                            showingDomainError = false
                        }
                        )
                }
        }
        
    }
}

    
    struct AuthView_Previews: PreviewProvider {
        static var previews: some View {
            AuthView()
        }
    }
