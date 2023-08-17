//
//  UpcomingEventsView.swift
//  West App
//
//  Created by Aiden Lee on 5/28/23.
//

import SwiftUI

struct UpcomingEventsView: View {
    var dataManager = upcomingEventsDataManager()

    var body: some View {
                VStack {
                    
                    NavigationLink {
                        UpcomingEventsAdminView()
                    } label: {
                        Text("edit events")
                    }
                    
                    List(dataManager.alleventslist, id: \.id){event in
                        HStack {
                            VStack {
                                Text(event.month)
                                    .font(.system(size: 18))
                                    .foregroundColor(.red)
                                Text(event.day)
                                    .font(.system(size: 24))
                            }.padding(.vertical, -10)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                            Divider()
                            VStack(alignment: .leading) {
                                Text(event.eventname)
                                    .fontWeight(.semibold)
                                Text(event.time)
                            }.padding(.vertical, -5)
                                .padding(.horizontal,7)
                            Spacer()
                        }
                        .padding(.horizontal, 70)
                        .padding(.vertical, 20)

                        .background(Rectangle()
                            .cornerRadius(9.0)                                    
                            .padding(.horizontal)
                            .shadow(radius: 5, x: 2, y: 2)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        
                    }
                }
                .navigationBarTitle(Text("Upcoming Events"))
            
        
        

        
    }
}

struct UpcomingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsView()
    }
}
