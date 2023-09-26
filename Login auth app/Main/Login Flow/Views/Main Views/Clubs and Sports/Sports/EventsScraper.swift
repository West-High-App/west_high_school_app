import Foundation
import SwiftSoup

var events: [ParsedEvent] = []

struct ParsedEvent: Identifiable {
    var date: Date
    var type: String
    var opponent: String
    var location: String
    var comments: String
    let id = UUID()
}

class HTMLParser: ObservableObject {
    
    static func parseEvents(from url: String, completion: @escaping ([ParsedEvent]?, Error?) -> Void) {
        
        fetchHTML(from: url) { result in
            switch result {
            case .success(let html):
                do {
                    let doc = try SwiftSoup.parse(html)
                    
                    // Find the table containing the schedule
                    guard let scheduleTable = try doc.select("table#outer_table").first()
                    else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Table not found"]))
                        return
                    }
                    let tableShell = try scheduleTable.select("tr")
                    
                    let parsedEvents = try convertHtmlToEvents(tableShell: tableShell)
                    completion(parsedEvents, nil)
                    
                } catch {
                    completion(nil, error)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func convertHtmlToEvents(tableShell: Elements) throws -> [ParsedEvent] {
        let enumerated = tableShell.array().enumerated()
        let events = try enumerated.compactMap { index, _ in
            try parsedHtml(index, tableShell: tableShell)
        }
        return events
    }
    
    static func parsedHtml(_ index: Int, tableShell: Elements) throws -> ParsedEvent? {
        guard index != tableShell.count-1 else { return nil }
        let date = try tableShell[index].text()
        let info = try tableShell[index+1].text()
        
        let infoArray = info.components(separatedBy: "  ")
        
        guard htmlStringIsValid(date), htmlStringIsValid(info), infoArray.count >= 4 else { return nil }
        
        let type = infoArray[0]
        let time = infoArray[1].replacingOccurrences(of: "PM", with: " PM").replacingOccurrences(of: "AM", with: " AM")
        let opponent = infoArray[2]
        let location = infoArray[3]
        let comments = infoArray.count == 6 ? infoArray[4] : ""
        
        // convert time and date strings into Swift date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistent parsing
        guard let finalDate = dateFormatter.date(from: "\(date) \(time)") else { return nil }
        print(finalDate)
        
        let event = ParsedEvent(date: finalDate, type: type, opponent: opponent, location: location, comments: comments)
        
        return event
    }
    
    static func htmlStringIsValid(_ string: String) -> Bool {
        let invalidStrings = [
            "",
            " ",
            "Color Key:    Home Away",
            "Madison West Color Key:    Home Away Change View: Day/date Date condensed Month View",
        ]
        let invalidComponents = [
            "Activity Time",
            "Opponent",
            "Location",
            "Comments",
            "Schedule",
            "Type",
            "Time",
            "Change View"
        ]
        return !invalidStrings.contains(string) && !invalidComponents.map({ string.contains($0) }).contains(true)
    }
    
    static func fetchHTML(from urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Create a URL from the given string
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // url session
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        // tell this to get the HTML
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                completion(.success(htmlString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve HTML"])))
            }
        }

        task.resume()
    }
}
