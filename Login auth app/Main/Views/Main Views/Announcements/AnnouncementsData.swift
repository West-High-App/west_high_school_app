//
//  NewsTopsData.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI
import Firebase

struct Newstab: Identifiable {
    let id = UUID()
    let documentID: String // if ur basing it off my data you need to add documentID
    let title:String
    let publisheddate:String // format: Jun 15, 2023, Feb 28, 1998, etc.
    let description: String
}

class Newslist: ObservableObject {
    @Published var topfive: [Newstab] = [Newstab(documentID: "TestID", title: "Loading...", publisheddate: "Loading...", description: "Loading...")]
    @Published var newstitlearray: [Newstab] = []
    
    static let shared = Newslist()
    
    init() {
        getAnnouncements()
        newstitlearray = filterByDate()
    }
    
    
    func getAnnouncements() {
        var templist: [Newstab] = []
        let db = Firestore.firestore()
        let collection = db.collection("Announcements")
        collection.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let newsimagename = data["newsimagename"] as? String ?? ""
                    let documentID = document.documentID
                    let newstab = Newstab(documentID: documentID, title: title, publisheddate: publisheddate, description: description)
                    templist.append(newstab)  // Add the newstab to the temporary array
                }
                DispatchQueue.main.async {
                    self.topfive = Array(templist[0...])
                    self.topfive = self.topfive.sorted { first, second in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM dd, yyyy"
                        let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
                        let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
                        return firstDate < secondDate
                    }.reversed()
                }
            }
        }
    }

    func createAnnouncement(announcement: Newstab, completion: @escaping (Error?) -> Void) {
        print("Creating new announcement...")
        let db = Firestore.firestore()
        db.collection("Announcements").addDocument(data: [
            "title": announcement.title,
            "description": announcement.description,
            "publisheddate": announcement.publisheddate,
        ]) { error in
            completion(error)
            if error == nil {
                self.getAnnouncements()
            }
        }
        print("Announcement created with documentID: \(announcement.documentID)")
        self.topfive.append(announcement)
        self.filterByDate()
    }

    func deleteAnnouncement(announcement: Newstab, completion: @escaping (Error?) -> Void) { //
        print("Deleting announcement with documentID: \(announcement.documentID)...")
        let db = Firestore.firestore()
        let eventRef = db.collection("Announcements").document(announcement.documentID)
        
        eventRef.delete { error in
            completion(error)
            if error == nil {
                self.getAnnouncements()
            }
        }
        print("Announcement deleted")
    }
    
    func filterByDate() -> [Newstab]{
        self.getAnnouncements()
        self.newstitlearray = self.topfive.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM, d yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate < secondDate
        }.reversed()
        return(newstitlearray)
    }
    }
