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
            VStack{
                HStack {
                    Text(currentstudentdub.achievementtitle)
                        .foregroundColor(Color.black)
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .minimumScaleFactor(0.3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text(currentstudentdub.articleauthor)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text(currentstudentdub.publisheddate)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.horizontal)
                    Spacer()
                }


                VStack {
                    TabView {
                        
                        // Loop through each recipe
                        ForEach(imagesdata.indices, id: \.self) { index in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    Image(uiImage: imagesdata[index])
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
                    
                }.cornerRadius(30)
                    .frame(width: screen.screenWidth - 30, height: 250)
                    .shadow(color: .gray, radius: 8, x:2, y:3)
                
                    .padding(.horizontal)
                Spacer()
            }.onAppear {
            }

            LinkTextView(text: currentstudentdub.achievementdescription)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 5)
                    .background(Rectangle()
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 5, x: 3, y: 3)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
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
        SpotlightArticles(currentstudentdub: studentAchievement(documentID: "testID" , achievementtitle: "test", achievementdescription: "building go boom boom", articleauthor: "alah akbar", publisheddate: "Sept 11, 2001", date: Date(), images: ["west", "west"], isApproved: false,writerEmail: "", imagedata: []))
    }
}
//(documentID: "testID", title: "Test", publisheddate: "Jan 5, 2023", description: "Description", newsimagename: "West Regents Logo")
//i like feet
