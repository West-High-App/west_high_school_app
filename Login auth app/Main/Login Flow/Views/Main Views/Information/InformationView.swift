//
//  ProfileView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
            NavigationView{
                List{
                    NavigationLink {
                        LunchMenuView()
                    } label: {
                        Image(systemName: "fork.knife.circle")
                        Text("School Lunch Menu")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        StaffView()
                    } label: {
                        Image(systemName: "person")
                        Text("School Staff")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        SocialView()
                    } label: {
                        Image(systemName: "network")
                        Text("School Socials")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        ClassesView()
                    } label: {
                        Image(systemName: "menucard")
                        Text("Avaliable Classes")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        ContactView()
                    } label: {
                        Image(systemName: "phone")
                        Text("Contact Us")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        NavigatingSchoolView()
                    } label: {
                        Image(systemName: "map")
                        Text("Navigating the School")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        MentalHealthView()
                    } label: {
                        Image(systemName: "heart")
                        Text("Mental Health Resources")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        SchoolPolicyGuideView()
                    } label: {
                        HStack{
                            Image(systemName: "book.closed")
                                .padding(.leading,3)
                            Text("School Policy Guide")
                                .padding(.leading,3)
                        }
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        TransportationView()
                    } label: {
                        Image(systemName: "bus.fill")
                        Text("Transportation")
                    }
                    .padding(.vertical,10)
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .padding(.vertical,10)
                }
                .font(.system(size: 22, weight: .regular, design: .rounded))
                .navigationBarTitle("Information")
            }
        
    }
}
    

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
    
