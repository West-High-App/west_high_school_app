//
//  ClubsNewDetailView.swift
//  West App
//
//  Created by Aiden Lee on 7/7/23.
//

import SwiftUI

struct ClubsNewsDetailView: View {
var currentclubnews: clubNews
    var body: some View {
            GeometryReader { geo in
            ScrollView{
                VStack{
                    VStack {
                            TabView {
                                
                                // Loop through each recipe
                                ForEach (0..<currentclubnews.newsimage.count) { index in
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.white)
                                        
                                        VStack(spacing: 0) {
                                            Image(uiImage: currentclubnews.imagedata[0] ?? UIImage())
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 500, height: 500)
                                                .clipped()
                                        }
                                    }
                                    .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(15)
                                }
                                
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            
                        }.cornerRadius(30)
                    .frame(width: 380, height: 500)
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
                            Text(currentclubnews.newstitle)
                            //.padding(.leading,10)
                                .lineLimit(3)
                                .padding(.horizontal,25)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black)
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                            HStack{
                                Text(currentclubnews.newsdate)
                                    .padding(.leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                Spacer()
                                Text("Author: " + currentclubnews.author)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.trailing)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical,10)
                            .background(Rectangle()
                                .cornerRadius(9.0)
                                .frame(width: 400)
                                .padding(.horizontal)
                                .shadow(radius: 5, x: 3, y: 3)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            .padding(.bottom, 10)
                        }
                        
                        Text(currentclubnews.newsdescription)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .padding(.horizontal, 25)
                            .padding(.vertical,5)
                            .background(Rectangle()
                                .cornerRadius(9.0)
                                .frame(width: 400)
                                .padding(.horizontal)
                                .shadow(radius: 5, x: 3, y: 3)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            .padding(.vertical, 5)
                    }

                }
            }
            
        }
    }


struct ClubsNewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsNewsDetailView(currentclubnews: clubNews(
            newstitle: "hardcoded title",
            newsimage: ["roboticsclub"],
            newsdescription: "this is a hardcoded example, is not from firebase and should never be shwon on the app", newsdate: "Apr 1, 2023",
            author: "aiden jamae lee lmfao remember",
            documentID: "NAN", imagedata: []))
    }
}
