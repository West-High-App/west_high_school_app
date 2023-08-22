//
//  SchoolLunchMenuView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI
import Foundation

struct LunchMenuView: View {
    
//    var date = lunchDate(daysToAdd: 0)
//    @State var choice1 = "Burritos"
//    @State var choice1image = "burritos"
//    @State var choice2 = "Salad"
//    @State var choice2image = "salad"
//
//    struct lunchDate {
//
//        var daysToAdd: Int
//
//        func isWeekday() -> Bool {
//            let dayFormatter = DateFormatter()
//            let todaysDate = Date()
//            dayFormatter.dateFormat = "EEEE"
//            var dateComponent = DateComponents()
//            dateComponent.day = daysToAdd
//            let day = dayFormatter.string(from: Calendar.current.date(byAdding: dateComponent, to: todaysDate)!)
//            var returnValue = true
//            if day == "Saturday" || day == "Sunday" {
//                returnValue = false
//            }
//            return returnValue
//        }
//
//        func getNewDate() -> String {
//            let todaysDate = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEEE, MMMM d"
//            var dateComponent = DateComponents()
//            dateComponent.day = daysToAdd
//            let newDate = dateFormatter.string(from: Calendar.current.date(byAdding: dateComponent, to: todaysDate)!)
//            return newDate
//        }
//
//        func getNewMonth() -> String {
//            let todaysDate = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM"
//            var dateComponent = DateComponents()
//            dateComponent.day = daysToAdd
//            let newDate = dateFormatter.string(from: Calendar.current.date(byAdding: dateComponent, to: todaysDate)!)
//            return newDate
//        }
//
//        func getNewDay() -> String {
//            let todaysDate = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "d"
//            var dateComponent = DateComponents()
//            dateComponent.day = daysToAdd
//            let newDate = dateFormatter.string(from: Calendar.current.date(byAdding: dateComponent, to: todaysDate)!)
//            return newDate
//        }
//    }
//
//    @State var lunchdate = lunchDate(daysToAdd: 0).getNewDate()
//
    var body: some View {
        SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/families/menus"))
//        ScrollView {
//            VStack{
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack{
//                        if lunchDate(daysToAdd: 0).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 0).getNewDate()
//                                choice1 = "Burritos"
//                                choice1image = "burritos"
//                                choice2 = "Salad"
//                                choice2image = "salad"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 0).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 0).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 1).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 1).getNewDate()
//                                choice1 = "Pizza"
//                                choice1image = "pizza"
//                                choice2 = "Fruit"
//                                choice2image = "fruit"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 1).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 1).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 2).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 2).getNewDate()
//                                choice1 = "Meatballs"
//                                choice1image = "meatballs"
//                                choice2 = "Salad"
//                                choice2image = "salad"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 2).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 2).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 3).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 3).getNewDate()
//                                choice1 = "Burritos"
//                                choice1image = "burritos"
//                                choice2 = "Salad"
//                                choice2image = "salad"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 3).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 3).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 4).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 4).getNewDate()
//                                choice1 = "Pizza"
//                                choice1image = "pizza"
//                                choice2 = "Fruit"
//                                choice2image = "fruit"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 4).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 4).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 5).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 5).getNewDate()
//                                choice1 = "Meatballs"
//                                choice1image = "meatballs"
//                                choice2 = "Salad"
//                                choice2image = "salad"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 5).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 5).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 6).isWeekday() {
//                            Button {
//                                lunchdate = lunchDate(daysToAdd: 6).getNewDate()
//                                choice1 = "Pizza"
//                                choice1image = "pizza"
//                                choice2 = "Fruit"
//                                choice2image = "fruit"
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 6).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 6).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        if lunchDate(daysToAdd: 7).isWeekday() {
//                            Button {
//                                ()
//                            } label: {
//                                VStack {
//                                    Text(lunchDate(daysToAdd: 7).getNewMonth())
//                                        .font(.body)
//                                        .foregroundColor(.red)
//                                    Text(lunchDate(daysToAdd: 7).getNewDay())
//                                        .font(.title2)
//                                        .foregroundColor(.black)
//                                }.padding(.all, 10)
//                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                    .cornerRadius(10)
//                            }
//                        }
//                        HStack {
//                            if lunchDate(daysToAdd: 8).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 8).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 8).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 9).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 9).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 9).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 10).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 10).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 10).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 11).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 11).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 11).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 12).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 12).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 12).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 13).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 13).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 13).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 14).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 14).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 14).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//
//                            if lunchDate(daysToAdd: 25).isWeekday() {
//                                Button {
//                                    ()
//                                } label: {
//                                    VStack {
//                                        Text(lunchDate(daysToAdd: 15).getNewMonth())
//                                            .font(.body)
//                                            .foregroundColor(.red)
//                                        Text(lunchDate(daysToAdd: 15).getNewDay())
//                                            .font(.title2)
//                                            .foregroundColor(.black)
//                                    }.padding(.all, 10)
//                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                                        .cornerRadius(10)
//                                }
//                            }
//                        }
//
//
//                    }.padding(.top, 20)
//                        .padding(.horizontal)
//                }
//                Spacer()
//                    .frame(height: 20)
//                Divider()
//                Text("Menu for \(lunchdate)")
//                    .font(.title)
//                    .fontWeight(.semibold)
//                Image(choice1image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 200)
//                    .cornerRadius(10)
//                Text("Choice 1: \(choice1)")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                DisclosureGroup {
//                    List {
//                        Text("Calories: 850")
//                        Text("Sugar: 5 grams")
//                        Text("Protein: 23 grams")
//                        Text("Sodium Chloride: 760 miligrams")
//                        Text("Calcium: 45 miligrams")
//                        Text("Contains gluten, dairy, and meat")
//                        Text("May contains some nuts")
//                    }.frame(height: 350)
//                } label: {
//                    Text("See details")
//                        .foregroundColor(.black)
//                        .font(.title3)
//                        .padding(.all,10)
//                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                        .cornerRadius(10)
//                        .padding(.leading,160)
//                }
//                Image(choice2image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 200)
//                    .cornerRadius(10)
//                    .padding(.top, 10)
//                Text("Choice 2: \(choice2)")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                DisclosureGroup {
//                    List {
//                        Text("Calories: 550")
//                        Text("Sugar: 0 grams")
//                        Text("Protein: 8 grams")
//                        Text("Sodium Chloride: 350 miligrams")
//                        Text("Contains gluten and dairy")
//                        Text("Nut free and vegan meal")
//                    }.frame(height: 330)
//                } label: {
//                    Text("See details")
//                        .foregroundColor(.black)
//                        .font(.title3)
//                        .padding(.all,10)
//                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
//                        .cornerRadius(10)
//                        .padding(.leading,160)
//                }
//            }.navigationBarTitle("Lunch Menus")
//        }
    }
}

struct LunchMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LunchMenuView()
    }
}
