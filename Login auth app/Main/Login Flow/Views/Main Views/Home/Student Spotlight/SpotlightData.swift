//
//  StudentSpotLightData.swift
//  West App
//
//  Created by Aiden Lee on 5/29/23.
//

import SwiftUI
import Firebase

struct studentachievement: Identifiable{
    let id = UUID()
    let documentID: String
    let achievementtitle:String
    let achievementdescription:String // localizedstringkey??
    let articleauthor:String
    let publisheddate:String
    let images:[String]
}
class studentachievementlist: ObservableObject{
    
    @Published var allstudentachievementlist: [studentachievement] = []
    @Published var newstitlearray: [studentachievement] = []
    @Published var firstcurrentevent = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [""])
    @Published var secondcurrentevent = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [""])
    @Published var thirdcurrentevent = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [""])

    
    init() {
        getAchievements()
    }
    
    func getAchievements() {
        var templist: [studentachievement] = []
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let achievementtitle = data["achievementtitle"] as? String ?? ""
                    let achievementdescription = data["achievementdescription"] as? String ?? ""
                    let articleauthor = data["articleauthor"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let images = data["images"] as? [String] ?? []
                    let documentID = document.documentID
                    
                    let achievement = studentachievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, images: images)
                    templist.append(achievement)
                }
                
                DispatchQueue.main.async {
                                self.allstudentachievementlist = templist
                                self.newstitlearray = self.allstudentachievementlist.sorted { first, second in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM d, yyyy"
                                    let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
                                    let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
                                    return firstDate < secondDate
                                }.reversed()
                                if let firstEvent = self.newstitlearray.first {
                                self.firstcurrentevent = firstEvent
                                }
                                if self.newstitlearray.count > 1 {
                                self.secondcurrentevent =   self.newstitlearray[1]
                                }
                                if self.allstudentachievementlist.count > 2 {
                                self.thirdcurrentevent = self.newstitlearray[2]
                        }
                    
                            }
            }
        }
    }
    
    func createAchievement(achievement: studentachievement, completion: @escaping (Error?) -> Void) {
        print("Creating new student spotlight...")
        let db = Firestore.firestore()
        db.collection("StudentAchievements").addDocument(data: [
            "achievementtitle": achievement.achievementtitle,
            "achievementdescription": achievement.achievementdescription,
            "articleauthor": achievement.articleauthor,
            "images": achievement.images,
            "publisheddate": achievement.publisheddate
        ]) { error in
            completion(error)
            if error == nil {
                self.getAchievements()
            }
        }
        print("Article creating with ID: \(achievement.documentID)")
    }
    
    func deleteAchievment(achievement: studentachievement, completion: @escaping (Error?) -> Void) {
        print("Deleting article with documentID: \(achievement.documentID)...")
        let db = Firestore.firestore()
        let ref = db.collection("StudentAchievements").document(achievement.documentID)
        ref.delete { error in
            completion(error)
            if error == nil {
                self.getAchievements()
            }
        }
        print("Achievement deleted")
    }

}
