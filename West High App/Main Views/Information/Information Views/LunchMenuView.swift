//
//  SchoolLunchMenuView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI
import Foundation

struct LunchMenuView: View {
    @State var isLoading = false
        var body: some View {
            ZStack {
                SwiftUIWebView(url: URL(string: "https://west.madison.k12.wi.us/families/menus/")) // https://west.madison.k12.wi.us/families/menus
                                //
                if isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            Spacer()
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

struct LunchMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LunchMenuView()
    }
}
