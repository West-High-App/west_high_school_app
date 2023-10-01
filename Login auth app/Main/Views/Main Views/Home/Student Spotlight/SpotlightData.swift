//
//  StudentSpotLightData.swift
//  West App
//
//  Created by Aiden Lee on 5/29/23.
//

import SwiftUI
import Firebase

struct studentachievement: Identifiable, Equatable{
    let id = UUID()
    let documentID: String
    var achievementtitle:String
    var achievementdescription:String // localizedstringkey??
    var articleauthor:String
    var publisheddate:String
    var images:[String]
    var isApproved: Bool
    var imagedata: [UIImage] // , imagedata: []
 }

extension Array<studentachievement> {
    func sortedByDate() -> Self {
        return self.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate > secondDate
        }
    }
}

class studentachievementlist: ObservableObject{
    
    static let shared = studentachievementlist()
    
    @Published private var allstudentachievementlistUnsorted: [studentachievement] = []
    var allstudentachievementlist: [studentachievement] {
        allstudentachievementlistUnsorted.sortedByDate()
    }
    @Published var newstitlearray: [studentachievement] = []
    @Published var hasLoaded = false

    @StateObject var imagemanager = imageManager()
    @ObservedObject var loading = Loading()
    
    init() {
        getAchievements()
    }
    
    func getAchievements() {
        print("LOADING ACHIEVMENTS LIST")
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                var templist: [studentachievement] = [] {
                    didSet {
                        if templist.count == snapshot.count {
                            DispatchQueue.main.async {
                                for temp in templist {
                                    if let index = self.allstudentachievementlistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                                        self.allstudentachievementlistUnsorted[index].achievementdescription = temp.achievementdescription
                                        self.allstudentachievementlistUnsorted[index].achievementtitle = temp.achievementtitle
                                        self.allstudentachievementlistUnsorted[index].articleauthor = temp.articleauthor
                                        self.allstudentachievementlistUnsorted[index].images = temp.images
                                        self.allstudentachievementlistUnsorted[index].publisheddate = temp.publisheddate
                                        self.allstudentachievementlistUnsorted[index].isApproved = temp.isApproved
                                        self.allstudentachievementlistUnsorted[index].imagedata = temp.imagedata
                                    } else {
                                        self.allstudentachievementlistUnsorted.append(temp)
                                    }
                                    if temp == templist.last {
                                        for studentachievement in self.allstudentachievementlistUnsorted {
                                            if !templist.contains(where: { $0.documentID == studentachievement.documentID }) {
                                                self.allstudentachievementlistUnsorted.removeAll(where: { $0.documentID == studentachievement.documentID }) // Remove if not on server
                                            }
                                        }
                                    }
                                }
                                self.loading.hasLoaded = true
                                print(self.allstudentachievementlistUnsorted.count)
                                self.hasLoaded = true
                            }
                        }
                    }
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let achievementtitle = data["achievementtitle"] as? String ?? ""
                    let achievementdescription = data["achievementdescription"] as? String ?? ""
                    let articleauthor = data["articleauthor"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let images = data["images"] as? [String] ?? []
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    
                    var imagedata: [UIImage] = []
                    for file in images {
                        let _ = imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                        }
                    }
                    
                    let achievement = studentachievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, images: images, isApproved: isApproved, imagedata: imagedata)
                    templist.append(achievement)
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
            "publisheddate": achievement.publisheddate,
            "isApproved": achievement.isApproved
        ]) { error in
            completion(error)
        }
        print("Article creating with ID: \(achievement.documentID)")
        
    }
    
    func deleteAchievment(achievement: studentachievement, completion: @escaping (Error?) -> Void) {
        print("Deleting article with documentID: \(achievement.documentID)...")
        let db = Firestore.firestore()
        let ref = db.collection("StudentAchievements").document(achievement.documentID)
        ref.delete { error in
            completion(error)
        }
        print("Achievement deleted")
    }
    
    
    func getImageData(articlelist: [studentachievement], completion: @escaping ([studentachievement]) -> Void) {
        var spotlightarticles = articlelist
        var returnlist: [studentachievement] = []
        
        let dispatchGroup = DispatchGroup()
        
        for article in spotlightarticles {
            var tempimages: [UIImage] = []
            
            for imagepath in article.images {
                dispatchGroup.enter()
                imagemanager.getImage(fileName: imagepath) { uiimage in
                    if let uiimage = uiimage {
                        tempimages.append(uiimage)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                let updatedArticle = studentachievement(
                    documentID: article.documentID,
                    achievementtitle: article.achievementtitle,
                    achievementdescription: article.achievementdescription,
                    articleauthor: article.articleauthor,
                    publisheddate: article.publisheddate,
                    images: article.images,
                    isApproved: article.isApproved,
                    imagedata: tempimages
                )
                returnlist.append(updatedArticle)
                spotlightarticles = returnlist
                completion(spotlightarticles)
            }
        }
    }
}
