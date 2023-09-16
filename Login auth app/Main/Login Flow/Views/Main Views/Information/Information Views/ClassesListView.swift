//
//  ClassesListView.swift
//  West High
//
//  Created by Aiden Lee on 9/15/23.
//

import SwiftUI

struct ClassesListView: View {
    var body: some View {
        List{
            NavigationLink {
                ClassesView()
            } label: {
                Image(systemName: "menucard")
                Text("West Course Catalog")
            }
            .padding(.vertical,10)
            
            Link(destination: URL(string: "https://www.madison.k12.wi.us/secondary-programs-and-personalized-pathways/supplementary-online-learning/mvc-online-courses")!,
                 label: {
                HStack{
                    Image(systemName: "laptopcomputer")
                    Text("Madison Virtual Courses")
                }
                
            }
            
            )
            .padding(.vertical,10)
            
            
            Link(destination: URL(string: "https://www.madison.k12.wi.us/secondary-programs/graduation-requirements")!,
                 label: {
                HStack{
                    Image(systemName: "graduationcap.fill")
                    Text("Graduation Requirements")

                }
                
            }
            
            )
            .padding(.vertical,10)
        
            Link(destination: URL(string: "https://www.madison.k12.wi.us/secondary-programs-and-personalized-pathways/early-college-opportunities")!,
                 label: {
                HStack{
                    Image(systemName: "building.columns.fill")
                    Text("Early College Opportunities")

                }
                
            }
            
            )
            .padding(.vertical,10)
            
            Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeAJk_GoyWehwjoM7uOcL3kNRFOXJVCVwgv7wHjHov0RvH7eA/viewform")!,
                 label: {
                HStack{
                    Image(systemName: "list.clipboard")
                    Text("Tutor Request Form")

                }
                
            }
            
            )
            .padding(.vertical,10)
            
            Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfP6izMsXN0DWDamf5VYT7zRaf5JaQnGpvyZgezv7GqgrEjIA/viewform")!,
                 label: {
                HStack{
                    Image(systemName: "list.clipboard")
                    Text("Tutor Volunteer Form")

                }
                
            }
            
            )
            .padding(.vertical,10)
            
            
            
        }
        .navigationTitle("Courses")
        .foregroundColor(.black)
        .font(.system(size: 22, weight: .medium, design: .rounded))
    }
}

struct ClassesListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassesListView()
    }
}
