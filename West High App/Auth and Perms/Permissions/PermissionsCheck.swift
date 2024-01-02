//
//  PermissionsDataManager.swift
//  West High App
//

import Foundation
import Firebase

class PermissionsCheck: ObservableObject {
    
    static let shared = PermissionsCheck()
    
    var permissions = permissionsDataManager()
    var user = UserInfo()
    var clubmanager = clubManager()
    
    @Published var admin = false
    @Published var clubs = false
    @Published var sports = false
    
    @Published var upcomingevents = false
    @Published var announcements = false
    
    @Published var articles = false
    @Published var articleadmin = false
    @Published var articlewriter = false
        
    var clubarticleadmin: Bool {
        if clubs || articleadmin {
            return true
        } else {
            for club in clubmanager.allclublist {
                if club.adminemails.contains(user.email) {
                    return true
                }
            }
            return false
        }
    }
    
    var clubarticlewriter: Bool {
        if articlewriter {
            return true
        } else {
            for club in clubmanager.allclublist {
                if club.adminemails.contains(user.email) {
                    return true
                }
            }
            return false
        }
    }
    
   var clubartciles: Bool {
        return clubarticleadmin || clubarticlewriter
    }
    
    var hasFullViewAccess: Bool {
        return user.isMMSD || admin || clubs || clubarticleadmin || sports
    }
    
    init() {
        self.updatePermissions()
    }
    
    func updatePermissions() {
        
        permissions.checkPermissions(dataType: "Clubs Admin", user: user.email) { result in
            self.clubs = result
        }
        permissions.checkPermissions(dataType: "Sports Admin", user: user.email) { result in
            self.sports = result
        }
        permissions.checkPermissions(dataType: "Upcoming Events Admin", user: user.email) { result in
            self.upcomingevents = result
        }
        permissions.checkPermissions(dataType: "Announcements Admin", user: user.email) { result in
            self.announcements = result
        }
        permissions.checkPermissions(dataType: "Article Admin", user: user.email) { result in
            self.articleadmin = result
            if result {
                self.articles = result
            }
        }
        permissions.checkPermissions(dataType: "Article Writer", user: user.email) { result in
            self.articlewriter = result
            if result {
                self.articles = result
            }
        }
        permissions.checkPermissions(dataType: "General Admin", user: user.email) { result in
            self.admin = result
            if result {
                self.clubs = true
                self.sports = true
                self.upcomingevents = true
                self.announcements = true
                self.articlewriter = true
                self.articleadmin = true
                self.articles = true
            }
        }
        
    }
}
