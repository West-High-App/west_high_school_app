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
                HStack{
                    Text("Terms & Conditions")
                        .foregroundColor(.black)
                        .font(
                            .custom(
                                "arial",
                                fixedSize: 30)
                            .weight(.bold)
                        )
                        .padding(.vertical, 10)
                    Spacer()

                    Spacer()
                }
                Text("By downloading or using this app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You are not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You are not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to West High. \n")
                Text("West High is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you are paying for.\n")
                VStack{
                    Text("The West High App app stores and processes personal data that you have provided to us, to provide our Service. It is your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the West High App app will not work properly or at all.\n")
                    HStack{
                        Text("The app does use third-party services that declare their Terms and Conditions. Link to Terms and Conditions of third-party service providers used by the app:\n")
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
                    Text("You should be aware that there are certain things that West High will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but West High cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\n")
                    Text("If you are using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you are accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you are using the app, please be aware that we assume that you have received permission from the bill payer for using the app.\n")
                    Text("Along the same lines, West High cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you cannot turn it on to avail the Service, West High cannot accept responsibility.\n")
                    Text("With respect to West High’s responsibility for your use of the app, when you are using the app, it is important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. West High accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.\n")
                    Text("At some point, we may wish to update the app. The app is currently available on iOS – the requirements for the system (and for any additional systems we decide to extend the availability of the app to) may change, and you will need to download the updates if you want to keep using the app. West High does not promise that it will always update the app so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.\n")
                    HStack{
                        Text("**Changes to This Terms and Conditions**")
                        Spacer()
                    }
                    Text("We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page.")
                    HStack{
                        Text("These terms and conditions are effective as of 2023-09-11\n")
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
            }
            .padding(.vertical, -50)
            .padding(.horizontal,10)
        }
    }
}

struct PrivacySecurityView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySecurityView()
    }
}
