//
//  LoggedInView.swift
//  Login auth app
//
//  Created by August Andersen on 6/3/23.
//

import SwiftUI
import Firebase

struct LoggedInView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {

            List(dataManager.events, id: \.id) { event in
                Text(event.title)
            }
            .navigationTitle("Upcoming Events")
        }
        
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
            .environmentObject(DataManager())
    }
}
