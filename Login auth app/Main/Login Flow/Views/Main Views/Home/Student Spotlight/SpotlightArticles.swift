//
//  StudentSpotlightArticles.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import SwiftUI

struct SpotlightArticles: View {
    var currentstudentdub: studentachievement
    var body: some View {
        GeometryReader { geo in
        ScrollView{
            VStack{
                VStack {
                        TabView {
                            
                            // Loop through each recipe
                            ForEach (0..<currentstudentdub.images.count) { index in
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.white)
                                    
                                    VStack(spacing: 0) {
                                        Image(currentstudentdub.images[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                    }
                                }
                                .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: .center)
                                .cornerRadius(15)
                            }
                            
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        
                    }.cornerRadius(30)
                .frame(height: 500)
                .shadow(color: .gray, radius: 8, x:2, y:3)

                    .padding()
                    Spacer()
                }
//                Image(currentstudentdub.images.first!)
//                    .resizable()
//                    .cornerRadius(20)
//                    .aspectRatio(contentMode: .fit)
//                    .padding(.horizontal,10)
//                    .padding(.top,10)
                //.padding(.leading,10)
                VStack{
                    VStack{
                        Text(currentstudentdub.achievementtitle)
                        //.padding(.leading,10)
                            .lineLimit(2)
                            .padding(.horizontal,5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                        HStack{
                            Text(currentstudentdub.publisheddate)
                                .padding(.leading)
                                .foregroundColor(Color.black)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                            Spacer()
                            Text("By " + currentstudentdub.articleauthor)
                                .foregroundColor(Color.black)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .padding(.trailing)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical,10)
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .padding(.horizontal)
                            .shadow(radius: 5, x: 3, y: 3)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        .padding(.bottom, 10)
                    }
                    
                    Text(currentstudentdub.achievementdescription)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .padding(.horizontal,30)
                        .padding(.vertical)
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .padding(.horizontal)
                            .shadow(radius: 5, x: 3, y: 3)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        .padding(.vertical, 5)
                }

            }
        }
        
    }
}

struct SpotlightArticles_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightArticles(currentstudentdub: studentachievement(documentID: "testID" , achievementtitle: "test", achievementdescription: "building go boom boom", articleauthor: "alah akbar", publisheddate: "Sept 11, 2001", images: ["west", "west"]))
    }
}
//(documentID: "testID", title: "Test", publisheddate: "Jan 5, 2023", description: "Description", newsimagename: "West Regents Logo")
//i like feet
