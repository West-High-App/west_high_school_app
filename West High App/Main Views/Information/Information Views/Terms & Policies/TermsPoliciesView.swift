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
        
                List{
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Image(systemName: "lock.shield")
                        Text("Privacy Policy")
                    }
                    .padding(.vertical,10)
                    
                    NavigationLink {
                        PrivacySecurityView()
                    } label: {
                        Image(systemName: "checkmark.circle")
                        Text("Terms of Service")
                    }
                    .padding(.vertical,10)

                }
                .foregroundColor(.black)
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .navigationBarTitle("Terms & Policies")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
