//
//  ClubsEventData.swift
//  West High App
//
//  Created by August Andersen on 05/09/2023.
//

import SwiftUI
import Firebase
import Foundation

struct clubEvent: Identifiable {
    let id = UUID()
    let documentID: String
    let title: String
    let subtitle: String
    let date: String
}

class clubEventManager: ObservableObject {
    @Published var clubsEvents = [clubEvent(documentID: "NAN", title: "Loading...", subtitle: "Loading...", date: "Jan 1 2023")]
    @Published var topthree: [clubEvent] = []
    @Published var hasInitialized: Bool = false
    
    init() {
        print(self.clubsEvents)
    }
    
    func getClubsEvent(forClub: String, completion: @escaping ([clubEvent]?, Error?) -> Void) {
        var returnValue: [clubEvent] = []
        
        let db = Firestore.firestore()
        let collection = db.collection("ClubEvents")
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let clubID = data["clubID"] as? String ?? ""
                    let events = data["events"] as? [[String: String]] ?? []
                    let documentID = document.documentID
                    
                    if clubID == forClub {
                        
                        for event in events {
                            let title = event["title"]!
                            let subtitle = event["subtitle"]!
                            let date = event["date"]!
                            
                            let newEvent = clubEvent(documentID: documentID, title: title, subtitle: subtitle, date: date)
                            returnValue.append(newEvent)
                        }
                    }
                }
                completion(returnValue, nil)
            }
        }
    }
    
    func createClubEvent(forClub: String, clubEvent: clubEvent) {
        var eventlist: [[String: String]] = []
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("ClubEvents")
        
        collection.getDocuments { snapshot, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    let clubID = data["clubID"] as? String ?? ""
                    let events = data["events"] as? [[String: String]] ?? []
                    let docID = doc.documentID
                    
                    if clubID == forClub {
                        eventlist = events
                        eventdocumentID = docID
                        
                        var eventtoadd: [String: String] = [:]
                        let title = clubEvent.title
                        let subtitle = clubEvent.subtitle
                        let date = clubEvent.date
                        eventtoadd = ["title": title, "subtitle": subtitle, "date": date]
                        
                        eventlist.append(eventtoadd)
                        
                        collection.document(eventdocumentID).updateData([
                            "events": eventlist
                        ]) { error in
                            if let error = error {
                                print("Error updating document \(error)")
                            } else {
                                print("Document updated")
                            }
                        }
                    }
                }
                var Bool = true
                for _ in eventlist {
                    Bool = false
                }
                if Bool {
                    var eventtoadd: [String: String] = [:]
                    let title = clubEvent.title
                    let subtitle = clubEvent.subtitle
                    let date = clubEvent.date
                    eventtoadd = ["title": title, "subtitle": subtitle, "date": date]
                    
                    collection.addDocument(data:[
                        "clubID": forClub,
                        "events": [eventtoadd]
                    ]) { error in
                        if let error = error {
                            print("Error adding event: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func deleteClubEvent(forClub: String, clubEvent: clubEvent) {
        let db = Firestore.firestore()
        let ref = db.collection("ClubEvents").document(clubEvent.documentID)
        
        var eventtoremove: [String: String] = [:]
        let title = clubEvent.title
        let subtitle = clubEvent.subtitle
        let date = clubEvent.date
        eventtoremove = ["title": title, "subtitle": subtitle, "date": date]
        
        ref.updateData([
            "events": FieldValue.arrayRemove([eventtoremove])
        ]) {
            error in
            if let error = error {
                print("Error deleting club event: \(error.localizedDescription)")
            } else {
                print("deleted club event")
            }
        }
        
        
    }
    
    
    func getDatePart(event: sportEvent, part: String) -> String {
        let dateList = event.date.components(separatedBy: " ")
        if dateList.count == 3 {
            if part == "month" {
                return dateList[0]
            }
            if part == "day" {
                return dateList[1]
            }
            if part == "year" {
                return dateList[2]
            }
        }
        return ""
    }
    
    
    
}
