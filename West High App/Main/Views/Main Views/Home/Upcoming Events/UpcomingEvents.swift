//
//  UpcomingupcomingEvents.swift
//  West App
//
//  Created by Aiden Lee on 5/28/23.
//

import Foundation

class UpcomingupcomingEvents: ObservableObject{
    
    @Published var upcomingEvents = [upcomingEvent]()
    
    init(){
        let pathString = Bundle.main.path(forResource: "data", ofType: "json")
        
        
        if let path = pathString {
            
            
            let url = URL(fileURLWithPath: path)
            
            
            do{
                let data = try Data(contentsOf: url)
                
                
                let decoder = JSONDecoder()
                
                do{
                    let eventData = try decoder.decode([upcomingEvent].self, from: data)
                    
                    for r in eventData{
                        r.id = UUID()
                    }
                    
                    
                    
                    
                    self.upcomingEvents = eventData
                    
                }
                catch{
                    print(error)
                }
                
                
                
            }
            catch{
                print(error)
            }
            
            
            
        }
    }
    
    
}
