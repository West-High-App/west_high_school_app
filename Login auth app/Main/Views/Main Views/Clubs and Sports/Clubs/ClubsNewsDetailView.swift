//
//  ClubsNewDetailView.swift
//  West App
//
//  Created by Aiden Lee on 7/7/23.
//

import SwiftUI

struct ClubsNewsDetailView: View {
    var currentclubnews: clubNews
    @State var screen = ScreenSize()
    var body: some View {
            ScrollView{
                VStack{
                    HStack {
                        Text(currentclubnews.newstitle)
                            .foregroundColor(Color.black)
                            .font(.system(size: 35, weight: .bold, design: .rounded))                            .lineLimit(2)
                            .minimumScaleFactor(0.3)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    HStack {
                        Text(currentclubnews.author)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack {
                        Text(currentclubnews.newsdate)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    
                    VStack {
                        TabView {
                            
                            // Loop through each recipe
                            ForEach(currentclubnews.imagedata.indices, id: \.self) { index in
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.white)
                                    
                                    VStack(spacing: 0) {
                                        Image(uiImage: currentclubnews.imagedata[index])
                                            .resizable()
                                            .padding(.bottom, 2)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: screen.screenWidth - 20, height: 250)
                                            .clipped()
                                            .cornerRadius(30)
                                    }
                                }
                            }
                            
                            
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        
                    }.cornerRadius(30)
                        .frame(width: screen.screenWidth - 20, height: 250)
                        .shadow(color: .gray, radius: 8, x:2, y:3)
                        .padding(.horizontal)
                    Spacer()
                    
                    Text(currentclubnews.newsdescription)
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
                    
                }.padding(.top, 0 - (screen.screenHeight / 10) + 30) // <---
            }
        }
    }



struct ClubsNewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsNewsDetailView(currentclubnews: clubNews(
            newstitle: "August learns how to piss!",
            newsimage: ["roboticsclub"],
            newsdescription: "this is a hardcoded example, is not from firebase and should never be shwon on the app",
            newsdate: "Apr 1, 2023",
            author: "Aiden Jamae Lee (not funny)",
            documentID: "NAN", imagedata: []))
    }
}
