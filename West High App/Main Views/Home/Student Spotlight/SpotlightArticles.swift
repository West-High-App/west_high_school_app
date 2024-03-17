//
//  StudentSpotlightArticles.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import SwiftUI

struct SpotlightArticles: View {
    var currentstudentdub: studentAchievement
    
    @State var imagemanager = imageManager()
    @State var imagesdata: [UIImage] = []
    @State var hasAppeared = false
    @State var screen = ScreenSize()
    
    var body: some View {
        ScrollView{
            VStack(spacing:10){
                HStack {
                    Text(currentstudentdub.achievementtitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text("By \(currentstudentdub.articleauthor)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text(currentstudentdub.publisheddate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                VStack {
                    TabView {
                        // gets from imagedata first time it loads, then from currentstudentdub
                        ForEach(imagesdata.count > currentstudentdub.imagedata.count ? imagesdata.indices : currentstudentdub.imagedata.indices, id: \.self) { index in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    Image(uiImage: imagesdata.count > currentstudentdub.imagedata.count ? imagesdata[index] : currentstudentdub.imagedata[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: screen.screenWidth - 30, height: 250)
                                        .clipped()
                                }
                            }
                        }
                        
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                }
                .cornerRadius(30)
                .frame(width: screen.screenWidth - 30, height: 250)
                .shadow(color: .gray, radius: 4, x:2, y:3)
                .padding(.horizontal)
                Divider()
                    .frame(width: screen.screenWidth / 1.2, height: 2)
                Spacer()
                
            }
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            
            LinkTextView(text: currentstudentdub.achievementdescription)
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.bottom)
                
        }.onAppear {
            if !hasAppeared || currentstudentdub.imagedata == [] || currentstudentdub.imagedata.first == UIImage() || currentstudentdub.imagedata.first == nil { //
                guard currentstudentdub.images.first != nil else { return }
                print("IMAGE FUNCTION RUN sa")
                for image in currentstudentdub.images {
                    imagemanager.getImage(fileName: image) { uiimage in
                        if let uiimage = uiimage {
                            imagesdata.append(uiimage)
                        }
                    }
                }
                 hasAppeared = true
            } else {
            }
            
       }
    }
}

struct SpotlightArticles_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightArticles(currentstudentdub: studentAchievement(documentID: "testID" , achievementtitle: "test", achievementdescription: "building go boom boom", articleauthor: "alah akbar", publisheddate: "Sept 11, 2001", date: Date(), images: ["west-background", "west-background"], isApproved: false,writerEmail: "", imagedata: []))
    }
}
//(documentID: "testID", title: "Test", publisheddate: "Jan 5, 2023", description: "Description", newsimagename: "West Regents Logo")
//i like feet
