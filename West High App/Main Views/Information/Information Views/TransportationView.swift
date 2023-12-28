//
//  TransportationView.swift
//  West App
//
//  Created by Aiden Lee on 5/25/23.
//

import SwiftUI

struct TransportationView: View {
    var body: some View {
        ZStack{
            SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/families/bus-routes")!)
        }
        .navigationBarTitleDisplayMode(.inline)

//        ScrollView{
//            ZStack{
//                ZStack{
//                    Rectangle()
//                        .frame(height: 60)
//                        .foregroundColor(Color(red: 41/255, green: 51/255, blue:145/255))
//                    HStack{
//                        Text("WEST HIGH SCHOOL")
//                            .padding(.leading,25)
//                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
//                            .font(
//                                .custom(
//                                    "Devanagari Sangam MN",
//                                    fixedSize: 13.4)
//                                .weight(.semibold)
//                            )
//                        Spacer()
//                    }
//
//                }
//                ZStack{
//                    Rectangle()
//                        .frame(height:40)
//                        .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
//                        .offset(y:50)
//                    HStack{
//                        Image("mmsd")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width:20)
//                            .offset(y:50)
//
//
//                        Text("MADISON METROPOLITAN SCHOOL DISTRICT")
//                            .font(
//                                .custom(
//                                    "Devanagari Sangam MN",
//                                    fixedSize: 11)
//                            )
//                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
//                            .offset(y:50)
//                        Spacer()
//                    }
//                    .padding(.leading)
//                }
//            }
//            VStack{
//                VStack{
//                    HStack{
//                        Text("Bus Routes")
//                            .foregroundColor(.black)
//                            .font(
//                                .custom(
//                                    "arial",
//                                    fixedSize: 45)
//                                .weight(.bold)
//                            )
//                            .padding(.bottom, 10)
//                        Spacer()
//                    }
//                    .padding(.leading, 15)
//                    Image("SchoolBus")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .cornerRadius(10)
//
//                }
//                    .padding(.vertical,20)
//                HStack{
//                    Text("Metro Bus Info & Routes")
//                        .font(
//                            .custom(
//                                "Arial",
//                                fixedSize: 22)
//                            .weight(.semibold)
//                        )
//                        .foregroundColor(Color(red: 48/255, green: 60/255, blue: 149/255))
//                    Spacer()
//                }
//                .padding(.leading,7)
//                .padding(.bottom,10)
//                VStack{
//                    Text("""
//[Metro Bus Routes available here](https://www.cityofmadison.com/metro/documents/school/west.pdf) or see the [map](https://www.google.com/maps/dir//West+High+School,+Ash+Street,+Madison,+WI/@43.0687424,-89.4962826,12z/data=!3m1!4b1!4m9!4m8!1m0!1m5!1m1!1s0x8807acefd42255e3:0x63ada94487f83beb!2m2!1d-89.4262422!2d43.0687638!3e3).
//
//For specific route information, call Metro Transit at (608)-266-4466 or [plan your trip](https://www.google.com/maps/dir//West+High+School,+Ash+Street,+Madison,+WI/@43.0687424,-89.4962826,12z/data=!3m1!4b1!4m9!4m8!1m0!1m5!1m1!1s0x8807acefd42255e3:0x63ada94487f83beb!2m2!1d-89.4262422!2d43.0687638!3e3).
//
//[See more info about the supplemental school routes here.](https://www.cityofmadison.com/metro/documents/school/school-infosheet.pdf)
//
//**Need to Purchase a Bus Pass from Madison Metro?** [Click Here](https://www.cityofmadison.com/metro/fares)
//
//**District-funded Bus Passes**
//
//The district-funded Metro bus passes will be available if your family qualifies for free or reduced lunch and lives 1.6 miles from school or more. More info about obtaining these passes to come.
//
//[If you have not yet filled out the application for free or reduced lunch, please click here to do so.](https://www.schoolcafe.com)
//
//**Bus drop off/pick up**
//
//Metro buses will continue to drop off students on Regent Street, but will now pick up students at two different locations. Please look at the map below to determine if your student will catch their bus on:
//""")
//                    .padding(.leading,7)
//                    .padding(.bottom, 5)
//                    VStack(alignment: .leading, spacing: 20){
//                        HStack{
//                            Image(systemName: "bus.fill")
//                            Text("Regent Street: (W3 Arboretum, W1 Tokay, W3 Hill Farms, W1 Shorewood, W1 Mineral Point)")
//                        }
//                        HStack{
//                            Image(systemName: "bus.fill")
//                            Text("Van Hise Avenue: (W1 Nakoma, W3 Leopold, W5 Burr Oaks, W5 Wingra, W7 Olin.")
//                        }
//                        HStack{
//                            Image(systemName: "bus.fill")
//                            Text("Fitchburg: yellow buses will load on Ash Street.")
//                        }
//                    }
//                    .padding(.horizontal,10)
//                }
//                HStack{
//                    Text("Badger Bus (Yellow Bus) Info & Routes")
//                        .font(
//                            .custom(
//                                "Arial",
//                                fixedSize: 22)
//                            .weight(.semibold)
//                        )
//                        .foregroundColor(Color(red: 48/255, green: 60/255, blue: 149/255))
//                    Spacer()
//                }
//                .padding(.leading,7)
//                .padding(.bottom,10)
//                .padding(.top,5)
//                Link(destination: URL(string: "https://www.madison.k12.wi.us/transportation/west-bus-routes")!) {
//
//
//                    Text("West Fitchburg Badger Bus Routes")
//                        .font(
//                            .custom(
//                                "arial",
//                                fixedSize: 23)
//                            .weight(.regular)
//                        )
//                        .frame(height:45)
//                        .foregroundColor(.yellow)
//                        .background(LinearGradient(colors: [Color(red: 20/255, green: 100/255, blue: 235/255), Color(red: 100/255, green: 120/255, blue: 200/255)],
//                                                   startPoint: .top,
//                                                   endPoint: .bottom))
//                        .cornerRadius(12)
//                        .scaleEffect(1)
//                }
//                Text("These are the areas not serviced by Metro in the West attendance area.")
//                VStack (alignment: .leading){
//                    HStack{
//                        Text("""
//**Contact Info**
//
//**Regular Yellow School Bus Services:** (608)-298-5471
//**Specialized Transportation Services:** (608)-298-5470
//**All services after 5:00pm:** (608)-310-4892
//**E-mail:** jasonf@badgerbus.com
//""")
//                    Spacer()
//                    }
//                    .padding(.leading,10)
//                }
//                HStack{
//                    Text("Bus Stop Reminders")
//                        .font(
//                            .custom(
//                                "Arial",
//                                fixedSize: 22)
//                            .weight(.semibold)
//                        )
//                        .foregroundColor(Color(red: 48/255, green: 60/255, blue: 149/255))
//                    Spacer()
//                }
//                .padding(.top,2)
//                .padding(.leading,7)
//                .padding(.bottom,10)
//                VStack{
//                    Text("Please remember to arrive at the bus stop at least 5 minutes prior to the published stop time. Please note that PM (drop off) times have been estimated. Please be aware:")
//                        .padding(.leading,3)
//                        .padding(.bottom,5)
//
//                    HStack{
//                        Image(systemName: "bus.fill")
//                        Text("The bus **could be early**, but will wait until the established drop off time.")
//                    }
//                    .padding(.trailing,25)
//                    .padding(.bottom,5)
//                    HStack{
//                        Image(systemName: "bus.fill")
//                        Text("The bus **could be late** due to road conditions, traffic, student interaction, and so on.")
//                    }
//                    .padding(.trailing,17)
//                    .padding(.bottom,5)
//
//
//                }
//                VStack(alignment: .center){
//                    Text("For extra information visit the official MMSD transportation website down below")
//                        .padding(.trailing,60)
//                        .padding(.top,5)
//
//                    Link(destination: URL(string: "https://www.madison.k12.wi.us/transportation")!) {
//
//
//                        Text("MMSD Transportation Website")
//                            .font(
//                                .custom(
//                                    "arial",
//                                    fixedSize: 23)
//                                .weight(.regular)
//                            )
//                            .frame(width:360, height:45)
//                            .foregroundColor(.yellow)
//                            .background(LinearGradient(colors: [Color(red: 20/255, green: 100/255, blue: 235/255), Color(red: 100/255, green: 120/255, blue: 200/255)],
//                                                       startPoint: .top,
//                                                       endPoint: .bottom))
//                            .cornerRadius(12)
//                            .scaleEffect(1)
//                            .padding(.bottom,30)
//
//                    }
//                }
//            }
//            .padding(.top,40)
//            .padding(.bottom,60)
//        }
    }
}

struct TransportationView_Previews: PreviewProvider {
    static var previews: some View {
        TransportationView()
    }
}
