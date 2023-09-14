//
//  SchoolPolicyGuideView.swift
//  West App
//
//  Created by Aiden Lee on 5/25/23.
//

import SwiftUI
import Foundation

struct SchoolPolicyGuideView: View {
    @State var isLoading = false
        var body: some View {
            ZStack{
                SwiftUIWebView(url: URL(string:"https://west.madison.k12.wi.us/families/school-policy-guide")!)
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
                
            }.onAppear() {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    
                    isLoading = false
                    
                }
            }
        }
    }

struct SchoolPolicyGuideView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolPolicyGuideView()
    }
}
