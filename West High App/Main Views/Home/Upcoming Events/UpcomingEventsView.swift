//
//  UpcomingEventsView.swift
//  West App
//
//  Created by Aiden Lee on 5/28/23.
//

import SwiftUI

struct UpcomingEventsView: View {
    @StateObject var upcomingeventsdataManager = upcomingEventsDataManager.shared
    @EnvironmentObject var userInfo: UserInfo
    @State private var hasPermissionUpcomingEvents = false
    @State private var hasPermission = false
    @State private var hasAppeared = false
    var upcomingeventslist: [event]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Text("Upcoming Events")
                        .foregroundColor(Color.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text("Calendar")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.leading)
                    Spacer()
                }
                if upcomingeventsdataManager.allupcomingeventslist.isEmpty {
                    Text("No upcoming events.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .padding(5)
                    Spacer()
                }
                ForEach(upcomingeventsdataManager.allupcomingeventslist, id: \.id) { event in // REVERT BACK MAYBE
                    HStack {
                        VStack {
                            Text(event.date.monthName)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.red)
                            Text("\(event.date.dateComponent(.day))")
                                .font(.system(size: 26, weight: .regular, design: .rounded))
                            
                        }
                        .frame(width:50,height:50)
                        Divider()
                        VStack(alignment: .leading) {
                            Text(event.eventname)
                                .minimumScaleFactor(0.8)
                                .lineLimit(2)
                                .font(.system(size: 18, weight: .semibold, design: .rounded)) // semibold
                            Text(event.isAllDay ? "All Day" : event.date.twelveHourTime)
                                .minimumScaleFactor(0.8)
                                .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                .lineLimit(1)
                        }
                        .padding(.leading, 5)
                        Spacer()
                        
                    }
                    
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Rectangle()
                        .cornerRadius(9.0)
                        .shadow(color: Color.black.opacity(0.25), radius: 3, x: 1, y: 1)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                if !upcomingeventsdataManager.allupcomingeventslist.isEmpty && !upcomingeventsdataManager.allDocsLoaded {
                    ProgressView()
                        .padding()
                        .background(Rectangle()
                            .cornerRadius(9.0)
                            .shadow(color: Color.black.opacity(0.25), radius: 3, x: 1, y: 1)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .onAppear {
                            upcomingeventsdataManager.getMoreUpcomingEvents()
                        }
                }
            }
        }
    }
}

struct UpcomingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsView(upcomingeventslist: [])
    }
}
