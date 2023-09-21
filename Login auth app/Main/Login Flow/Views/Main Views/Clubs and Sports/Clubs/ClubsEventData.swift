//
//  ClubsEventData.swift
//  West High App
//
//  Created by August Andersen on 05/09/2023.
//

import SwiftUI
import Firebase
import Foundation

class clubEvent: NSObject, Identifiable {
    let id = UUID()
    let documentID: String
    let title: String
    let subtitle: String
    let month: String
    let day: String
    let year: String
    var date: Date = Date()

    required init(documentID: String, title: String, subtitle: String, month: String, day: String, year: String, publisheddate: String) {
        self.documentID = documentID
        self.title = title
        self.subtitle = subtitle
        self.month = month
        self.day = day
        self.year = year
 
        // Set the date formatter and optionally set the formatted date from string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let date = dateFormatter.date(from: publisheddate) {
            self.date = date
        }
    }

}

class clubEventManager: ObservableObject {
    @Published var clubsEvents: [clubEvent] = []
    @Published var topthree: [clubEvent] = []
    @Published var hasInitialized: Bool = false
    @Published var eventDictionary: [String: [clubEvent]] = [:]

    static let shared = clubEventManager()
    
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
                            let eventname = event["title"] ?? ""
                            let time = event["subtitle"] ?? ""
                            let month = event["month"] ?? ""
                            let day = event["day"] ?? ""
                            let year = event["year"] ?? ""

                            let newEvent = clubEvent(documentID: documentID, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)")
                            returnValue.append(newEvent)
                        }
                    }
                }
                for event in returnValue{
                    if event.date < Date.yesterday{
                    }
                }
                self.eventDictionary[forClub] = returnValue
                self.eventDictionary[forClub] = self.eventDictionary[forClub]?.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                print("Updated list: \(self.eventDictionary[forClub]?.reversed())")
                self.eventDictionary[forClub] = self.eventDictionary[forClub]?.reversed()
                self.clubsEvents = self.clubsEvents.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                self.clubsEvents = self.clubsEvents.reversed()
                print("got sports events")
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
                        let month = clubEvent.month
                        let day = clubEvent.day
                        let year = clubEvent.year
                        let publisheddate = "\(month) \(day), \(year)"
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate]
                        
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
                    let month = clubEvent.month
                    let day = clubEvent.day
                    let year = clubEvent.year
                    let publisheddate = "\(month) \(day), \(year)"
                    eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate]
                    
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
        let month = clubEvent.month
        let day = clubEvent.day
        let year = clubEvent.year
        let publisheddate = "\(month) \(day), \(year)"
        eventtoremove = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate]
        
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
    
    
//    func getDatePart(event: sportEvent, part: String) -> String {
//        let dateList = event.date.components(separatedBy: " ")
//        if dateList.count == 3 {
//            if part == "month" {
//                return dateList[0]
//            }
//            if part == "day" {
//                return dateList[1]
//            }
//            if part == "year" {
//                return dateList[2]
//            }
//        }
//        return ""
//    }
    
    
    
}
