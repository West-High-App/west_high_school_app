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
    let documentID: String
    let title:String
    let publisheddate:String // format: Jun 15, 2023, Feb 28, 1998, etc.
    let description: LocalizedStringKey
    let newsimagename: String
}

class Newslist: ObservableObject {
    
    @Published var topfive: [Newstab] = [Newstab(documentID: "testID", title: "Test", publisheddate: "Jan 5, 2023", description: "Description", newsimagename: "West Regents Logo")]
    @Published var newstitlearray: [Newstab] = []

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
                    let description = data["description"] as? LocalizedStringKey ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let newsimagename = data["newsimagename"] as? String ?? ""
                    let documentID = document.documentID
                    
                    let newstab = Newstab(documentID: documentID, title: title, publisheddate: publisheddate, description: description, newsimagename: newsimagename)
                    templist.append(newstab)  // Add the newstab to the temporary array
                }
                
                print("Announcement documents list:")
                self.topfive = Array(templist[0...])
                self.topfive = self.topfive.sorted { first, second in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM, d yyyy"
                    let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
                    let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
                    return firstDate < secondDate
                }.reversed()
                print("work plz")
                print(self.topfive)
                print("Documents retrieved.")
            }
        }
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
