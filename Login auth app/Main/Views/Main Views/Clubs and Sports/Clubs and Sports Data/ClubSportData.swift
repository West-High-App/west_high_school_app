//
//  ClubSportData.swift
//  West App
//
//  Created by August Andersen on 5/20/23.
//

import Foundation
import Firebase
import UIKit
import SwiftUI
// MARK: sports
struct sport: Identifiable, Equatable, Hashable {
    var sportname:String // name of sport
    var sportcoaches: [String] // coach
    var adminemails: [String]
    var editoremails: [String]
    var sportsimage:String // image name
    var sportsteam: String // varsity, jv, etc.
    var sportsroster:[String] // array of students in sport
    var sportscaptains:[String] // array of captains in sports
    var tags: [Int] // [gender tag, season tag, team tag] all ints
    var info: String
    var favoritedusers: [String] // list of email of users who have it as favorite
    var eventslink: String // link to site with all events
    var imagedata: UIImage? // NOT USED IN FIREBASE
    var documentID: String // NOT USED IN FIREBASE
    var sportid: String // NOT USED IN FIREBASE
    var id: Int // NOT USED IN FIREBASE
}
    
class sportsManager: ObservableObject {
    @Published var sportsPath = NavigationPath()
    
    @Published var allsportlist: [sport] = []
    @Published var favoriteslist: [sport] = []
    private var imagemanager = imageManager()
    
    static let shared = sportsManager()

    init() {
        getSports()
    }
    
    func getSports() {
        var tempID = 0
        let db = Firestore.firestore()
        let collection = db.collection("Sport")
        
        
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                var returnvalue: [sport] = [] {
                    didSet {
                        if returnvalue.count == snapshot.count {
                            DispatchQueue.main.async {
                                if !self.sportsPath.isEmpty {
//                                    self.sportsPath.removeLast(self.sportsPath.count)
                                }
                                for temp in returnvalue {
                                    if let index = self.allsportlist.firstIndex(where: { $0.documentID == temp.documentID }) {
                                        self.allsportlist[index].sportname = temp.sportname
                                        self.allsportlist[index].sportsteam = temp.sportsteam
                                        self.allsportlist[index].sportscaptains = temp.sportscaptains
                                        self.allsportlist[index].sportcoaches = temp.sportcoaches
                                        self.allsportlist[index].sportsroster = temp.sportsroster
                                        self.allsportlist[index].favoritedusers = temp.favoritedusers
                                        self.allsportlist[index].editoremails = temp.editoremails
                                        self.allsportlist[index].sportsimage = temp.sportsimage
                                        self.allsportlist[index].adminemails = temp.adminemails
                                        self.allsportlist[index].imagedata = temp.imagedata
                                        self.allsportlist[index].info = temp.info
                                        self.allsportlist[index].eventslink = temp.eventslink
                                        self.allsportlist[index].tags = temp.tags
                                        self.allsportlist[index].sportid = temp.sportid
                                        self.allsportlist[index].id = temp.id
                                    } else {
                                        self.allsportlist.append(temp)
                                    }
                                    if temp == returnvalue.last {
                                        for sport in self.allsportlist {
                                            if !returnvalue.contains(where: { $0.documentID == sport.documentID }) {
                                                self.allsportlist.removeAll(where: { $0.documentID == sport.documentID }) // Remove if not on server
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let sportname = data["sportname"] as? String ?? ""
                    let sportcoaches = data["sportscoaches"] as? [String] ?? []
                    let adminemails = data["adminemails"] as? [String] ?? []
                    let editoremails = data["editoremails"] as? [String] ?? []
                    let sportsimage = data["sportsimage"] as? String ?? ""
                    let sportsteam = data["sportsteam"] as? String ?? ""
                    let sportsroster = data["sportsroster"] as? [String] ?? []
                    let sportscaptains = data["sportscaptains"] as? [String] ?? []
                    let tags = data["tags"] as? [Int] ?? [1, 1, 1]
                    let eventslink = data["eventslink"] as? String ?? ""
                    let info = data["info"] as? String ?? ""
                    let favoritedusers = data["favoritedusers"] as? [String] ?? []
                    let documentID = document.documentID
                    let sportid = "\(sportname) \(sportsteam)"
                    let id = tempID
                    
                    self.imagemanager.getImage(fileName: sportsimage) { image in
                        
                        let sport = (sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, editoremails: editoremails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, favoritedusers: favoritedusers, eventslink: eventslink, imagedata: image, documentID: documentID, sportid: sportid, id: id))
                        tempID = tempID + 1
                        returnvalue.append(sport)
                    }
                }
                
            }
        }
    }
    
    func createSport(sport: sport, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Sport").addDocument(data: [
            "sportname": sport.sportname,
            "sportcoaches": sport.sportcoaches,
            "adminemails": sport.adminemails,
            "editoremails": sport.editoremails,
            "sportsimage": sport.sportsimage,
            "sportsteam": sport.sportsteam,
            "sportsroster": sport.sportsroster,
            "sportscaptains": sport.sportscaptains,
            "favoritedusers": sport.favoritedusers,
            "tags": sport.tags,
            "info": sport.info,
        ]) { error in
            completion(error)
        }
    }
    
    func deleteSport(sport: sport, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Sport").document(sport.documentID)
        
        ref.delete { error in
            completion(error)
        }
    }
    
    func updateSport(data: sport) {
        let db = Firestore.firestore()
        let ref = db.collection("Sport").document(data.documentID)
        ref.setData([
            "sportname": data.sportname,
            "sportscoaches": data.sportcoaches,
            "adminemails": data.adminemails,
            "editoremails": data.editoremails,
            "sportsimage": data.sportsimage,
            "sportsteam": data.sportsteam,
            "sportsroster": data.sportsroster,
            "sportscaptains": data.sportscaptains,
            "favoritedusers": data.favoritedusers,
            "eventslink": data.eventslink,
            "tags": data.tags,
            "info": data.info,
        ])
    }
}


//MARK: clubs
struct club: Identifiable, Equatable {
    var clubname:String
    var clubcaptain:[String]?
    var clubadvisor: [String]
    var clubmeetingroom:String
    var clubdescription:String
    var clubimage:String
    var clubmembercount:String
    var clubmembers:[String]
    var adminemails:[String]
    var editoremails: [String]
    var favoritedusers: [String]
    var imagedata: UIImage // NOT USED IN FIREBASE
    let documentID: String // NOT IN FIREBASE
    let id: Int // NOT IN FIREBASE
}

class clubManager: ObservableObject {
    var filteredlist: [club] = []
    @Published var allclublist: [club] = []
    var favoriteclubs = FavoriteClubs() // make favorite clubs
    private var imagemanager = imageManager()
    @Published var favoriteslist: [club] = []
    
    static let shared = clubManager()
    
    init() {
        getClubs()
        getFavorites { favorites in
            self.favoriteslist = favorites
        }
    }
    
    func getClubs() {
        
        let db = Firestore.firestore()
        let collection = db.collection("Clubs")
        
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                var returnvalue: [club] = [] {
                    didSet {
                        if returnvalue.count == snapshot.count {
                            DispatchQueue.main.async {
                                for temp in returnvalue {
                                    if let index = self.allclublist.firstIndex(where: { $0.documentID == temp.documentID }) {
                                        self.allclublist[index].clubname = temp.clubname
                                        self.allclublist[index].clubcaptain = temp.clubcaptain
                                        self.allclublist[index].clubmembers = temp.clubmembers
                                        self.allclublist[index].clubadvisor = temp.clubadvisor
                                        self.allclublist[index].favoritedusers = temp.favoritedusers
                                        self.allclublist[index].clubimage = temp.clubimage
                                        self.allclublist[index].clubmeetingroom = temp.clubmeetingroom
                                        self.allclublist[index].adminemails = temp.adminemails
                                        self.allclublist[index].clubdescription = temp.clubdescription
                                        self.allclublist[index].clubmembercount = temp.clubmembercount
                                        self.allclublist[index].imagedata = temp.imagedata
                                        self.allclublist[index].editoremails = temp.editoremails
                                    } else {
                                        self.allclublist.append(temp)
                                    }
                                    if temp == returnvalue.last {
                                        for sport in self.allclublist {
                                            if !returnvalue.contains(where: { $0.documentID == sport.documentID }) {
                                                self.allclublist.removeAll(where: { $0.documentID == sport.documentID }) // Remove if not on server
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                var id = 0
                for document in snapshot.documents {
                    let data = document.data()
                    let clubname = data["clubname"] as? String ?? "Unnamed club"
                    let clubcapation = data["clubcaptain"] as! [String]?
                    let clubadvisor = data["clubadvisor"] as? [String] ?? []
                    let clubmeetingroom = data["clubmeetingroom"] as? String ?? ""
                    let clubdescription = data["clubdescription"] as? String ?? ""
                    let clubimage = data["clubimage"] as? String ?? ""
                    let clubmembers = data["clubmembers"] as? [String] ?? []
                    let clubmembercount = String(clubmembers.count + (clubcapation?.count ?? 0))
                    let editoremails = data["editoremails"] as? [String] ?? []
                    let adminemails = data["adminemails"] as? [String] ?? []
                    let favoritedusers = data["favoritedusers"] as? [String] ?? []
                    let documentID = document.documentID
                    
                    
                    self.imagemanager.getImage(fileName: clubimage) { image in
                        let club = club(clubname: clubname, clubcaptain: clubcapation, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, editoremails: editoremails, favoritedusers: favoritedusers, imagedata: image ?? UIImage(), documentID: documentID, id: id)
                        id = id + 1
                        returnvalue.append(club)
                        self.filteredlist = returnvalue.sorted { $0.clubname.lowercased() < $1.clubname.lowercased() }
                    }

                 }
                
            }
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
            "favoritedusers": club.favoritedusers,
            "clubmembers": club.clubmembers,
            "clubname": club.clubname
        ]) { error in
            completion(error)
        }
    }
    
    func deleteClub(data: club, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Clubs").document(data.documentID)
        
        ref.delete { error in
            completion(error)
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
            "favoritedusers": data.favoritedusers,
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
            templist = self.allclublist
                
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

