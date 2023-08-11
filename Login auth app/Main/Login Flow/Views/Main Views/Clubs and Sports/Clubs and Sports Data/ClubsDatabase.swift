//
//  File.swift
//  Test1
//
//  Created by Aiden Lee on 6/7/23.
//

import Foundation

final class clubsDatabase {
    private let FAV_KEY = "fav_key2"

    func save(items: Set<Int>) {
        let array = Array(items)
        UserDefaults.standard.set(array, forKey: FAV_KEY)
    }

    func load() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: FAV_KEY) as? [Int] ?? [Int]()
        return Set(array)

    }
}
