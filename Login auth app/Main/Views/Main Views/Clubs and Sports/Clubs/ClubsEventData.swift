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
    var date: Date?

    init(documentID: String, title: String, subtitle: String, month: String, day: String, year: String, publisheddate: String, convertDate: Bool = true) {
        self.documentID = documentID
        self.title = title
        self.subtitle = subtitle
        self.month = month
        self.day = day
        self.year = year
 
        // Set the date formatter and optionally set the formatted date from string
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        if let date = dateFormatter.date(from: "\(month) \(day), \(year) \(subtitle)") {
            let convertedDate = date.convertToTimeZone(initTimeZone: .chicago, timeZone: .current)
            
            if convertDate {
                self.date = convertedDate
            } else {
                self.date = date
            }
        }
    }
    
    init(title: String, date: Date) {
        self.documentID = UUID().uuidString
        self.title = title
        self.subtitle = date.twelveHourTime
        self.month = date.monthName
        self.day = "\(date.dateComponent(.day))"
        self.year = "\(date.dateComponent(.year))"
        self.date = date
    }

}

class clubEventManager: ObservableObject {
    @Published var clubsEvents: [clubEvent] = []
    @Published var topthree: [clubEvent] = []
    @Published var hasInitialized: Bool = false
    @Published var eventDictionary: [String: [clubEvent]] = [:]
    private var eventSnapshotListener: ListenerRegistration?
    private var documentId = ""

    static let shared = clubEventManager()
    
    init() {
        print(self.clubsEvents)
    }
    
    
    // TODO: Rewrite flow to allow for snapshot listener
    func getClubsEvent(forClub: String) {
        if eventSnapshotListener != nil {
            self.eventSnapshotListener?.remove()
            self.eventSnapshotListener = nil
        }
        self.clubsEvents.removeAll()
        
        let db = Firestore.firestore()
        let collection = db.collection("ClubEvents")
        self.eventSnapshotListener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let clubID = data["clubID"] as? String ?? ""
                    let events = data["events"] as? [[String: String]] ?? []
                    let documentID = document.documentID
                    
                    if clubID == forClub {
                        let returnValue = events.compactMap { event in
                            let eventname = event["title"] ?? ""
                            let time = event["subtitle"] ?? ""
                            let month = event["month"] ?? ""
                            let day = event["day"] ?? ""
                            let year = event["year"] ?? ""

                            let newEvent = clubEvent(documentID: documentID, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)")
                            if let newDate = newEvent.date, newDate >= Date.yesterday {
                                return newEvent
                            } else {
                                return nil
                            }
                        }
                        
                            self.eventDictionary[forClub] = returnValue.sorted(by: {
                                ($0.date ?? Date()).compare($1.date ?? Date()) == .orderedAscending
                            })
                            self.clubsEvents = returnValue.sorted(by: {
                                ($0.date ?? Date()).compare($1.date ?? Date()) == .orderedAscending
                            })
                            print("got sports events")
                    }
                }
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
                        guard let convertedDate = clubEvent.date?.convertToTimeZone(initTimeZone: .current, timeZone: .chicago) else { return }
                        
                        var eventtoadd: [String: String] = [:]
                        let title = clubEvent.title
                        let subtitle = convertedDate.twelveHourTime
                        let month = convertedDate.monthName
                        let day = convertedDate.dateComponent(.day)
                        let year = convertedDate.dateComponent(.year)
                        let publisheddate = "\(month) \(day), \(year)"
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : "\(day)", "year" : "\(year)", "publisheddate" : publisheddate]
                        
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
