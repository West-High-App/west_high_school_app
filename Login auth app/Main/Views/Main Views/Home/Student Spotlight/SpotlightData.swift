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
    let achievementtitle:String
    let achievementdescription:String // localizedstringkey??
    let articleauthor:String
    let publisheddate:String
    let images:[String]
    var isApproved: Bool
    var imagedata: [UIImage] // , imagedata: []
 }
class studentachievementlist: ObservableObject{
    
    static let shared = studentachievementlist()
    
    @Published var allstudentachievementlist: [studentachievement] = []
    @Published var newstitlearray: [studentachievement] = []
    @Published var hasLoaded = false

    @StateObject var imagemanager = imageManager()
    @ObservedObject var loading = Loading()

    
    init() {
        getAchievements { list, error in
            print("LOADING ACHIEVMENTS LIST")
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let list = list {
                self.allstudentachievementlist = list
                self.newstitlearray = self.allstudentachievementlist.sorted { first, second in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
                    let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
                    return firstDate < secondDate
                }.reversed()
            }
            self.loading.hasLoaded = true
            print(self.allstudentachievementlist.count)
            self.hasLoaded = true
        }
    }
    
    func getAchievements(completion: @escaping ([studentachievement]?, Error?) -> Void) {
        var templist: [studentachievement] = []
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
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
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    
                    let achievement = studentachievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, images: images, isApproved: isApproved, imagedata: [])
                    templist.append(achievement)
                }
                
                DispatchQueue.main.async {
                    self.allstudentachievementlist = templist
                    completion(templist, nil)
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
            if error == nil {
                self.getAchievements {_, _ in}
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
                self.getAchievements{_, _ in}
            }
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
