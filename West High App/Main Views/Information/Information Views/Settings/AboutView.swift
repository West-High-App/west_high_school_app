//
//  AboutView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        let screenSize: CGRect = UIScreen.main.bounds
        ScrollView(showsIndicators: false){
            ZStack{
                ZStack{
                    Rectangle()
                        .frame(width: screenSize.width, height: 60)
                        .foregroundColor(Color(red: 41/255, green: 51/255, blue:145/255))
                    HStack{
                        Text("WEST HIGH SCHOOL")
                            .padding(.leading, 15)
                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
                            .font(
                                .custom(
                                    "Devanagari Sangam MN",
                                    fixedSize: 13.4)
                                .weight(.semibold)
                            )
                        Spacer()
                    }
                    
                }
                ZStack{
                    Rectangle()
                        .frame(width:screenSize.width, height:40)
                        .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                        .offset(y:50)
                    HStack{
                        Image("mmsd")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20)
                            .offset(y:50)

                        
                        Text("MADISON METROPOLITAN SCHOOL DISTRICT")
                            .font(
                                .custom(
                                    "Devanagari Sangam MN",
                                    fixedSize: 11)
                            )
                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
                            .offset(y:50)
                        Spacer()
                    }
                    .padding(.leading,15)
                }
            }
            VStack{
                VStack{
                    HStack{
                        Text("About")
                            .foregroundColor(.black)
                            .font(
                                .custom(
                                    "arial",
                                    fixedSize: 45)
                                .weight(.bold)
                            )
                            .padding(.bottom, 10)
                            .padding(.leading,10)
                        Spacer()
                    }
                    
                }
                .padding(.vertical,50)
            }
            .padding(.top, 30)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
