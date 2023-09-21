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
    var selectedsport:sport
    var body: some View {
            let currentsport = selectedsport
            SportsDetailView(currentsport: currentsport)
                .ignoresSafeArea(.container, edges: .top)
                .environmentObject(sportsmanager)
                .environmentObject(sporteventmanager)
        //.background(.blue)
    }

}

struct SportsMainView_Previews: PreviewProvider {
    static var previews: some View {
        SportsMainView(selectedsport: sportsManager().allsportlist.first!).environmentObject(SportsHibabi.ViewModel()).environmentObject(UserInfo())
        
    }
}

