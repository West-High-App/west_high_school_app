//
//  StaffView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI

struct StaffView: View {

    var body: some View {
        VStack{
            SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/contact-us"))
                // uuhhhh
        }
    }
}

struct StaffView_Previews: PreviewProvider {
    static var previews: some View {
        StaffView()
    }
}
