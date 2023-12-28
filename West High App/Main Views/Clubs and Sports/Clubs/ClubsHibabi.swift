//
//  ClubHibabi.swift
//  West App
//
//  Created by Aiden Lee on 6/7/23.
//

import Foundation
import SwiftUI

extension ClubsHibabi {
    final class ClubViewModel: ObservableObject {

        @Published var clubitems = [club]()
        @Published var clubshowingFavs = false
        @Published var clubsavedItems: Set<Int> = []

        // Filter saved items
        var clubfilteredItems: [club]  {
            if clubshowingFavs == true {
                return clubitems.filter { clubsavedItems.contains($0.id) }
            }
            return clubitems
        }

        private var db = clubsDatabase()

        init() {
            self.clubsavedItems = db.load()
            self.clubitems = clubManager.shared.allclublist
        }

        func clubsortFavs() {
            withAnimation() {
                clubshowingFavs.toggle()
            }
        }

        func clubcontains(_ item: club) -> Bool {
                clubsavedItems.contains(item.id)
            }

        // Toggle saved items
        func clubtoggleFav(item: club) {
            if clubcontains(item) {
                clubsavedItems.remove(item.id)
            } else {
                clubsavedItems.insert(item.id)
            }
            db.save(items: clubsavedItems)
        }
    }
}
