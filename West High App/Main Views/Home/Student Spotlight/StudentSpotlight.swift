//
//  StudentSpotLight.swift
//  West High App
//

import SwiftUI

struct StudentSpotlight: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var spotlightManager = studentachievementlist.shared
    @StateObject var imagemanager = imageManager()
    var spotlightarticles: [studentAchievement] {
        spotlightManager.allstudentachievementlist
    }
    @State var hasAppeared = false
    @State var newstitlearray: [studentAchievement] = []
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
                    LazyVStack {
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
                        ForEach(spotlightarticles, id: \.id)
                        {news in
                            if news.isApproved { // checking if article is approved
                            NavigationLink {
                                SpotlightArticles(currentstudentdub: news)
                            } label: {
                                achievementcell(feat: news)
                                // .background( NavigationLink("", destination: SpotlightArticles(currentstudentdub: news)).opacity(0) )
                                // .listRowSeparator(.hidden)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        }
                            .padding(.horizontal)
                        if !spotlightManager.allstudentachievementlist.isEmpty && !spotlightManager.allDocsLoaded {
                            ProgressView()
                                .padding()
                                .onAppear {
                                    spotlightManager.getMoreAchievements()
                                }
                        }
                    }
                }
                .onAppear {
                    if  !hasAppeared { // !hasAppeared
                        print("LOADING....")
                        
                        var returnlist: [studentAchievement] = []
                        
                        let dispatchGroup = DispatchGroup() // Create a Dispatch Group
                        
                        for article in spotlightarticles {
                            var tempimages: [UIImage] = []
                            
                            for imagepath in article.images {
                                dispatchGroup.enter() // Enter the Dispatch Group before each async call
                                imagemanager.getImage(fileName: imagepath) { uiimage in
                                    if let uiimage = uiimage {
                                        tempimages.append(uiimage)
                                        print("FOUND SPOTLIGHT IMAGE")
                                    }
                                    dispatchGroup.leave() // Leave the Dispatch Group when the async call is done
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) { // This block will be executed after all async calls are done
                                returnlist.append(studentAchievement(documentID: article.documentID, achievementtitle: article.achievementtitle, achievementdescription: article.achievementdescription, articleauthor: article.articleauthor, publisheddate: article.publisheddate, date: article.date, images: article.images, isApproved: article.isApproved, writerEmail: article.writerEmail, imagedata: tempimages))
                                
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
        var feat: studentAchievement
        @StateObject var imagemanager = imageManager()
        @State var imagedata = UIImage()
        @State var screen = ScreenSize()
        @State var hasAppeared = false
        
        var body:some View{
            VStack{
                Image(uiImage: imagedata)
                    .resizable()
                    .padding(.bottom, 2)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.screenWidth - 20, height: 250)
                    .clipped()
                    .cornerRadius(30)
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
            }.onAppear {
                if !hasAppeared || feat.imagedata == [] || feat.imagedata.first == UIImage() || feat.imagedata.first == nil { //  
                     guard let image = feat.images.first else { return }
                    print("IMAGE FUNCTION RUN ss")
                     imagemanager.getImage(fileName: image) { uiimage in
                          if let uiimage = uiimage {
                               imagedata = uiimage
                          }
                     }
                     hasAppeared = true
                } else {
                }
                
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
