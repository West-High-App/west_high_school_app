//
//  MentalHealthViews.swift
//  West App
//
//  Created by Aiden Lee on 5/25/23.
//

import SwiftUI

struct MentalHealthView: View {
    var body: some View {
        ScrollView{
            ZStack{
                ZStack{
                    Rectangle()
                        .frame(height: 60)
                        .foregroundColor(Color(red: 41/255, green: 51/255, blue:145/255))
                    HStack{
                        Text("WEST HIGH SCHOOL")
                            .padding(.leading,25)
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
                        .frame(height:40)
                        .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                        .offset(y:50)
                    HStack{
                        Image("MMSD Logo")
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
                    .padding(.leading)
                }
            }
            VStack{
                VStack{
                    HStack{
                        Text("Mental Health & Wellness Resources")
                            .foregroundColor(.black)
                            .font(
                                .custom(
                                    "arial",
                                    fixedSize: 45)
                                .weight(.bold)
                            )
//                            .padding(.trailing, 25)
                    }
                    Image("stones")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()
                    
                }
                    .padding(.vertical,20)
                HStack{
                    Text("Make schools safer and healthier by improving access to mental health and wellness resources.")
                        .font(
                            .custom(
                                "Arial",
                                fixedSize: 22)
                            .weight(.semibold)
                        )
                        .foregroundColor(Color(red: 48/255, green: 60/255, blue: 149/255))
                    Spacer()
                }
                .padding(.leading,7)
                .padding(.bottom,10)
                VStack{
                    Text("""
Use the filter below to sort resources available based on what you need. These resources are a starting point for learning about mental health and wellness.

If you're in crisis, please check the crisis line information below to speak to someone and get support. For other requests please contact your school via their [directory](https://www.madison.k12.wi.us/contact-us).
""")
                    .foregroundColor(Color(red: 148/255, green: 148/255, blue: 148/255))
                    .padding(.leading,7)
                    .padding(.bottom, 5)
                    
                
                }
            }
            .padding(.top,40)
            .padding(.bottom,60)
            VStack(alignment: .leading, spacing:10){
                Text("Crisis Lines")
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 24)
                        .weight(.semibold)
                    )
                HStack{
                    Image(systemName: "phone")
                    Text("Text \(Text("[HOPELINE](https://www.centerforsuicideawareness.org)").underline()): to 741741")
                            .tint(.white)
                }
                HStack{
                    Image(systemName: "phone")
                    Text("\(Text("[Suicide Prevention Lifeline](https://www.samhsa.gov/find-help/disaster-distress-helpline)").underline()):\n608-280-2600 or 988")
                            .tint(.white)
                }
                HStack{
                    Image(systemName: "phone")
                    Text("\(Text("[Briarpatch Helpline](https://youthsos.org/contact-us)").underline()): 1-800-798-1126")
                            .tint(.white)
                    //Text("Briarpatch Helpline: 1-800-798-1126")
                }
                HStack{
                    Image(systemName: "phone")
                    Text("\(Text("[Trevor Lifeline](                https://www.thetrevorproject.org)").underline()) for LGBTQ+: 1-866-488-7386 or \(Text("[click here](     https://www.thetrevorproject.org/contact-us/)").underline()) for Trevor Text & Trevor Chat")
                            .tint(.white)
                    //Text("Trevor Lifeline for LGBTQ+: 1-866-488-7386 \nor click here for Trevor Text & Trevor Chat")
                }
                HStack{
                    Image(systemName: "phone")
                    Text("\(Text("[24/7 SAMHSA Disaster Distress Helpline](https://www.samhsa.gov/find-help/disaster-distress-helpline)").underline()): 1-800-985-5990")
                            .tint(.white)
                    //Text("24/7 SAMHSA Disaster Distress Helpline:  1-800-985-5990")
                }
                HStack{
                    Image(systemName: "phone")
                    Text("\(Text("[24/7 Parental Stress Line](https://www.parentshelpingparents.org/stressline)").underline()): 1-800-632-8188")
                            .tint(.white)
                }
                HStack{
                    Image(systemName: "phone")
                    Text("\(Text("[Domestic Abuse Intervention Help Line](https://abuseintervention.org/help/help-overview/)").underline()): 608-251-4445 or 800-747-4045 \nIf you are in immediate danger, call 911.")
                            .tint(.white)
                            .padding(.bottom,10)
                }
            }
            //41,52,145
            .padding(10)
            .foregroundColor(Color(red: 253/255, green: 253/255, blue: 254/255))
            .background(Color(red: 41/255, green: 52/255, blue: 145/255))
            .cornerRadius(10)
            .scaleEffect(1)
            
            
            VStack(alignment: .leading, spacing:10){
                Text("Contact Social Workers")
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 24)
                        .weight(.semibold)
                    )
                Text("Eve Bertrand (Ash & Highland)\nCall or text (Google Voice #): ‪(608) 571-7106‬\n\(Text("embertrand@madison.k12.wi.us").underline())")
                Text("Shari Weinstein (Van Hise)\n Google Voice Phone Number: ‪(608) 501-3480‬\n\(Text("embertrand@madison.k12.wi.us").underline())")
                Text("Leslie Winston (Regent & ELL)\nGoogle Voice Phone Number: (608) 509-4462\n\(Text("lswinston@madison.k12.wi.us").underline())")

            }
            .tint(.white)
            //41,52,145
            .padding(10)
            .foregroundColor(Color(red: 253/255, green: 253/255, blue: 254/255))
            .background(Color(red: 41/255, green: 52/255, blue: 145/255))
            .cornerRadius(10)
            .scaleEffect(1)
            
            VStack(alignment: .leading, spacing:10){
                Text("Contact Psychologists")
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 24)
                        .weight(.semibold)
                    )


                Text("Brooke Gard (Regent & Highland SLC)\nGoogle Voice: 608-620-3248\n\(Text("bbgard@madison.k12.wi.us").underline())")
                Text("Joel Porter (Ash SLC)\n West Office Phone: 608-204-3074\n\(Text("jsporter@madison.k12.wi.us").underline())")
                Text("Julianne Zygmunt (Van Hise & Highland)\nGoogle Voice: (608)571-6828\n\(Text("jmdileo@madison.k12.wi.us").underline())")

            }
            .tint(.white)
            //41,52,145
            .padding(10)
            .foregroundColor(Color(red: 253/255, green: 253/255, blue: 254/255))
            .background(Color(red: 41/255, green: 52/255, blue: 145/255))
            .cornerRadius(10)
            .scaleEffect(1)
        }.padding(.top, -1) // new code
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct MentalHealthView_Previews: PreviewProvider {
    static var previews: some View {
        MentalHealthView()
    }
}
