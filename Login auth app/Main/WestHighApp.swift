//  Login_auth_appApp.swift
//  Login auth app
//
//  Created by August Andersen on 6/2/23.
//

import SwiftUI
import Firebase

@main // main function, runs app
struct WestHighApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView() // starts at the authentication screen
        }
        }
    }
