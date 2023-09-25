// august made this btich idk the rest of the comments got deleted

import Foundation
import SwiftUI

class SportsEventStorage: ObservableObject {
    
    @Published var sportsevents: [String: [ParsedEvent]] = [:]
    
    static let shared = SportsEventStorage()

}
