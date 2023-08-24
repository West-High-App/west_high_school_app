//
//  HelpSupportView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//

import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
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
                        Text("Help & Support")
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
            
            VStack{
                DisclosureGroup("FAQs"){
                    VStack(alignment:.leading){
                        HStack{
                            VStack(alignment: .leading){
                                Text("Regent Attendance:")
                                    .padding(.leading,10)
                                Button {
                                } label: {
                                    Text("(608) 204-4108")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Regent Attendance:")
                                    .padding(.leading,10)
                                Button {
                                } label: {
                                    Text("(608) 204-3091")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                
                
                
                DisclosureGroup("Logging in"){
                    VStack(alignment:.leading){
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Corvonn Gaines** \nWest High School Athletic Director")
                                    .padding(.leading,10)
                                
                                Text("cjgaines@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                } label: {
                                    Text("(608) 204-3060")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Natalie Loranger**                                                 \nAthletic Secretary")
                                    .padding(.leading,10)
                                
                                Text("nkloranger@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                } label: {
                                    Text("(608) 204-4103")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical)
                        
                        
                        
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                DisclosureGroup("Report bugs"){
                    VStack{
                        Text("")
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
            }
            .padding(.horizontal, 5)
            
        }

    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}
