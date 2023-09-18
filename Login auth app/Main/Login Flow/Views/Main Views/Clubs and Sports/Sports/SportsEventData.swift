//
//  SportsEventsData.swift
//  West High App
//
//  Created by August Andersen on 30/08/2023.
//

import Foundation
import SwiftUI
import Firebase

class sportEvent: NSObject, Identifiable {
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


class sportEventManager: ObservableObject {
    @Published var sportsEvents: [sportEvent] = []
    @Published var topthree: [sportEvent] = []
    @Published var hasInitialized: Bool = false
    @Published var eventDictionary: [String: [sportEvent]] = [:]
    
    static let shared = sportEventManager()
    
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
                            let eventname = event["title"] ?? ""
                            let time = event["subtitle"] ?? ""
                            let month = event["month"] ?? ""
                            let day = event["day"] ?? ""
                            let year = event["year"] ?? ""

                            let newEvent = sportEvent(documentID: documentID, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)")
                            returnValue.append(newEvent)
                        }
                        
                        
                    }
                }
                for event in returnValue{
                    if event.date < Date.yesterday{
                        self.deleteSportEventNews(forSport: forSport, sportEvent: event)
                    }
                }

                self.eventDictionary[forSport] = returnValue
                self.eventDictionary[forSport] = self.eventDictionary[forSport]?.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                self.eventDictionary[forSport] = self.eventDictionary[forSport]?.reversed()
                self.sportsEvents = returnValue
                self.sportsEvents = self.sportsEvents.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                self.sportsEvents = self.sportsEvents.reversed()
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
                        let month = sportEvent.month
                        let day = sportEvent.day
                        let year = sportEvent.year
                        let publisheddate = "\(month) \(day), \(year)"
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate]
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
                    let month = sportEvent.month
                    let day = sportEvent.day
                    let year = sportEvent.year
                    let publisheddate = "\(month) \(day), \(year)"
                    eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate]
                    
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
        let month = sportEvent.month
        let day = sportEvent.day
        let year = sportEvent.year
        let publisheddate = "\(month) \(day), \(year)"
        eventtoremove = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate]
        
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
