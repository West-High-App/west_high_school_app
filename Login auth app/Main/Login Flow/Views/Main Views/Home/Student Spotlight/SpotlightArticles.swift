//
//  StudentSpotlightArticles.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import SwiftUI

struct SpotlightArticles: View {
    var currentstudentdub: studentachievement
    
    @State var imagemanager = imageManager()
    @State var spotlightmanager = studentachievementlist()
    @State var imagesdata: [UIImage] = []
    @State var hasAppeared = false
    
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
                        ForEach(currentstudentdub.imagedata.indices, id: \.self) { index in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    Image(uiImage: currentstudentdub.imagedata[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                }
                            }
                        }
                        
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                }.cornerRadius(30)
                    .frame(height: 500)
                    .shadow(color: .gray, radius: 8, x:2, y:3)
                
                    .padding(.horizontal)
                Spacer()
            }.onAppear {
            }

            Text(currentstudentdub.achievementdescription)
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
                
            
        }
    }
}

struct SpotlightArticles_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightArticles(currentstudentdub: studentachievement(documentID: "testID" , achievementtitle: "test", achievementdescription: "building go boom boom", articleauthor: "alah akbar", publisheddate: "Sept 11, 2001", images: ["west", "west"], imagedata: []))
    }
}
//(documentID: "testID", title: "Test", publisheddate: "Jan 5, 2023", description: "Description", newsimagename: "West Regents Logo")
//i like feet
