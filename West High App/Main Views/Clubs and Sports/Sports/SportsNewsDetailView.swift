//
//  SportsNewsDetailView.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import SwiftUI

struct SportsNewsDetailView: View {
    var currentnews: sportNews
    @StateObject var imagemanager = imageManager()
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    @State var imagedata: [UIImage] = []
    var body: some View {
        ScrollView{
            VStack{
                HStack {
                    Text(currentnews.newstitle)
                        .foregroundColor(Color.black)
                        .font(.system(size: 35, weight: .bold, design: .rounded))                            .lineLimit(2)
                        .minimumScaleFactor(0.3)
                        .padding(.horizontal)
                    Spacer()
                }

                HStack {
                    Text(currentnews.author)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text(currentnews.newsdate)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.horizontal)
                    Spacer()
                }


                VStack {
                    TabView {
                        
                        // Loop through each recipe
                        ForEach(imagedata.indices, id: \.self) { index in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    Image(uiImage: imagedata[index])
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
            }.padding(.top, 0 - (screen.screenHeight / 10) + 30) // <---
            .onAppear {
                if !hasAppeared || currentnews.imagedata == [] || currentnews.imagedata.first == UIImage() || currentnews.imagedata.first == nil {
                
                    for image in currentnews.newsimage {
                        imagemanager.getImage(fileName: image) { uiimage in
                             if let uiimage = uiimage {
                                 imagedata.append(uiimage)
                             }
                        }
                    }
                     hasAppeared = true
                } else {
                }
                
           }

            LinkTextView(text: currentnews.newsdescription)
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

struct SportsNewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SportsNewsDetailView(currentnews: sportNews(
            newstitle: "Varsity Football Team Wins Regional Championship",
            newsimage: ["football"],
            newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
            newsdate: "Nov 15, 2022", newsdateSwift: Date(),
            author: "Emily Thompson", isApproved: false, imagedata: [], documentID: "NAN"))
    }
}
