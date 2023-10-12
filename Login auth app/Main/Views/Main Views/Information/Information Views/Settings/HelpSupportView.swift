//
//  HelpSupportView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//

import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        ScrollView{
            VStack{
                DisclosureGroup("FAQs"){
                    VStack(alignment:.leading){
                        VStack(alignment: .leading){
                            HStack{
                                Text("**Who can edit content on the app?**")
                                Spacer()
                            }
                            Text("Only verified users and administrators can edit content inside the app. Certain student leaders also may have access to editing the app, this includes chosen members of sports teams and chosen members of clubs. Club captains and Sports team captains are able to add events and edit the homepage of their respective club & sport.\n")
                            
                            HStack{
                                Text("**Who writes the news articles?**")
                                Spacer()
                            }
                            Text("The articles shown in the student spotlight as well as the sports and club news are written by the Regent Review. If you are interested in helping out or have an article suggestion, join the Regent Review!\n")
                            
                            HStack{
                                Text("**How can I help with developing the app?**")
                                Spacer()
                            }
                            Text("Student Council helps maintain the West High app, if you are interested feel free to join Student Council. If you have any suggestions or improvements, contact us at westhighapp@gmail.com.\n")
                        }
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))

                    .foregroundColor(.black)
                    .padding(.vertical, 10.0)
                }
                .font(.system(size: 17, weight: .semibold, design: .rounded))

                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                
                
                
                DisclosureGroup("Logging in"){
                    VStack(alignment:.leading){
                        HStack{
                            Text("**Why can't I log in with my school email?**")
                            Spacer()
                        }
                        Text("Email accounts with the MMSD email domain (@madison.k12.wi.us) will not be able to log in because the app hasn't gotten reviewed by MMSD yet. Lets get this app to MMSD!\n")
                        
                        HStack{
                            Text("**What is logging in as a guest?**")
                            Spacer()
                        }
                        Text("Logging in as a guest will allow you to enter the app without logging in with an email, logging in as a guest will restrict you from editing or adding content onto the app. You willl also not be able to save favorite clubs or sports.\n")
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))

                    .foregroundColor(.black)
                    .padding(.vertical, 10.0)

                }
                .font(.system(size: 17, weight: .semibold, design: .rounded))

                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                
                
                
                DisclosureGroup("Other Issues"){
                    VStack(alignment:.leading){
                        VStack(alignment: .leading){
                            HStack{
                                Text("**Reporting Bugs**")
                                Spacer()
                            }
                            HStack{
                                Text("Please report any bugs or issue to westhighapp@gmail.com, if possible please include a screenshot of the issue as well a description. Thank you for you cooperation!\n")
                                Spacer()
                            }
                            HStack{
                                Text("**Additional Questions**")
                                Spacer()
                            }
                            Text("Other questions and concerns can be emailed to WestHighApp@gmail.com, emails may take one to three business days to process. Thank you for your patience.")
                        }
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))

                    .foregroundColor(.black)
                    .padding(.vertical, 10.0)
                }
                .font(.system(size: 17, weight: .semibold, design: .rounded))

                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
            }
            
            .padding(.horizontal, 5)
            
        }.navigationTitle("Help & Support")

    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}
