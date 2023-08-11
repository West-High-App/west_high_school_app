//
//  ClassesView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI

struct ClassesView: View {
    var body: some View {
        VStack{
            SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/students/west-high-school-course-catalog/course-catalog-article/all-courses"))
        }
    }
}

struct ClassesView_Previews: PreviewProvider {
    static var previews: some View {
        ClassesView()
    }
}
