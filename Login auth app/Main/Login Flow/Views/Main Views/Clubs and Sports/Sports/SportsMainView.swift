//
//  SportsMainView.swift
//  West High App
//
//  Created by Aiden Lee on 8/9/23.
//

import SwiftUI


struct SportsMainView: View {
    var selectedsport:sport
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            let currentsport = selectedsport
            SportsDetailView(currentsport: currentsport, safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
        //.background(.blue)
    }

}

struct SportsMainView_Previews: PreviewProvider {
    var sportmanager = sportsManager()
    static var previews: some View {
        SportsMainView(selectedsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", documentID: "NAN", sportid: "SPORT ID", id: 1)).environmentObject(SportsHibabi.ViewModel()).environmentObject(UserInfo())
        
    }
}


