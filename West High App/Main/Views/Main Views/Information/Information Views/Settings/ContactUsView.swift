//
//  ContactUsView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//

import SwiftUI
private func callNumber(phoneNumber:String) {
  if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
    let application:UIApplication = UIApplication.shared
    if (application.canOpenURL(phoneCallURL)) {
        application.open(phoneCallURL, options: [:], completionHandler: nil)
    }
  }
}

struct ContactUsView: View {
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
            VStack(alignment: .leading){
                VStack{
                    VStack{
                        HStack{
                            Text("Contact Us")
                                .foregroundColor(.black)
                                .font(
                                    .custom(
                                        "arial",
                                        fixedSize: 45)
                                    .weight(.bold)
                                )
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        
                    }
                    .padding(.top,50)
                }
                Text("Email or text us for any inquiries, questions, or feedback. Emails may take up to three business days to process, texts may take up to a day. Thank you for your understanding. \n")
                    .padding(.trailing)
                VStack(alignment: .leading){
                    Text("Email : westhighapp@gmail.com")
                    HStack{
                        Text("Phone :")
                            .foregroundColor(.black)
                        Button {
                            callNumber(phoneNumber: "6082509635")
                        } label: {
                            Text("(608) 250-9635")
                            
                        }
                        Spacer()
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.vertical, 7)

                .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                .padding(.trailing,10)

                
            }
            .font(
                .custom(
                    "arial",
                    fixedSize: 18)
                .weight(.regular)
            )
            .padding(.leading)
        }
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}
