//
//  ClubSportData.swift
//  West App
//
//  Created by August Andersen on 5/20/23.
//

import Foundation
import Firebase
import UIKit
// MARK: sports
struct sport: Identifiable, Equatable {
    var sportname:String // name of sport
    var sportcoaches: [String] // coach
    var adminemails: [String]
    var sportsimage:String // image name
    var sportsteam: String // varsity, jv, etc.
    var sportsroster:[String] // array of students in sport
    var sportscaptains:[String] // array of captains in sports
    var tags: [Int] // [gender tag, season tag, team tag] all ints
    var info: String
    var imagedata: UIImage // NOT USED IN FIREBASE
    var documentID: String // NOT USED IN FIREBASE
    var sportid: String // NOT USED IN FIREBASE
    var id: Int // NOT USED IN FIREBASE
}
    
class sportsManager: ObservableObject {
    @Published var allsportlist: [sport] = []
    var favoritesports = FavoriteSports()
    @Published var favoriteslist: [sport] = []
    
    init() {
        getSports() { sports in }
        getFavorites { favorites in
            self.favoriteslist = favorites
        }
    }
    
    func getSports(completion: @escaping ([sport]) -> Void) {
        var returnvalue: [sport] = []
        var tempID = 0
        let db = Firestore.firestore()
        let collection = db.collection("Sport")
        
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let sportname = data["sportname"] as? String ?? ""
                    let sportcoaches = data["sportscoaches"] as? [String] ?? []
                    let adminemails = data["adminemails"] as? [String] ?? []
                    let sportsimage = data["sportsimage"] as? String ?? ""
                    let sportsteam = data["sportsteam"] as? String ?? ""
                    let sportsroster = data["sportsroster"] as? [String] ?? []
                    let sportscaptains = data["sportscaptains"] as? [String] ?? []
                    let tags = data["tags"] as? [Int] ?? [1, 1, 1]
                    let info = data["info"] as? String ?? ""
                    let documentID = document.documentID
                    let sportid = "\(sportname) \(sportsteam)"
                    let id = tempID
                    
                    let sport = (sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, imagedata: UIImage(), documentID: documentID, sportid: sportid, id: id))
                    tempID = tempID + 1
                    returnvalue.append(sport)
                }
                
                DispatchQueue.main.async {
                    self.allsportlist = returnvalue
                }
            }
            completion(returnvalue)
        }
    }
    
    func createSport(sport: sport, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Sport").addDocument(data: [
            "sportname": sport.sportname,
            "sportcoaches": sport.sportcoaches,
            "adminemails": sport.adminemails,
            "sportsimage": sport.sportsimage,
            "sportsteam": sport.sportsteam,
            "sportsroster": sport.sportsroster,
            "sportscaptains": sport.sportscaptains,
            "tags": sport.tags,
            "info": sport.info,
        ]) { error in
            completion(error)
            if error == nil {
                self.getSports() { sports in }
            }
        }
    }
    
    func deleteSport(sport: sport, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Sport").document(sport.documentID)
        
        ref.delete { error in
            completion(error)
            if error == nil {
                self.getSports() { sports in }
            }
        }
    }
    
    func updateSport(data: sport) {
        let db = Firestore.firestore()
        let ref = db.collection("Sport").document(data.documentID)
        ref.setData([
            "sportname": data.sportname,
            "sportscoaches": data.sportcoaches,
            "adminemails": data.adminemails,
            "sportsimage": data.sportsimage,
            "sportsteam": data.sportsteam,
            "sportsroster": data.sportsroster,
            "sportscaptains": data.sportscaptains,
            "tags": data.tags,
            "info": data.info,
        ])
    }
    
    func getFavorites(completion: @escaping ([sport]) -> Void) {
        var templist: [sport] = []
        var templist2: [String] = []
        var returnlist: [sport] = []
        
        returnlist = self.allsportlist
        
        favoritesports.getFavorites { [self] favorites in
            templist2 = favorites
            
            self.getSports() { sports in
                templist = sports
                
                for item in templist {
                    for item2 in templist2 {
                        if "\(item.sportname) \(item.sportsteam)" == item2 {
                            returnlist.append(item)
                        }
                    }
                }
                
                completion(returnlist)
            }
        }
    }

    
}


//MARK: clubs
struct club: Identifiable, Equatable {
    let clubname:String
    let clubcaptain:[String]?
    let clubadvisor: [String]
    let clubmeetingroom:String
    let clubdescription:String
    let clubimage:String
    let clubmembercount:String
    let clubmembers:[String]
    let adminemails:[String]
    var imagedata: UIImage // NOT USED IN FIREBASE
    let documentID: String // NOT IN FIREBASE
    let id: Int // NOT IN FIREBASE
}

class clubManager: ObservableObject {
    @Published var allclublist: [club] = []
    var favoriteclubs = FavoriteClubs() // make favorite clubs
    @Published var favoriteslist: [club] = []
    
    init() {
        getClubs() { clubs in
        }
        getFavorites { favorites in
            self.favoriteslist = favorites
        }
    }
    
    func getClubs(completion: @escaping ([club]) -> Void) {
        
        var returnvalue: [club] = []
        let db = Firestore.firestore()
        let collection = db.collection("Clubs")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion([])
            }
            if let snapshot = snapshot {
                var id = 0
                for document in snapshot.documents {
                    let data = document.data()
                    let clubname = data["clubname"] as? String ?? "Unnamed club"
                    let clubcapation = data["clubcaptain"] as! [String]?
                    let clubadvisor = data["clubadvisor"] as? [String] ?? []
                    let clubmeetingroom = data["clubmeetingroom"] as? String ?? ""
                    let clubdescription = data["clubdescription"] as? String ?? ""
                    let clubimage = data["clubimage"] as? String ?? ""
                    let clubmembercount = data["clubmembercount"] as? String ?? ""
                    let clubmembers = data["clubmembers"] as? [String] ?? []
                    let adminemails = data["adminemails"] as? [String] ?? []
                    let documentID = document.documentID
                    
                    let club = club(clubname: clubname, clubcaptain: clubcapation, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, imagedata: UIImage(), documentID: documentID, id: id)
                    id = id + 1
                    returnvalue.append(club)
                 }
                
                DispatchQueue.main.async {
                    self.allclublist = returnvalue
                }
                
            }
            completion(returnvalue)
        }
        
    }
    
    func createClub(club: club, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Clubs").addDocument(data: [
            "adminemails": club.adminemails,
            "clubadvisor": club.clubadvisor,
            "clubcaptain": club.clubcaptain ?? [],
            "clubdescription": club.clubdescription,
            "clubimage": club.clubimage,
            "clubmeetingroom": club.clubmeetingroom,
            "clubmembercount": club.clubmembercount,
            "clubmembers": club.clubmembers,
            "clubname": club.clubname
        ]) { error in
            completion(error)
            if error == nil {
                self.getClubs { clubs in }
            }
        }
    }
    
    func deleteClub(data: club, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Clubs").document(data.documentID)
        
        ref.delete { error in
            completion(error)
            if error == nil {
                self.getClubs() { clubs in}
            }
        }
    }
    
    func updateClub(data: club) {
        let db = Firestore.firestore()
        let ref = db.collection("Clubs").document(data.documentID)
        ref.setData([
            "adminemails": data.adminemails,
            "clubadvisor": data.clubadvisor,
            "clubdescription": data.clubdescription,
            "clubcaptain": data.clubcaptain ?? [],
            "clubimage": data.clubimage,
            "clubmeetingroom": data.clubmeetingroom,
            "clubmembercount": data.clubmembercount,
            "clubmembers": data.clubmembers,
            "clubname": data.clubname
        ])
    }
    
    func getFavorites(completion: @escaping ([club]) -> Void) {
        var templist: [club] = []
        var templist2: [String] = []
        var returnlist: [club] = []
        
        returnlist = self.allclublist

        favoriteclubs.getFavorites { [self] favorites in
            
            templist2 = favorites
            self.getClubs { clubs in
                templist = clubs
                
                for item in templist {
                    for item2 in templist2 {
                        if item.clubname == item2 {
                            returnlist.append(item)
                        }
                    }
                }
              completion(returnlist)
            }
            
        }
    }
    
}


