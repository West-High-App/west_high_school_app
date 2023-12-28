//
//  HomeMainView.swift
//  West High App
//

import SwiftUI

struct HomeMainView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            HomeView(safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView().environmentObject(UserInfo())
    }
}
