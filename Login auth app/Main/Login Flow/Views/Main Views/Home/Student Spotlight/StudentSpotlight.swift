//
//  StudentSpotLight.swift
//  West App
//
//  Created by August Andersen on 5/28/23.
//

import SwiftUI

struct StudentSpotlight: View {
    @State private var hasPermissionSpotlight = false
    var permissionsManager = permissionsDataManager()
    var userInfo = UserInfo()
    var spotlightManager = studentachievementlist()
    @StateObject var imagemanager = imageManager()
    @StateObject var achievementmanager = studentachievementlist()
    @State var hasAppeared = false
    @State var isLoading = false
    
    class ScreenSize {
        let screen: CGRect
        let screenWidth: CGFloat
        let screenHeight: CGFloat
        
        init() {
            screen = UIScreen.main.bounds
            screenWidth = screen.width
            screenHeight = screen.height
        }
    }
    // delete init under if being stupid
    
    var body: some View {

            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Student Spotlight")
                                .foregroundColor(Color.black)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .lineLimit(2)
                                .padding(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Articles")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(achievementmanager.newstitlearray, id: \.id)
                        {news in
                            NavigationLink {
                                SpotlightArticles(currentstudentdub: news)
                            } label: {
                                achievementcell(feat: news)
                                   // .background( NavigationLink("", destination: SpotlightArticles(currentstudentdub: news)).opacity(0) )
                                   // .listRowSeparator(.hidden)
                            }.buttonStyle(PlainButtonStyle())
                        }
                            .padding(.horizontal)
                    }
                }
                .onAppear {
                    if !hasAppeared {
                        permissionsManager.checkPermissions(dataType: "StudentAchievements", user: userInfo.email) { result in
                            self.hasPermissionSpotlight = result
                        }
                        hasAppeared = true
                    }
                    if  false {
                        var returnlist: [studentachievement] = []
                        
                        let dispatchGroup = DispatchGroup() // Create a Dispatch Group
                        
                        for article in achievementmanager.allstudentachievementlist {
                            var tempimages: [UIImage] = []
                            
                            for imagepath in article.images {
                                dispatchGroup.enter() // Enter the Dispatch Group before each async call
                                imagemanager.getImageFromStorage(fileName: imagepath) { uiimage in
                                    if let uiimage = uiimage {
                                        tempimages.append(uiimage)
                                    }
                                    dispatchGroup.leave() // Leave the Dispatch Group when the async call is done
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) { // This block will be executed after all async calls are done
                                returnlist.append(studentachievement(documentID: article.documentID, achievementtitle: article.achievementtitle, achievementdescription: article.achievementdescription, articleauthor: article.articleauthor, publisheddate: article.publisheddate, images: article.images, imagedata: tempimages))
                                
                                achievementmanager.newstitlearray = returnlist
                                
                                isLoading = false
                                print("DONE LOADING")
                            }
                        }
                        
                        hasAppeared = true
                    }
                }

                if isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                }
                
                
                
                
            }
        
        }
    }

class ScreenSize {
    let screen: CGRect
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    init() {
        screen = UIScreen.main.bounds
        screenWidth = screen.width
        screenHeight = screen.height
    }
}

    struct achievementcell: View{
        var feat: studentachievement
        @StateObject var imagemanager = imageManager()
        @State var imagedata: [UIImage] = []
        @State var screen = ScreenSize()
        
        var body:some View{
            VStack{
                if feat.imagedata.count > 0 {
                    Image(uiImage: feat.imagedata[0])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .frame(maxWidth: screen.screenWidth - 60)
                        .clipped()
                        .cornerRadius(9)
                } else {
                    Image(uiImage: UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .frame(maxWidth: screen.screenWidth - 60)
                        .clipped()
                        .cornerRadius(9)
                }
                VStack(alignment: .leading, spacing:2){
                    HStack{
                        Text("By " + feat.articleauthor)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Spacer()
                        Text(feat.publisheddate)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    Text(feat.achievementtitle)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Text(feat.achievementdescription)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

                }.padding(.horizontal)
                Divider()
                    .padding(.horizontal)
            }
                .padding(.vertical, 5)
                .listRowBackground(
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 7)
                        .shadow(radius: 5)
                )
        }
    }


struct StudentSpotlight_Previews: PreviewProvider {
    static var previews: some View {
        StudentSpotlight()
    }
}
