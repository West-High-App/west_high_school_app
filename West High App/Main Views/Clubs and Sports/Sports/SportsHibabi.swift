//
//  SportsHibabi.swift
//  West App
//
//  Created by August Andersen on 6/7/23.
//
/*
import Foundation
import SwiftUI

extension SportsHibabi {
    final class ViewModel: ObservableObject {
        @State var items = [sport]()
        @Published var showingFavs = false
        @Published var savedItems: Set<Int> = []
        var sportmanager = sportsManager.shared

        // Filter saved items
        var filteredItems: [sport]  {
            if showingFavs == true {
                return items.filter { savedItems.contains($0.id) }
            }
            return items
        }

        private var db = sportsDatabase()

        init() {
            self.savedItems = db.load()
            self.items = self.sportmanager.allsportlist
        }

        func sortFavs() {
            withAnimation() {
                showingFavs.toggle()
            }
        }

        func contains(_ item: sport) -> Bool {
                savedItems.contains(item.id)
            }

        // Toggle saved items
        func toggleFav(item: sport) {
            if contains(item) {
                savedItems.remove(item.id)
            } else {
                savedItems.insert(item.id)
            }
            db.save(items: savedItems)
        }
    }
}
*/
