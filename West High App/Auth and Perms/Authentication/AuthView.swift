//
//  AuthView.swift
//  West High App
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import SystemConfiguration

struct GoogleSignInResultModel {
    
    let idToken: String
    let accessToken: String
}

func signInWithGoogle(tokens: GoogleSignInResultModel, bypassing: Bool) async throws -> Bool {
    
    let userInfo = UserInfo.shared
    
    print("Signing in with Google.")
    
    // Tries to sign in using the provided tokens
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    try await Auth.auth().signIn(with: credential)
    
    print("Verified login.")
    
    let allowedDomain = "@madison.k12.wi.us"
    
    if Auth.auth().currentUser?.email?.contains(allowedDomain) != nil {
        DispatchQueue.main.async {
            userInfo.isMMSD = true
        }
    }
    
    return true
}

@MainActor
final class AuthViewModel: ObservableObject {
    
    func startSignInProcess(bypassing: Bool) async throws -> Bool {
        
        // Top view controller window
        guard let topViewController = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        // Signing in
        let SignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
        
        // Tokens needed to sign in
        guard let idToken = SignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = SignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        
        print("Verifying...")
        
        // Signs the user in with the retrieved tokens
        return try await signInWithGoogle(tokens: tokens, bypassing: bypassing)
    }
    
}

import FirebaseFirestore

struct AuthView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State var showingDomainError = false
    
    @StateObject private var viewModel = AuthViewModel()
    @State var shutdownManager = ShutdownManager()
    @EnvironmentObject var userInfo: UserInfo
    
    // Check for an internet connection
    func internetConnectionIsAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }

    
    var body: some View {
        
        if internetConnectionIsAvailable() {
            switch userInfo.loginStatus {
                
                // Displays the menu view if the user is logged in
            case "Google":
                MenuView()
                    .environmentObject(userInfo)
                    .onAppear {
                        userInfo.displayName = Auth.auth().currentUser?.displayName ?? "user"
                        userInfo.email = Auth.auth().currentUser?.email ?? "No email"
                    }
                
            case "Guest":
                MenuView()
                    .environmentObject(userInfo)
                    .onAppear {
                        userInfo.displayName = "guest"
                        userInfo.email = Auth.auth().currentUser?.email ?? "No email"
                    }
                
                // Shows the login screen if the user is not signed in
            default:
                NavigationView {
                    ZStack {
                        
                        Color.westBlue
                        
                        VStack {
                            
                            Text("West High School")
                                .foregroundColor(.black)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                                .padding(.bottom, 5.0)
                                .padding(.top, 25.0)
                            
                            // Sign in with Google button
                            Button {
                                Task {
                                    
                                    do {
                                        if try await viewModel.startSignInProcess(bypassing: false) {
                                            userInfo.loginStatus = "Google"
                                        }
                                        else {
                                            showingDomainError = true
                                        }
                                    } catch {
                                        print(error.localizedDescription) // Test for errors
                                    }
                                    
                                }
                                
                            } label: {
                                HStack {
                                    Spacer()
                                    
                                    Image("Google Logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 35)
                                        .background(Circle().foregroundColor(.white))
                                    
                                    Text("Sign in With Google")
                                        .signInButtonText(color: .white)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }.background(
                                    Rectangle()
                                        .cornerRadius(9.0)
                                        .frame(width: 315, height: 50)
                                        .foregroundColor(Color.blue)
                                )
                                .padding(.all)
                            }
                            
                            // Continue as guest button
                            Button {
                                
                                userInfo.loginStatus = "Guest"
                                
                            } label: {
                                Text("Continue as Guest")
                                    .signInButtonText(color: .black)
                                    .fontWeight(.medium)
                                    .padding(.all)
                                    .background(
                                        Rectangle()
                                            .signInButtonBackground(color: Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            }
                            
                        }
                        .accentColor(Color.westBlue)
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
                    
                }
                .accentColor(.white)
                .environmentObject(userInfo)
            }
            
        // If there is no internet connection
        } else {
            
            ZStack {
                Color.westBlue
                    .ignoresSafeArea()
                
                VStack {
                    Text("No connection")
                        .screenMessageStyle(size: 26)
                    
                    Text("Please check your connection and try again.")
                        .screenMessageStyle(size: 20)
                }
            }
        }
    }
}

    
struct AuthView_Previews: PreviewProvider {
    
    static var previews: some View {
        AuthView()
    }
}


class ShutdownManager: ObservableObject {
    
    var isShutDown = false
    var shutdownMessage = "No info to display"
    
    // Fetches data on whether the app has been manually shut down
    func fetchData(completion: @escaping (Bool, String) -> Void) {
        
        let db = Firestore.firestore()
        let shutdownRef = db.collection("Shutdown")
        
        var isShutDownData = false
        var shutdownMessageData = ""
        shutdownRef.getDocuments { snapshot, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    isShutDownData = data["isShutDown"] as? Bool ?? false
                    shutdownMessageData = data["shutdownMessage"] as? String ?? "No info to display"
                }
            }
            completion(isShutDownData, shutdownMessageData)
        }
    }
}
