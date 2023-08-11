import Foundation
import SwiftKeychainWrapper

class UserInfo: ObservableObject {
    // Keychain key for saving login status
    private let loginStatusKey = "loginStatusKey"
    
    // @Published property to observe login status changes
    @Published var loginStatus: String {
        didSet {
            // Save the updated login status to Keychain
            KeychainWrapper.standard.set(loginStatus, forKey: loginStatusKey)
        }
    }
    
    // Data available when user signs in with Google (if loginStatus = "google")
    @Published var displayName: String = ""
    @Published var email: String = ""
    
    init() {
        // Load the login status from Keychain (defaulting to "none" if not found)
        loginStatus = KeychainWrapper.standard.string(forKey: loginStatusKey) ?? "none"
    }
    
    func firstName() -> String {
        let fullname = displayName
        let namelist = fullname.components(separatedBy: " ")
        let name = namelist.first
        return name ?? "student"
    }
}
