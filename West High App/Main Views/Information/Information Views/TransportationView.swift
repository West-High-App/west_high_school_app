//
//  TransportationView.swift
//  West App
//
//  Created by Aiden Lee on 5/25/23.
//

import SwiftUI

struct TransportationView: View {
    var body: some View {
        ZStack{
            SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/families/bus-routes")!)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransportationView_Previews: PreviewProvider {
    static var previews: some View {
        TransportationView()
    }
}
