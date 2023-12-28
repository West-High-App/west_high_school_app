//
// UserInfo.swift
// West High App
//

import Foundation
import SwiftKeychainWrapper

class UserInfo: ObservableObject {
    
    static let shared = UserInfo()
    
    private let loginStatusKey = "loginStatusKey"
    private let emailKey = "emailKey"
    
    // Login status of the user ("Google", "Guest", or "None")
    @Published var loginStatus: String {
        didSet {
            KeychainWrapper.standard.set(loginStatus, forKey: loginStatusKey)
        }
    }
    
    @Published var email: String {
        didSet {
            KeychainWrapper.standard.set(email, forKey: emailKey)
        }
    }
    
    @Published var isAdmin = false
    @Published var isSportsAdmin = false
    @Published var isMMSD = false
    @Published var displayName = "user"
    
    init() {
        
        // Sets the login status based on the locally stored value
        loginStatus = KeychainWrapper.standard.string(forKey: loginStatusKey) ?? "None"
        email = "No email"
        
        // Sets the email of the user based on the locally stored value
        if loginStatus == "Google" {
            email = KeychainWrapper.standard.string(forKey: emailKey) ?? "No email"
        }
    }
    
    // Returns the fisrt name from a full name (eg. "Dan" from "Dan Kigeya")
    func firstName() -> String {
        let fullname = displayName
        let namelist = fullname.components(separatedBy: " ")
        let name = namelist.first
        return name ?? "user"
    }
}
