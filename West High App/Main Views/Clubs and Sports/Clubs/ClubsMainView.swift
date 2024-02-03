//
//  ClubsMainView.swift
//  West High App
//
//  Created by Aiden Lee on 8/7/23.
//

import SwiftUI

struct ClubsMainView: View {
    let selectedclub:club
    @EnvironmentObject var clubsmanager: clubManager
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            if let item = clubsmanager.allclublist.first(where: { $0.documentID == selectedclub.documentID }) {
                ClubsDetailView(currentclub: item)
                    .environmentObject(clubsmanager)
            }
        }
    }

}

#if DEBUG
struct ClubsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsMainView(selectedclub: clubManager().allclublist.first!).environmentObject(UserInfo())
        
    }
}
#endif
