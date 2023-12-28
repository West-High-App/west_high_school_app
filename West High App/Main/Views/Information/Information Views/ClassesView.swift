//
//  ClassesView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI

import SwiftUI
import Foundation

struct ClassesView: View {
    @State var isLoading = false
        var body: some View {
            ZStack{
                SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/students/west-high-school-course-catalog/course-catalog-article/all-courses")!)
                                
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

struct ClassesView_Previews: PreviewProvider {
    static var previews: some View {
        ClassesView()
    }
}
