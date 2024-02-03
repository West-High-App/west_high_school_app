//
//  SportsMainView.swift
//  West High App
//
//  Created by Aiden Lee on 8/9/23.
//

import SwiftUI


struct SportsMainView: View {
    @EnvironmentObject var sportsmanager: sportsManager
    @EnvironmentObject var sporteventmanager: sportEventManager
    let selectedsport: sport
    var body: some View {
        if let item = sportsmanager.allsportlist.first(where: { $0.documentID == selectedsport.documentID }) {
            SportsDetailView(currentsport: item)
                .environmentObject(sportsmanager)
                .environmentObject(sporteventmanager)
        }
        //.background(.blue)
    }

}

struct SportsMainView_Previews: PreviewProvider {
    static var previews: some View {
        SportsMainView(selectedsport: sportsManager.shared.allsportlist.first!).environmentObject(UserInfo())
        
    }
}

