//
//  SettingsVIew.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @EnvironmentObject var userInfo: UserInfo

    var body: some View {
        
            VStack{
                List{
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        HStack{
                            Image(systemName: "lock.shield")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("Privacy Policy")
                                .font(.system(size: 24))
                        }
                    }
                    .padding(.vertical,10)
                    
                    NavigationLink {
                        PrivacySecurityView()
                    } label: {
                        HStack{
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 30))
                            Spacer()
                                .frame(width:15)
                            Text("Terms of Service")
                                .font(.system(size: 24))
                        }
                    }
                    .padding(.vertical,15)

                }
                .font(.system(size: 22, weight: .regular, design: .rounded))
            }
            .navigationBarTitle("Terms & Policies")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
