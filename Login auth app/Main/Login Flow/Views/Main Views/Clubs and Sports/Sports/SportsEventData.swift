//
//  SportsEventsData.swift
//  West High App
//
//  Created by August Andersen on 30/08/2023.
//
//MARK: this bitch is old we ain't gonna be using it
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
    var isSpecial: Bool// should the score be shown in the view
    var score: [Int] = [0, 0] // score of game (if applicable), home team first
    var isUpdated: Bool // should it show on past games
    
    required init(documentID: String, title: String, subtitle: String, month: String, day: String, year: String, publisheddate: String, isSpecial: Bool, score: [Int], isUpdated: Bool) {
        self.documentID = documentID
        self.title = title
        self.subtitle = subtitle
        self.month = month
        self.day = day
        self.year = year
        self.isSpecial = isSpecial
        self.score = score
        self.isUpdated = isUpdated
 
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
    @Published var pastSportsEvents: [sportEvent] = []
    @Published var topthree: [sportEvent] = []
    @Published var hasInitialized: Bool = false
    @Published var eventDictionary: [String: [sportEvent]] = [:]
    @Published var pastEventDictionary: [String: [sportEvent]] = [:]
    
    static let shared = sportEventManager() // singleton, i love you Per
     
    func getSportsEvent(forSport: String, completion: @escaping ([sportEvent]?, Error?) -> Void) {
        var returnValue: [sportEvent] = []
        var pastReturnValue: [sportEvent] = []
        
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
                    let events = data["events"] as? [[String: Any]] ?? []
                    let documentID = document.documentID
                    
                    if sportID == forSport {
                        // making in into a sportEvent
                        for event in events {
                            let eventname = event["title"] as? String ?? ""
                            let time = event["subtitle"] as? String ?? ""
                            let month = event["month"] as? String ?? ""
                            let day = event["day"] as? String ?? ""
                            let year = event["year"] as? String ?? ""
                            let isSpecial = event["isSpecial"] as? Bool ?? false
                            let score = event["score"] as? [Int] ?? []
                            let isUpdated = event["isUpdated"] as? Bool ?? false

                            let newEvent = sportEvent(documentID: documentID, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: score, isUpdated: isUpdated)
                            returnValue.append(newEvent)
                        }
                        
                        
                    }
                }
                for event in returnValue{
                    if event.date < Date.yesterday{
                        
                        // returnValue.removeAll {$0 == event}
                        pastReturnValue.append(event) // if its in the past, add it to the past list
                        
                    }
                }
                
                // past lists
                
                self.pastEventDictionary[forSport] = pastReturnValue
                self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.reversed()
                self.pastSportsEvents = pastReturnValue
                self.pastSportsEvents = self.pastSportsEvents.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                print("got past sports events")
                print(self.pastSportsEvents)
                
                
                // upcoming lists

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
                print("got upcoming sports events")
                print()
                completion(returnValue, nil)
            }
        }
    }
    
    func getPastSportsEvents(forSport: String, completion: @escaping ([sportEvent]?, Error?) -> Void) {
        var returnValue: [sportEvent] = []
        var pastReturnValue: [sportEvent] = []
        
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
                    let events = data["events"] as? [[String: Any]] ?? []
                    let documentID = document.documentID
                    
                    if sportID == forSport {
                        // making in into a sportEvent
                        for event in events {
                            let eventname = event["title"] as? String ?? ""
                            let time = event["subtitle"] as? String ?? ""
                            let month = event["month"] as? String ?? ""
                            let day = event["day"] as? String ?? ""
                            let year = event["year"] as? String ?? ""
                            let isSpecial = event["isSpecial"] as? Bool ?? false
                            let score = event["score"] as? [Int] ?? []
                            let isUpdated = event["isUpdated"] as? Bool ?? false

                            let newEvent = sportEvent(documentID: documentID, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: score, isUpdated: isUpdated)
                            returnValue.append(newEvent)
                        }
                        
                        
                    }
                }
                for event in returnValue{
                    if event.date < Date.yesterday{
                        
                        returnValue.removeAll {$0 == event}
                        pastReturnValue.append(event) // if its in the past, add it to the past list
                        
                    }
                }
                
                // past lists
                
                self.pastEventDictionary[forSport] = pastReturnValue
                self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.reversed()
                self.pastSportsEvents = pastReturnValue
                self.pastSportsEvents = self.pastSportsEvents.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                print("got past sports events")
                print(self.pastSportsEvents)
                let completionValue = self.pastSportsEvents
                
                completion(completionValue, nil)

            }
        }
    }
    
    func createParsedSportEvent(forSport: String, sportEvent: ParsedEvent) {
        var eventlist: [[String: Any]] = []
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                var docID = ""
                for doc in snapshot.documents {
                    let data = doc.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: Any]] ?? []
                    docID = doc.documentID
                    
                    if sportID == forSport {
                        eventlist = events // got up to here truw
                        eventdocumentID = docID
                        
                        let monthformat = DateFormatter()
                        monthformat.dateFormat = "MMM"
                        let month = monthformat.string(from: sportEvent.date)
                        let dayformat = DateFormatter()
                        dayformat.dateFormat = "d"
                        let day = dayformat.string(from: sportEvent.date)
                        let yearformat = DateFormatter()
                        yearformat.dateFormat = "yyyy"
                        let year = yearformat.string(from: sportEvent.date)
                        
                        // update that bitch
                        var eventtoadd: [String: Any] = [:]
                        let title = sportEvent.type
                        let subtitle = sportEvent.opponent
                        let publisheddate = "\(month) \(day), \(year)"
                        let isSpecial = false
                        let isUpdated = true
                        let score = [0, 0]
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]
                        eventlist.append(eventtoadd) // here you fat fuck
                        
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
                    var eventtoadd: [String: Any] = [:]
                    
                    let monthformat = DateFormatter()
                    monthformat.dateFormat = "MMM"
                    let month = monthformat.string(from: sportEvent.date)
                    let dayformat = DateFormatter()
                    dayformat.dateFormat = "d"
                    let day = dayformat.string(from: sportEvent.date)
                    let yearformat = DateFormatter()
                    yearformat.dateFormat = "yyyy"
                    let year = yearformat.string(from: sportEvent.date)
                    
                    // update that bitch
                    let title = sportEvent.type
                    let subtitle = sportEvent.opponent
                    let publisheddate = "\(month) \(day), \(year)"
                    let isSpecial = false
                    let isUpdated = true
                    let score = [0, 0]
                    eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]

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
    

    func createSportEvent(forSport: String, sportEvent: sportEvent) {
        var eventlist: [[String: Any]] = []
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                var docID = ""
                for doc in snapshot.documents {
                    let data = doc.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: Any]] ?? []
                    docID = doc.documentID
                    
                    if sportID == forSport {
                        eventlist = events // got up to here truw
                        eventdocumentID = docID
                        
                        // update that bitch
                        var eventtoadd: [String: Any] = [:]
                        let title = sportEvent.title
                        let subtitle = sportEvent.subtitle
                        let month = sportEvent.month
                        let day = sportEvent.day
                        let year = sportEvent.year
                        let publisheddate = "\(month) \(day), \(year)"
                        let isSpecial = sportEvent.isSpecial
                        let isUpdated = sportEvent.isUpdated
                        let score = sportEvent.score
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]
                        eventlist.append(eventtoadd) // here you fat fuck
                        
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
                    var eventtoadd: [String: Any] = [:]
                    let title = sportEvent.title
                    let subtitle = sportEvent.subtitle
                    let month = sportEvent.month
                    let day = sportEvent.day
                    let year = sportEvent.year
                    let publisheddate = "\(month) \(day), \(year)"
                    let isSpecial = sportEvent.isSpecial
                    let isUpdated = sportEvent.isUpdated
                    let score = sportEvent.score
                    eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]

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
        
        var eventtoremove: [String: Any] = [:]
        let title = sportEvent.title
        let subtitle = sportEvent.subtitle
        let month = sportEvent.month
        let day = sportEvent.day
        let year = sportEvent.year
        let publisheddate = "\(month) \(day), \(year)"
        let isSpecial = sportEvent.isSpecial
        let isUpdated = sportEvent.isUpdated
        let score = sportEvent.score
        eventtoremove = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": false] // shoudl it be false?
        print("try a remove:")
        print(eventtoremove)
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

// MARK: all files for all the sports
