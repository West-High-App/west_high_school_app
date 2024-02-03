//
//  HelpSupportView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//


import SwiftUI

struct HelpSupportView: View {
    var body: some View {
            List{
                DisclosureGroup("FAQs"){
                    VStack(alignment:.leading){
                        VStack(alignment: .leading){
                            HStack{
                                Text("**Who can edit content on the app?**")
                                Spacer()
                            }
                            Text("Only verified users and administrators can edit content inside the app. Certain student leaders also may have access to editing the app, this includes chosen members of sports teams and chosen members of clubs. Club captains and Sports team captains are able to add events and edit the homepage of their respective club or sport.\n")
                            
                            HStack{
                                Text("**Who writes the news articles?**")
                                Spacer()
                            }
                            Text("The articles shown in the student spotlight as well as the sports and club news are written by the Regent Review. If you are interested in helping out or have an article suggestion, join the Regent Review!\n")
                            
                            HStack{
                                Text("**Who maintains the app?**")
                                Spacer()
                            }
                            Text("Student Council helps maintain the West High app, if you are interested feel free to join Student Council (more info under 'Clubs'). If you have any suggestions or improvements, contact us at westhighapp@gmail.com.")
                        }
                    }.font(.system(size: 17, weight: .regular   , design: .rounded))
                    .accentColor(.accentColor)
                }
                .padding(.vertical,10)
                
                DisclosureGroup("Logging in"){
                    VStack(alignment:.leading){
                        HStack{
                            Text("**Why should I log in?**")
                            Spacer()
                        }
                        Text("Logging in with your MMSD email allows access to certain features, such as club rosters, that are otherwise hidden. Logging in also enables you to save sports and clubs to the 'Favorites' tab, so they are always easily accessible. If you do not want to log in, you can always continue as a guest.\n")
                        
                        HStack{
                            Text("**What is logging in as a guest?**")
                            Spacer()
                        }
                        Text("Logging in as a guest will allow you to enter the app without logging in with an email. Logging in as a guest will restrict you from certain features of the app, as well as editing or adding content to the app. You will also not be able to save favorite clubs or sports.")
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                        .accentColor(.accentColor)
                }
                .padding(.vertical,10)
                
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
                            Text("Other questions and concerns can be emailed to westhighapp@gmail.com, emails may take up to three business days to process. Thank you for your patience.")
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                        .accentColor(.accentColor)
                }
                .padding(.vertical,10)
            }
            .foregroundColor(.black)
            .font(.system(size: 22, weight: .medium, design: .rounded))
            .navigationTitle("Help & Support")
            .accentColor(.gray)
    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}
