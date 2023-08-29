//
//  SportsNewsDetailView.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import SwiftUI

struct SportsNewsDetailView: View {
var currentnews: sportNews
    var body: some View {
            GeometryReader { geo in
            ScrollView{
                VStack{
                    VStack {
                            TabView {
                                
                                // Loop through each recipe
                                ForEach (0..<currentnews.newsimage.count) { index in
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.white)
                                        
                                        VStack(spacing: 0) {
                                            Image(currentnews.newsimage[index])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 500, height: 500)
                                                .clipped()
                                        }
                                    }
                                    .frame(width: geo.size.width, height: geo.size.height - 100, alignment: .center)
                                    .cornerRadius(15)
                                }
                                
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            
                        }.cornerRadius(30)
                    
                    .frame(width: 380, height: 500)
                    .shadow(color: .gray, radius: 8, x:2, y:3)
                    .padding(.trailing, 10)
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
                            Text(currentnews.newstitle)
                            //.padding(.leading,10)
                                .lineLimit(3)
                                .padding(.horizontal,25)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black)
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                            HStack{
                                Text(currentnews.newsdate)
                                    .padding(.leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                Spacer()
                                Text("Author: " + currentnews.author)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.trailing)
                            }
                            .padding(.vertical,5)
                            .background(Rectangle()
                                .cornerRadius(9.0)
                                //.frame(width: 400)
                                .padding(.horizontal, -20)
                                .shadow(radius: 5, x: 3, y: 3)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            .padding(.bottom, 10)
                        }
                        
                        Text(currentnews.newsdescription)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .padding(.horizontal, 20)
                            .padding(.vertical,5)
                            .background(Rectangle()
                                .cornerRadius(9.0)
                                .padding(.horizontal, -20)
                                .shadow(radius: 5, x: 3, y: 3)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            .padding(.vertical, 5)
                    }

                }
            }
            
        }
    }

struct SportsNewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SportsNewsDetailView(currentnews: sportNews(
            newstitle: "Varsity Football Team Wins Regional Championship",
            newsimage: ["football"],
            newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
            newsdate: "Nov 15, 2022",
            author: "Emily Thompson", documentID: "NAN"))
    }
}
