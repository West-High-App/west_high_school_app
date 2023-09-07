//
//  UpcomingEventsView.swift
//  West App
//
//  Created by Aiden Lee on 5/28/23.
//

import SwiftUI

struct UpcomingEventsView: View {
    @StateObject var dataManager = upcomingEventsDataManager()
    var permissionsManager = permissionsDataManager()
    var userInfo = UserInfo()
    @State private var hasPermissionUpcomingEvents = false
    @State private var hasPermission = false
    init() {
        dataManager.getUpcomingEvents()
    }
    
    var body: some View {
                VStack {

                    List(dataManager.allupcomingeventslist, id: \.id){event in
                        HStack {
                            VStack {
                                Text(event.month)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                Text(event.day)
                                    .font(.system(size: 24))
                            }
                            .frame(width:50,height:30)
                            Divider()
                            VStack(alignment: .leading) {
                                Text(event.eventname)
                                    .fontWeight(.semibold)
                                Text(event.time)    
                            }
                            .padding(.vertical, -5)
                            .padding(.leading, 5)
                            Spacer()

                        }

                            .padding()
                            .background(Rectangle()
                                .cornerRadius(9.0)
                                .shadow(radius: 5, x: 2, y: 2)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        
                    }
                }
                .navigationBarTitle(Text("Upcoming Events"))
                .onAppear {
                    permissionsManager.checkPermissions(dataType: "UpcomingEvents", user: userInfo.email) { result in
                        self.hasPermissionUpcomingEvents = result
                    }
                }

        
        

        
    }
}

struct UpcomingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsView()
    }
}
