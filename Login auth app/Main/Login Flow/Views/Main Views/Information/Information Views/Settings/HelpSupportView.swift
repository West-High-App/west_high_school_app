//
//  HelpSupportView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//

import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        let screenSize: CGRect = UIScreen.main.bounds
        ScrollView(showsIndicators: false){
            ZStack{
                ZStack{
                    Rectangle()
                        .frame(width: screenSize.width, height: 60)
                        .foregroundColor(Color(red: 41/255, green: 51/255, blue:145/255))
                    HStack{
                        Text("WEST HIGH SCHOOL")
                            .padding(.leading, 15)
                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
                            .font(
                                .custom(
                                    "Devanagari Sangam MN",
                                    fixedSize: 13.4)
                                .weight(.semibold)
                            )
                        Spacer()
                    }
                    
                }
                ZStack{
                    Rectangle()
                        .frame(width:screenSize.width, height:40)
                        .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                        .offset(y:50)
                    HStack{
                        Image("mmsd")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20)
                            .offset(y:50)

                        
                        Text("MADISON METROPOLITAN SCHOOL DISTRICT")
                            .font(
                                .custom(
                                    "Devanagari Sangam MN",
                                    fixedSize: 11)
                            )
                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
                            .offset(y:50)
                        Spacer()
                    }
                    .padding(.leading,15)
                }
            }
            VStack{
                VStack{
                    HStack{
                        Text("Help & Support")
                            .foregroundColor(.black)
                            .font(
                                .custom(
                                    "arial",
                                    fixedSize: 45)
                                .weight(.bold)
                            )
                            .padding(.bottom, 10)
                            .padding(.leading,10)
                        Spacer()
                    }
                    
                }
                .padding(.vertical,50)
            }
            .padding(.top, 30)
            .padding(.bottom, -30)

            
            VStack{
                DisclosureGroup("FAQs"){
                    VStack(alignment:.leading){
                        VStack(alignment: .leading){
                            HStack{
                                Text("**Who can edit content on the app?**")
                                Spacer()
                            }
                            Text("Only verified users and administrators can edit content inside the app. Certain student leaders also may have access to editing the app, this includes chosen members of sports teams and chosen members of clubs.\n")
                            
                            HStack{
                                Text("**Who writes the articles?**")
                                Spacer()
                            }
                            Text("The articles shown in the student spotlight as well as the sports and club news are written by the Regent Reporter.\n")
                            
                            HStack{
                                Text("**How can I help with the app?**")
                                Spacer()
                            }
                            Text("Student Council helps maintain the West High app, if you are interested in joining visit room 1209 during lunch! If you have any suggestions or improvements, contact us at westhighapp@gmail.com.\n")
                        }
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.vertical, 10.0)
                }
                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                
                
                
                DisclosureGroup("Logging in"){
                    VStack(alignment:.leading){
                        HStack{
                            Text("**Why can't I log in with gmail?**")
                            Spacer()
                        }
                        Text("Only email accounts with the MMSD email domain (@madison.k12.wi.us) will be able to log in, this is to maximize the security of our students.\n")
                        
                        HStack{
                            Text("**What is logging in as a guest?**")
                            Spacer()
                        }
                        Text("Logging in as a guest will allow you to enter the app without logging in with an MMSD email, logging in as a guest will restrict you from viewing sensitive information, such as any news articles or details to clubs and sports.\n")
                    }
                    
                    
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )

                }
                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
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
                                Text("Please report any bugs or issue to WestHighApp@gmail.com, if possible please include a screenshot of the issue as well a description. Thank you for you cooperation!\n")
                                Spacer()
                            }
                            HStack{
                                Text("**Additional Questions**")
                                Spacer()
                            }
                            Text("Other questions and concerns can be emailed to WestHighApp@gmail.com, emails may take one to three business days to process. Thank you for your patience.")
                        }
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.vertical, 10.0)
                }
                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
            }
            
            .padding(.horizontal, 5)
            
        }

    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}
