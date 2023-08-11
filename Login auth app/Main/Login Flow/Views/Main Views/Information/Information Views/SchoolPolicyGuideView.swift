//
//  SchoolPolicyGuideView.swift
//  West App
//
//  Created by Aiden Lee on 5/25/23.
//

import SwiftUI

struct SchoolPolicyGuideView: View {
    var body: some View {
        VStack{
            SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/families/school-policy-guide"))
                //.navigationTitle("School Policy Guide")
        }
    }
}

struct SchoolPolicyGuideView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolPolicyGuideView()
    }
}
