//
//  PrivacySecurityView.swift
//  West High App
//
//  Created by Aiden Lee on 8/23/23.
//

import SwiftUI

struct PrivacySecurityView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("By downloading or using the West High App (\"the App\", the \"Service\"), these terms will automatically apply to you – you should therefore make sure that you read them carefully before using the App. You are not allowed to copy or modify the App, any part of the App, or our trademarks in any way. You are not allowed to attempt to extract the source code of the App, and you also may not try to translate the App into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to West High and AndersenLee LLC. \n")
                Text("West High is committed to ensuring that the App is as useful and efficient as possible. For that reason, we reserve the right to make changes to the App or to charge for its services, at any time and for any reason. We will never charge you for the App or its services without making it very clear to you exactly what you are paying for.\n")
                VStack{
                    Text("The App stores and processes personal data that you have provided to us, to provide our Service. It is your responsibility to keep your phone and access to the App secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the App will not work properly or at all.\n")
                    HStack{
                        Text("The App uses third-party services that declare their own Terms and Conditions. Terms and Conditions of third-party service providers used by the App are provided below:\n")
                        Spacer()
                    }
                }
                HStack{
                    Text("[Google Analytics for Firebase](https://www.google.com/analytics/terms/)\n[Firebase Crashlytics](https://firebase.google.com/terms/crashlytics)\n")
                    Spacer()
                }
                HStack{
                    Text("Users will also hold some level of personal responsibility while using the West High app. Any users permitted to edit or post on the West High app will be expected to follow basic guidelines. Disrespectful and harmful behavior while posting will not be tolerated. Any inappropriate posts will be removed and the user will be reprimanded for their actions.\n")
                    Spacer()
                }
                VStack{
                    Text("The usage of the West High App should not interfere with classroom activities during the school day in any sort. Students are expected to be off their phones during the instructional period. Please reference the West Cell Phone Policy for more information. \n")
                    HStack{
                        Text("[West Cell Phone Policy](https://docs.google.com/document/d/1yW5470XYlBNkroQMjA9dGXkDBAhtlHOEbdD_qj_TBac/edit)\n")
                        Spacer()
                    }
                }
                
                VStack{
                    Text("You should be aware that there are certain things that West High will not take responsibility for. Certain functions of the App will require the App to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but West High cannot take responsibility for the App not working at full functionality if you do not have an active internet connection.\n")
                    Text("If you are using the App outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the App, or other third-party charges. In using the App, you are accepting responsibility for any such charges, including roaming data charges if you use the App outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you are using the App, please be aware that we assume that you have received permission from the bill payer for using the App.\n")
                    Text("Along the same lines, West High cannot always take responsibility for the way you use the App i.e. You need to make sure that your device stays charged – if it runs out of battery and you cannot turn it on to avail the Service, West High cannot accept responsibility.\n")
                    Text("With respect to West High’s responsibility for your use of the App, when you are using the App, it is important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. West High accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the App.\n")
                    Text("At some point, we may wish to update the App. The app is currently available on iOS – the requirements for the system (and for any additional systems we decide to extend the availability of the App to) may change, and you will need to download the updates if you want to keep using the App. West High does not promise that it will always update the App so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you promise to always accept updates to the Application when offered to you, We may also wish to stop providing the App, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the App, and (if needed) delete it from your device.\n")
                    HStack{
                        Text("**Changes to This Terms and Conditions**")
                        Spacer()
                    }
                    Text("We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page.")
                    HStack{
                        Text("These terms and conditions are effective as of 2024-02-03.\n")
                        Spacer()
                    }
                    HStack{
                        Text("**Contact Us**")
                        Spacer()
                    }
                    HStack{
                        Text("If you have any questions or suggestions about our Terms and Conditions, contact us at westhighapp@gmail.com.\n")
                        Spacer()
                    }
                }
            }.padding(.horizontal)
        }
        .foregroundColor(.black)
        .font(.system(size: 17, weight: .regular, design: .rounded))
        .navigationTitle("Terms of Service")
    }
}

struct PrivacySecurityView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySecurityView()
    }
}
