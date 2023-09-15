import SwiftUI

struct LinkTextView: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(parseText(text), id: \.self) { item in
                if let url = URL(string: item), item.hasPrefix("http") || item.hasPrefix("https") {
                    Link(destination: url) {
                        Text(item)
                            .lineLimit(1)
                            .foregroundColor(.blue)
                        }
                } else {
                    Text(item)
                }
            }
        }
    }
    
    func parseText(_ text: String) -> [String] {
        var components: [String] = []
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        var currentIndex = text.startIndex
        for match in matches ?? [] {
            if let range = Range(match.range, in: text) {
                let prefix = String(text[currentIndex..<range.lowerBound])
                if !prefix.isEmpty {
                    for item in prefix.components(separatedBy: "  ") {
                        print("prefix item:")
                        var newitem = item
                        if newitem.starts(with: " ") {
                            newitem.removeFirst()
                        }
                        print(newitem)
                        components.append(newitem)
                    }
                }
                components.append(String(text[range]))
                currentIndex = range.upperBound
            }
        }
        
        let remainder = String(text[currentIndex...])
        if !remainder.isEmpty {
            for item in remainder.components(separatedBy: "  ") {
                print("remainder item")
                var newitem = item
                if newitem.starts(with: " ") {
                    newitem.removeFirst()
                }
                print(newitem)
                components.append(newitem)
            }
        }
        
        return components
    }
}
