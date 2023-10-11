import Foundation
import Firebase

struct permission: Identifiable {
    let id = UUID()
    var dataType: String
    var allowedUsers: [String]
    var documentID: String
}

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
    
    init() {
        
        permissions.checkPermissions(dataType: "Clubs Admin", user: user.email) { result in
            self.clubs = result
        }
        permissions.checkPermissions(dataType: "Sports Admin", user: user.email) { result in
            self.sports = result
        }
        permissions.checkPermissions(dataType: "Upcoming Events", user: user.email) { result in
            self.upcomingevents = result
        }
        permissions.checkPermissions(dataType: "Announcements", user: user.email) { result in
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
        permissions.checkPermissions(dataType: "Admin", user: user.email) { result in
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


class permissionsDataManager: ObservableObject {
    
    @Published var permissions: [String: [String]] = [:]
    
    func checkPermissions(dataType: String, user: String, completion: @escaping (Bool) -> Void) {
        
        self.permissions.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Permissions")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(false)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let dataType = data["dataType"] as? String ?? ""
                    let allowedUsers = data["allowedUsers"] as? [String] ?? []
                    let _ = document.documentID
                    
                    self.permissions[dataType] = allowedUsers
                }
            }
            
            var returnValue = false
            for thing in self.permissions {
                if thing.key == dataType {
                    if thing.value.contains(user) {
                        returnValue = true
                    }
                }
            }
            completion(returnValue)
        }
    }
    
    func updatePermission(_ permission: permission, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            let documentRef = db.collection("Permissions").document(permission.documentID)
            
            documentRef.setData([
                "dataType": permission.dataType,
                "allowedUsers": permission.allowedUsers
            ], merge: true) { error in
                completion(error)
            }
        }
    
        
    func updatePermissions(newpermissions: [String: [String]], oldpermissions: [String: [String]], completion: @escaping () -> Void) {
        print("updating permissions")
        var newPermissionsList: [String: [String]] = [:]
        
        for (newDataType, newAllowedUsers) in newpermissions {
                
            for (oldDataType, oldAllowedUsers) in oldpermissions {
                
                if (newDataType == oldDataType) && newAllowedUsers != oldAllowedUsers {
                    
                    newPermissionsList[oldDataType] = newAllowedUsers
                    
                }
                
            }
            }
        let db = Firestore.firestore()
        let ref = db.collection("Permissions")
        ref.getDocuments { snapshot, error in
            
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion()
                return
            }
            if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    let data = document.data()
                    let dataType = data["dataType"] as? String ?? ""
                    let documentID = document.documentID
                    
                    for permission in newPermissionsList {
                        
                        if permission.key == dataType {
                            print("found matching docs")
                            let documentRef = db.collection("Permissions").document(documentID)
                            documentRef.setData([
                            
                                "dataType": dataType,
                                "allowedUsers": permission.value
                                
                            ], merge: true) { error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                }
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
}

