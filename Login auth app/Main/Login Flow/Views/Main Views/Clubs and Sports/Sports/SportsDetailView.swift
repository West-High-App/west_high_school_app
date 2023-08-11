//
//  SportsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct SportsDetailView: View {
    @State var selected = 1
    @EnvironmentObject var vm: SportsHibabi.ViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    var currentsport: sport
    var safeArea: EdgeInsets
    var size: CGSize
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    // MARK: - Artwork
                    Artwork()
                    // Since We ignored Top Edge
                    GeometryReader{ proxy in
                        let minY = proxy.frame(in: .named("SCROLL")).minY - safeArea.top
                        
                        VStack {
                            if vm.contains(currentsport) == false {
                                Button {
                                    confirming = true
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.app")
                                            .resizable()
                                            .foregroundColor(westblue)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 24)
                                        Text("Add to my Sports")
                                            .foregroundColor(westblue)
                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    }.padding(.all, 10)
                                        .background(Color(hue: 0, saturation: 0, brightness: 0.95, opacity: 0.90))
                                        .cornerRadius(10)
                                }.confirmationDialog("Add to My Sports", isPresented: $confirming) {
                                    Button("Add to My Sports") {
                                        vm.toggleFav(item: currentsport)
                                    }
                                }
                            } else {
                                Button (role: .destructive){
                                    confirming2 = true
                                } label: {
                                    HStack {
                                        Image(systemName: "xmark.app")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 24)
                                        Text("Remove Sport")
                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    }
                                    .padding(.all, 10)
                                        .background(Color(hue: 0, saturation: 0, brightness: 0.95, opacity: 0.90))
                                        .cornerRadius(10)
                                }.confirmationDialog("Remove from My Sports", isPresented: $confirming2) {
                                    Button("Remove from My Sports", role: .destructive) {
                                        vm.toggleFav(item: currentsport)
                                    }
                                }
                            }
                        }
                        .padding(.top,-60)
                        .frame(maxWidth: .infinity, maxHeight:.infinity)
                        .offset(y: minY < 50 ? -(minY - 50) : 0)
                    }
                    .zIndex(1)
                    
                    VStack{
                        Picker(selection: $selected, label: Text(""), content: {
                            Text("Upcoming").tag(1)
                            Text("Members").tag(2)
                            Text("Information").tag(3)

                        })
                        .pickerStyle(SegmentedPickerStyle())


                        if selected == 1{
                            VStack {
                                HStack {
                                    VStack {
                                        Text("Jul")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                        Text("7")
                                            .font(.system(size: 24))
                                    }.padding(.vertical, -5)
                                        .padding(.leading, 20)
                                        .padding(.trailing, 10)
                                    Divider()
                                    VStack(alignment: .leading) {
                                        Text("Lunch Meeting")
                                            .fontWeight(.semibold)
                                        Text("At lunch at room 1209")
                                    }.padding(.vertical, -5)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                Divider()
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                HStack {
                                    VStack {
                                        Text("Jul")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                        Text("12")
                                            .font(.system(size: 24))
                                    }.padding(.vertical, -5)
                                        .padding(.leading, 20)
                                        .padding(.trailing, 10)
                                    Divider()
                                    VStack(alignment: .leading) {
                                        Text("Community service")
                                            .fontWeight(.semibold)
                                        Text("7:30 PM @ MIA")
                                    }.padding(.vertical, -5)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                Divider()
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                HStack {
                                    VStack {
                                        Text("Jul")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                        Text("15")
                                            .font(.system(size: 24))
                                    }.padding(.vertical, -5)
                                        .padding(.leading, 20)
                                        .padding(.trailing, 10)
                                    Divider()
                                    VStack(alignment: .leading) {
                                        Text("Potluck")
                                            .fontWeight(.semibold)
                                        Text("7:00 PM @ Hoyt Park")
                                    }.padding(.vertical, -5)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                                .padding(.all)
                                .frame(width:370)
                                .background(Color(red: 250/255, green: 250/255, blue: 250/255))
                                .cornerRadius(12)
                            }
                        if selected == 2{
                            VStack{
                                NavigationView{
                                    List{
                                        Section{
                                            ForEach(currentsport.sportcoaches, id: \.self){captain in
                                                HStack{
                                                    //Image(systemName: "star")
                                                    Text(captain)
                                                }
                                            }
                                        }
                                        header:{
                                          Text("Coaches")
                                        }
                                        Section{
                                            ForEach(currentsport.sportscaptains!, id: \.self){captain in
                                                HStack{
                                                    //Image(systemName: "star")
                                                    Text(captain)
                                                }
                                            }
                                        }
                                        header:{
                                            Text("Captains")
                                        }
                                        Section{
                                            ForEach(currentsport.sportsroster, id: \.self){player in
                                                HStack{
                                                    //Image(systemName: "person.crop.circle")
                                                    Text(player)
                                                }
                                            }
                                        }
                                        header:{
                                            Text("Roster")
                                        }
                                    }

                                }
                            }
                            .padding(.horizontal, -15)
                            .background(.gray)
                            .cornerRadius(12)

                            }
                        if selected == 3{
                            VStack {
                                Text("MAKE THIS EDITABLE SO COACHES/CAPTAINS CAN WRITE WHAT THEY WANT HERE")
                                    .fontWeight(.semibold)
                            }
                    
                            }











                    }
                    .padding()
                    .background(Rectangle()
                        .cornerRadius(20.0)
                        //.padding(.leading,20)
                        .shadow(radius: 10)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    .padding(.horizontal)
                    
                }
                .overlay(alignment: .top) {
                    HeaderView()
                }
                
                
                
                
                
                
                
            }
            .background(westblue)
            .coordinateSpace(name: "SCROLL")
    }

    @ViewBuilder
    func Artwork() -> some View {
        let height = size.height * 0.65
        GeometryReader{ proxy in
            
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            Image(currentsport.sportsimage)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
                .clipped()
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                        // MARK: - Gradient Overlay
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    westblue.opacity(0 - progress),
                                    westblue.opacity(0 - progress),
                                    westblue.opacity(0.05 - progress),
                                    westblue.opacity(0.1 - progress),
                                    westblue.opacity(0.5 - progress),
                                    westblue.opacity(1),
                                ], startPoint: .top, endPoint: .bottom)
                            )
                        VStack(spacing: 0) {
                            Text(currentsport.sportname)
                                .font(                                .custom("Trebuchet MS", fixedSize: 60))
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text(currentsport.sportsteam)
                                .bold()
                                .font(
                                    .custom("Apple SD Gothic Neo", fixedSize: 30))
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)

                        }
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding(.bottom, 65)
                        
                        // Moving with Scroll View
                        
                        .offset(y: minY < 0 ? minY : 0 )
                    }
                })
            
                .offset(y: -minY)
            
            
             
        }
        .frame(height: height + safeArea.top )
    }
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader{ proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress =  minY / height
            
            HStack {
                Spacer(minLength: 0)
                
//                HStack{
//                    VStack{
//                        Text(currentclub.clubmeetingroom)
//                            .font(                                .custom("Apple SD Gothic Neo", fixedSize: 32))
//                            .foregroundStyle(westblue)
//                            .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
//                            .offset(y: -titleProgress < 0.75 ? 0 : 100)
//                            .animation(.easeOut(duration: 0.55), value: -titleProgress > 0.75)
//                            .opacity(1 + (progress > 0 ? -progress : progress))
//                        Spacer()
//                    }
//                    .padding(.leading)
//                    Spacer()
//                }
            }
            .overlay(content: {
                Text(currentsport.sportname)
                    .font(                                .custom("Apple SD Gothic Neo", fixedSize: 60))
                    .bold()
                    .foregroundStyle(westyellow)
                    .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                    .offset(y: -titleProgress > 1 ? 0 : 80)
                    .clipped()
                    .animation(.easeOut(duration: 0.25), value: -titleProgress > 1)
            })
            .padding(.top,70)

            //.padding([.horizontal,.bottom], 15)
            //.padding(safeArea.top + 20)
//THIS PLACE IS THE LOGO DRAG EFFECT
            //.background(
             //   Color.blue
              //      .opacity(-progress > 1 ? 1 : 0)
            //)
            
            .offset(y: -minY)
            
            
            
        }
        .frame(height: 35)
    }
    }

struct SportsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SportsMainView(selectedsport: sport.allsportlist.first!).environmentObject(SportsHibabi.ViewModel())
    }
}
