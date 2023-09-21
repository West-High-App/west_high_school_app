//
//  uitestview.swift
//  West High
//
//  Created by August Andersen on 20/09/2023.
//

import SwiftUI

struct uitestview: View {
    
    let events: [sportEvent] = [sportEvent(documentID: "", title: "West vs. Memorial", subtitle: "8:00 PM @ Memorial", month: "Jan", day: "9", year: "2023", publisheddate: "Jan 9 2023", isSpecial: false, score: [7, 63], isUpdated: true), sportEvent(documentID: "", title: "West vs. Verona", subtitle: "9:00 PM @ West", month: "Oct", day: "28", year: "2023", publisheddate: "Oct 28 2023", isSpecial: false, score: [38, 33], isUpdated: true), sportEvent(documentID: "", title: "West vs. Jefferson High", subtitle: "8:00 PM @ Middleton", month: "Sep", day: "19", year: "2023", publisheddate: "Sep 19 2023", isSpecial: true, score: [], isUpdated: true)]
    
    var body: some View {
        
        
                List {
                    ForEach(events, id: \.id) {event in
                        VStack {
                            
                            HStack {
                                Spacer()
                                Text(event.title)
                                    .font(.system(size: 22, weight: .semibold, design: .rounded)) // semibold
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Text("\(event.month) \(event.day), \(event.year)")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                Spacer()
                            }
                            
                            if !event.isSpecial {
                                HStack {
                                    if event.score.count > 1 {
                                        if event.score[0] > event.score[1] {
                                            HStack {
                                                HStack {
                                                    Spacer()
                                                    Spacer()
                                                    Spacer()
                                                }
                                                Text(String(event.score[0]))
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                Spacer()
                                                Text("-")
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                Spacer()
                                                Text(String(event.score[1]))
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                HStack {
                                                    Spacer()
                                                    Spacer()
                                                    Spacer()
                                                }
                                            }.foregroundColor(.green)
                                        } else if event.score[0] != event.score[1] {
                                            HStack {
                                                HStack {
                                                    Spacer()
                                                    Spacer()
                                                    Spacer()
                                                }
                                                Text(String(event.score[0]))
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                Spacer()
                                                Text("-")
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                Spacer()
                                                Text(String(event.score[1]))
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                HStack {
                                                    Spacer()
                                                    Spacer()
                                                    Spacer()
                                                }
                                            }.foregroundColor(.red)
                                        } else {
                                            HStack {
                                                HStack {
                                                    Spacer()
                                                    Spacer()
                                                    Spacer()
                                                }
                                                Text(String(event.score[0]))
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                Spacer()
                                                Text("-")
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                Spacer()
                                                Text(String(event.score[1]))
                                                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                                                HStack {
                                                    Spacer()
                                                    Spacer()
                                                    Spacer()
                                                }
                                            }
                                        }
                                    } else {
                                        Text("No score.")
                                            .font(.system(size: 16, weight: .regular, design: .rounded))
                                    }
                                }
                            } else {
                                Text(event.subtitle)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .padding(1)
                            }
                        }
                    }.listRowSeparator(.visible, edges: .all)
                }.frame(height: 450)
            }
}

struct uitestview_Previews: PreviewProvider {
    static var previews: some View {
        uitestview()
    }
}
