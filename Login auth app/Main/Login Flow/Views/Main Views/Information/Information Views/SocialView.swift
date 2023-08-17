//
//  SocialView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI

struct SocialView: View {
    var body: some View {
        ZStack{
            VStack{
                VStack(spacing:20){
                    Link(destination: URL(string: "https://www.instagram.com/madisonwesthighschool/")!,
                         label: {
                        ZStack{
                            Text("West High Instagram")
                                .padding(.leading, 20)
                                .bold()
                                .padding(20)
                                .frame(width:280, height:45)
                                .foregroundColor(.white)
                                .background(Color(red: 41/255, green: 51/255, blue:145/255))
                                .cornerRadius(12)
                                .scaleEffect(1.2)
                            Image("instagram")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:70)
                                .offset(x:-140)
                                //.padding(.vertical, 10)
                                //.padding(.leading, 20)
                        }
                            .padding(.leading, 5)
                    }
                    )
                    Link(destination: URL(string: "https://twitter.com/MadisonWestHS")!,
                         label: {
                        ZStack{
                            Text("West High Twitter")
                                .padding(.leading, 0)
                                .bold()
                                .frame(width:280, height:45)
                                .foregroundColor(.white)
                                .background(Color(red: 41/255, green: 51/255, blue:145/255))
                                .cornerRadius(12)
                                .scaleEffect(1.2)
                            Image("twitter")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:70)
                                .offset(x:-140)
                                //.padding(.vertical, 10)
                                //.padding(.leading, 20)
                        }
                            .padding(.leading, 5)
                    }                    )
                    Link(destination: URL(string: "https://www.facebook.com/MMSDWest")!,
                         label: {
                        ZStack{
                            Text("West High Facebook")
                                .padding(.leading, 20)
                                .bold()
                                .frame(width:280, height:45)
                                .foregroundColor(.white)
                                .background(Color(red: 41/255, green: 51/255, blue:145/255))
                                .cornerRadius(12)
                                .scaleEffect(1.2)
                            Image("facebook")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:70)
                                .offset(x:-140)
                                //.padding(.vertical, 10)
                                //.padding(.leading, 20)
                        }
                            .padding(.leading, 5)
                    }                    )
                    Link(destination: URL(string: "https://west.madison.k12.wi.us")!,
                         label: {
                        ZStack{
                            Text("West High Website")
                                .padding(.leading, 10)
                                .bold()
                                .frame(width:280, height:45)
                                .foregroundColor(.white)
                                .background(Color(red: 41/255, green: 51/255, blue:145/255))
                                .cornerRadius(12)
                                .scaleEffect(1.2)
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width:40, height: 52)
                                    .offset(x:-140)
                                Image("mmsd")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:70)
                                    .offset(x:-140)
                                    //.padding(.vertical, 10)
                                    //.padding(.leading, 20)
                            }
                            .shadow(radius: 0)
                        }
                            .padding(.leading, 5)
                    }                    )
                }
                    .shadow(radius: 10)
                    .padding(.bottom,330)
            }
            .padding(.top,80)
            .navigationBarTitle("West Socials")
        }
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
