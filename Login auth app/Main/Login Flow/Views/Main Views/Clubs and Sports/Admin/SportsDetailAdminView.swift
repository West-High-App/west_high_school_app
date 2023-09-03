//
//  SportsDetailAdminView.swift
//  West High App
//
//  Created by August Andersen on 02/09/2023.
//

import SwiftUI

struct SportsDetailAdminView: View {
    var editingsport: sport
    
    @State var isConfirmingChanges = false
    
    @State var sportname = ""
    @State var sportcoaches: [String] = []
    @State var adminsstring = ""
    @State var adminemails: [String] = []
    @State var sportsimage = ""
    @State var sportsteam = ""
    @State var sportsroster: [String] = []
    @State var sportscaptains: [String] = []
    @State var tags: [Int] = []
    @State var info = ""
    
    var body: some View {
        Text("Hello, World!") // MARK: pick up here august u were making the sportsdetailadminview to edit the information in already existing sports
            .onAppear {
                // initialing properties
                sportname = editingsport.sportname
                sportcoaches = editingsport.sportcoaches
                adminemails = editingsport.adminemails
                sportsimage = editingsport.sportsimage
                sportsteam = editingsport.sportsteam
                sportsroster = editingsport.sportsroster
                sportscaptains = editingsport.sportscaptains
                tags = editingsport.tags
                info = editingsport.info
            }
    }
}

struct SportsDetailAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SportsDetailAdminView(editingsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", documentID: "NAN", sportid: "SPORT ID", id: 1))
    }
}
