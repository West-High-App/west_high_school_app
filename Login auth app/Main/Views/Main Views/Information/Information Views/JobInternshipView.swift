//
//  JobInternshipView.swift
//  West High
//
//  Created by Aiden Lee on 9/15/23.
//

import SwiftUI

struct JobInternshipView: View {
    
    @ObservedObject var linkManager = LinkManager.shared
    
    var body: some View {
        NavigationView{
            List{
                Link(destination: URL(string: linkManager.linktionary["Food Service"] ?? "https://docs.google.com/document/d/1pAMUB6xT41RtX-FZmkZ4-Ro4S4EvywxR9PFYIHO9H5k/edit")!,
                     label: {
                    HStack{
                        Image(systemName: "fork.knife.circle")
                        Text("Food Service")
                    }
                }
                )
                .padding(.vertical,10)
                
                Link(destination: URL(string: linkManager.linktionary["Grocery"] ?? "https://docs.google.com/document/d/13qSxE_7Frzf6Wi7izKrJbqZVn0gE0FHYYZBNQjy2Pjk/edit")!,
                     label: {
                    HStack{
                        Image(systemName: "cart")
                        Text("Grocery")
                    }
                }
                )
                .padding(.vertical,10)
                
                Link(destination: URL(string: linkManager.linktionary["Retail"] ?? "https://docs.google.com/document/d/1ZCri06kozqMLGUQu3dAKPb4jZHbsNhL1fWlL-EXvGNM/edit")!,
                     label: {
                    HStack{
                        Image(systemName: "tshirt")
                        Text("Retail")
                    }
                }
                )
                .padding(.vertical,10)
            
                
                Link(destination: URL(string: linkManager.linktionary["Internships"] ?? "https://docs.google.com/document/d/1BQ4AG8qmVFGjtENkW0bdTyMYAh_tdYSgSdT3qIRmcw0/edit")!,
                     label: {
                    HStack{
                        Image(systemName: "graduationcap")
                        Text("Internships")
                    }
                }
                )
                .padding(.vertical,10)
                
                Link(destination: URL(string: linkManager.linktionary["Event & Volunteer"] ?? "https://docs.google.com/document/u/1/d/1kj8bxwcxT30sDkN-WjPxmmlCdNthCi-a7I4aeDblXUQ/edit")!,
                     label: {
                    HStack{
                        Image(systemName: "newspaper")
                        Text("Event & Volunteer")
                    }
                }
                )
                .padding(.vertical,10)
                
                Link(destination: URL(string: linkManager.linktionary["Other"] ?? "https://docs.google.com/document/d/1BO9BfYoBtKJkSL--WVvirIgbHB5S1Il1umEWHEsWEz4/edit")!,
                     label: {
                    HStack{
                        Image(systemName: "ellipsis.rectangle")
                        Text("Other")
                    }
                }
                )
                .padding(.vertical,10)
            }
            .foregroundColor(.black)
            .font(.system(size: 22, weight: .medium, design: .rounded))

            
        }
        .navigationBarTitle("Information")
    }
}

struct JobInternshipView_Previews: PreviewProvider {
    static var previews: some View {
        JobInternshipView()
    }
}
