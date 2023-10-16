import Foundation
import SwiftKeychainWrapper

class UserInfo: ObservableObject {
    private let loginStatusKey: String = "loginStatusKey"
    private let emailKey: String = "emailKey"
    
    static let shared = UserInfo()
    
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
    
    @Published var isAdmin: Bool = false
    @Published var isClubsAdmin: Bool = false
    @Published var isSportsAdmin: Bool = false
    
    @Published var isMMSD: Bool = false
    
    var hasFullViewAccess: Bool {
        return isMMSD || isAdmin
    }
    
    // Data available when user signs in with Google (if loginStatus = "google")
    @Published var displayName: String = ""
    
    init() {
        loginStatus = KeychainWrapper.standard.string(forKey: loginStatusKey) ?? "none"
        email = ""
        if loginStatus == "google" {
            email = KeychainWrapper.standard.string(forKey: emailKey) ?? "no email"
        } else {
            email = "no email"
        }
    }
    
    func firstName() -> String {
        let fullname = displayName
        let namelist = fullname.components(separatedBy: " ")
        let name = namelist.first
        return name ?? "user"
    }
}
