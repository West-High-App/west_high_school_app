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
    
    private static func getDate(_ index: Int, tableShell: Elements) throws -> String? {
        guard index >= 0 else {
            return nil
        }
        let text = try tableShell[index].text()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistent parsing
        guard dateFormatter.date(from: "\(text)") != nil else {
            if htmlStringIsValidIncludingEmptyString(text) {
                return try getDate(index-1, tableShell: tableShell)
            } else {
                return nil
            }
        }
        
        return text
    }
    
    static func parsedHtml(_ index: Int, tableShell: Elements) throws -> ParsedEvent? {
        guard index != tableShell.count-1, let date = try getDate(index, tableShell: tableShell) else {
            return nil
        }
        let info = try tableShell[index+1].text()
        let infoHtml = try tableShell[index+1].html()
        
        let infoArray = info.components(separatedBy: "  ")
        
        guard htmlStringIsValid(date), htmlStringIsValid(info), infoArray.count >= 3, !infoHtml.contains("</strike>") else { return nil }
        
        let isOffset = (infoArray[0].contains("AM") || infoArray[0].contains("PM"))
        
        let type = isOffset ? "\(infoArray[0].dropLast(7))" : infoArray[0]
        let time = (isOffset ? "\(infoArray[0].dropFirst(type.count))": infoArray[1]).replacingOccurrences(of: "PM", with: " PM").replacingOccurrences(of: "AM", with: " AM")
        let opponent = isOffset ? infoArray[1] : infoArray[2]
        let location = isOffset ? infoArray[2] : infoArray[3]
        let comments = infoArray.count == 6 ? (isOffset ? infoArray[3] : infoArray[4]) : infoArray.last ?? ""
        
        // convert time and date strings into Swift date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistent parsing
        dateFormatter.timeZone = TimeZone(identifier: "America/Chicago")
        guard let finalDate = dateFormatter.date(from: "\(date) \(time)") else { return nil }
        
        let event = ParsedEvent(date: finalDate, type: type, opponent: opponent, location: location, comments: comments)
        
        return event
    }
    
    private static func htmlStringIsValid(_ string: String) -> Bool {
        guard !string.isEmpty else { return false }
        return htmlStringIsValidIncludingEmptyString(string)
    }
    
    private static func htmlStringIsValidIncludingEmptyString(_ string: String) -> Bool {
        let invalidStrings = [
            " ",
            "Color Key:    Home Away",
            "Madison West Color Key:    Home Away Change View: Day/date Date condensed Month View",
            "Change View: Day/date Date condensed Month View"
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
