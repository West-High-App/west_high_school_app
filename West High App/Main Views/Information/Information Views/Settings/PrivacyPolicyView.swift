//
//  PrivacyPolicyView.swift
//  West High App
//
//  Created by Aiden Lee on 8/31/23.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView{
                VStack{
                    VStack(alignment: .leading){
                        Text("West High built the West High App app as a free app. The West High App (\"the App\" or the \"Service\") is provided by West High at no cost and is intended for use as is.\n")
                        Text("This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decides to use our Service.\n")
                        Text("If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n")
                        Text("The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at West High App unless otherwise defined in this Privacy Policy.\n")
                        HStack{
                            Text("**Information Collection and Use**")
                            Spacer()
                        }
                        Text("For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to your name and email. The information that we request will be retained by us and used as described in this privacy policy.")
                        Text("The App uses third-party services that may collect information used to identify you.")
                        Text("Privacy Policies of third-party service providers used by the App are provided below:\n")
                    }
                    VStack(alignment: .leading){
                        Text("[Google Analytics for Firebase](https://www.google.com/analytics/terms/)\n")
                        Text("[Firebase Crashlytics](https://firebase.google.com/terms/crashlytics)\n")
                        Text("**Log Data**")
                        Text("We want to inform you that whenever you use our Service, in a case of an error in the App we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the App when utilizing our Service, the time and date of your use of the Service, and other statistics.\n")
                        Text("**Cookies**")
                        Text("Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.")
                        Text("This Service does not use these “cookies” explicitly. However, the App may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.\n")
                    }
                    VStack(alignment: .leading){
                        Text("**Service Providers**")
                        Text("We may employ third-party companies and individuals due to the following reasons:")
                        Text("To facilitate our Service")
                        Text("To provide the Service on our behalf")
                        Text("To perform Service-related services")
                        Text("We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.\n")
                        Text("**Security**")
                        Text("We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is fully secure and reliable, therefore we cannot guarantee its absolute security.\n")
                    }
                    VStack(alignment: .leading){
                        Text("**Links to Other Sites**")
                        Text("This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.\n")
                        Text("**Children’s Privacy**")
                        Text("These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.\n")
                        Text("**Changes to This Privacy Policy**")
                        Text("We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.")
                        Text("This policy is effective as of 2024-02-03\n")
                        Text("**Contact Us**")
                        Text("If you have any questions or suggestions about our Privacy Policy, contact us at westhighapp@gmail.com.\n")
                    }
                }
                .padding(.horizontal)
        }
        .foregroundColor(.black)
        .font(.system(size: 17, weight: .regular, design: .rounded))
        .navigationTitle("Privacy Policy")

    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
