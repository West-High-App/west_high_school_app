//
//  NewsTopsData.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI
import Firebase

struct Newstab: Identifiable, Equatable {
    let id = UUID()
    let documentID: String // if ur basing it off my data you need to add documentID
    var title:String
    var publisheddate:String // format: Jun 15, 2023, Feb 28, 1998, etc.
    var description: String
}

extension Array<Newstab> {
    func sortedByDate() -> Self {
        self.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate > secondDate
        }
    }
}

class Newslist: ObservableObject {
    @Published private var topfiveUnsorted: [Newstab] = [Newstab(documentID: "TestID", title: "Loading...", publisheddate: "Loading...", description: "Loading...")]
    var topfive: [Newstab] {
        topfiveUnsorted.sortedByDate()
    }
    private var lastDocument: DocumentSnapshot?
    private let limit = 20
    @Published private(set) var allDocsLoaded = false
    
    static let shared = Newslist()
    
    init() {
        connectAnnouncements()
    }
    
    private func handleFirestoreData(_ templist: [Newstab]) {
        DispatchQueue.main.async {
            self.topfiveUnsorted.removeAll(where: { $0.documentID == "TestID" })
            for temp in templist {
                if let index = self.topfiveUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                    self.topfiveUnsorted[index].publisheddate = temp.publisheddate
                    self.topfiveUnsorted[index].title = temp.title
                    self.topfiveUnsorted[index].description = temp.description
                } else {
                    self.topfiveUnsorted.append(temp)
                }
                if temp == templist.last {
                    
                    if let docId = self.lastDocument?.documentID, let endIndex = self.topfiveUnsorted.firstIndex(where: { $0.documentID == docId }) {
                        let startIndex = endIndex-templist.count
                        
                        for (index, element) in self.topfiveUnsorted.enumerated() {
                            if startIndex < index, index <= endIndex, !templist.contains(where: { $0.documentID == element.documentID }) {
                                self.topfiveUnsorted.removeAll(where: { $0.documentID == element.documentID }) // Remove if not on server
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getMoreAnnouncements() {
        guard let lastDocument else { return }
        
        let db = Firestore.firestore()
        let collection = db.collection("Announcements")
        collection
            .order(by: "publisheddate", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: self.limit)
            .getDocuments { snapshot, error in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                if let snapshot = snapshot {
                    
                    self.lastDocument = snapshot.documents.last
                    let templist: [Newstab] = snapshot.documents.map { document in
                        let data = document.data()
                        let title = data["title"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let publisheddate = data["publisheddate"] as? String ?? ""
                        let newsimagename = data["newsimagename"] as? String ?? ""
                        let documentID = document.documentID
                        let newstab = Newstab(documentID: documentID, title: title, publisheddate: publisheddate, description: description)
                        return newstab  // Add the newstab to the temporary array
                    }
                    self.handleFirestoreData(templist)
                    if snapshot.documents.count < self.limit {
                        self.allDocsLoaded = true
                    }
                }
            }
    }
    
    func connectAnnouncements() {
        let db = Firestore.firestore()
        let collection = db.collection("Announcements")
        collection
            .order(by: "publisheddate", descending: true)
            .limit(to: self.limit)
            .addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                
                if self.lastDocument == nil {
                    self.lastDocument = snapshot.documents.last
                }
                let templist: [Newstab] = snapshot.documents.map { document in
                    let data = document.data()
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let newsimagename = data["newsimagename"] as? String ?? ""
                    let documentID = document.documentID
                    let newstab = Newstab(documentID: documentID, title: title, publisheddate: publisheddate, description: description)
                    return newstab  // Add the newstab to the temporary array
                }
                self.handleFirestoreData(templist)
                if snapshot.documents.count < self.limit {
                    self.allDocsLoaded = true
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
        }
        print("Announcement created with documentID: \(announcement.documentID)")
    }

    func deleteAnnouncement(announcement: Newstab, completion: @escaping (Error?) -> Void) { //
        print("Deleting announcement with documentID: \(announcement.documentID)...")
        let db = Firestore.firestore()
        let eventRef = db.collection("Announcements").document(announcement.documentID)
        
        eventRef.delete { error in
            completion(error)
        }
        print("Announcement deleted")
    }
}
