//
//  ClubsMainView.swift
//  West High App
//
//  Created by Aiden Lee on 8/7/23.
//

import SwiftUI

struct ClubsMainView: View {
    var selectedclub:club
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            let currentclub = selectedclub
            ClubsDetailView(currentclub: currentclub, safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
        //.background(.blue)
    }

}

struct ClubsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsMainView(selectedclub: clubManager().allclublist.first!).environmentObject(ClubsHibabi.ClubViewModel()).environmentObject(UserInfo())
        
    }
}
