//
//  SportsEventsData.swift
//  West High App
//
//  Created by August Andersen on 30/08/2023.
//

import Foundation
import SwiftUI
import Firebase

struct sportEvent: Identifiable {
    let id = UUID()
    let documentID: String
    let title: String
    let subtitle: String
    let date: String // format: Jun 17 2023
}


class sportEventManager: ObservableObject {
    @Published var sportsEvents = [sportEvent(documentID: "NAN", title: "Placeholder data", subtitle: "This one is made harcoded in teh app", date: "Aug 30 2023")]
    @Published var topthree: [sportEvent] = []
    @Published var hasInitialized: Bool = false
    
    func getSportsEvent(forSport: String, completion: @escaping ([sportEvent]?, Error?) -> Void) {
        var returnValue: [sportEvent] = []
        
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: String]] ?? []
                    let documentID = document.documentID
                    
                    if sportID == forSport {
                        // making in into a sportEvent
                        for event in events {
                            let title = event["title"]!
                            let subtitle = event["subtitle"]!
                            let date = event["date"]!
                            
                            let newEvent = sportEvent(documentID: documentID, title: title, subtitle: subtitle, date: date)
                            returnValue.append(newEvent)
                        }
                        
                        
                    }
                }
                
                completion(returnValue, nil)
            }
        }
    }

    func createSportEvent(forSport: String, sportEvent: sportEvent) {
        var eventlist: [[String: String]] = []
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: String]] ?? []
                    let docID = doc.documentID
                    
                    if sportID == forSport {
                        eventlist = events // got up to here truw
                        eventdocumentID = docID
                        
                        // update that bitch
                        var eventtoadd: [String: String] = [:]
                        let title = sportEvent.title
                        let subtitle = sportEvent.subtitle
                        let date = sportEvent.date
                        eventtoadd = ["title": title, "subtitle": subtitle, "date": date]
                        eventlist.append(eventtoadd)
                        
                        collection.document(eventdocumentID).updateData([
                            "events": eventlist
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
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
                    let title = sportEvent.title
                    let subtitle = sportEvent.subtitle
                    let date = sportEvent.date
                    eventtoadd = ["title": title, "subtitle": subtitle, "date": date]
                    
                    collection.addDocument(data: [
                        "sportID": forSport,
                        "events": [eventtoadd]
                    ]) { error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func deleteSportEventNews(forSport: String, sportEvent: sportEvent) {
        print("deleting event...")
        let db = Firestore.firestore()
        let ref = db.collection("SportEvents").document(sportEvent.documentID) //sportEvent.documentID
        
        var eventtoremove: [String: String] = [:]
        let title = sportEvent.title
        let subtitle = sportEvent.subtitle
        let date = sportEvent.date
        eventtoremove = ["title": title, "subtitle": subtitle, "date": date]
        
        ref.updateData([
            "events": FieldValue.arrayRemove([eventtoremove])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("deleted that shit")
            }
        }
    }
    
    func getDatePart(event: sportEvent, part: String) -> String {
        let dateList = event.date.components(separatedBy: " ")
        if part == "month" {
            return dateList[0]
        }
        if part == "day" {
            return dateList[1]
        }
        if part == "year" {
            return dateList[2]
        }
        return ""
    }
}
