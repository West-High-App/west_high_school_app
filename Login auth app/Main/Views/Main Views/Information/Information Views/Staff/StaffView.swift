//
//  StaffView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
// SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/families/menus"))

import SwiftUI

struct StaffView: View {
@State var isLoading = false
    var body: some View {
        ZStack{
            SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/contact-us/")!) //
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
    }
}

struct StaffView_Previews: PreviewProvider {
    static var previews: some View {
        StaffView()
    }
}
