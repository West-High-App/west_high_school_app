import SwiftUI

struct SportEventsAdminView: View {
    var currentsport: String
    @State var eventlist: [sportEvent] = []
    @StateObject var dataManager = sportEventManager()
    @State var temptitle = ""
    @State var isConfirmingDeleteEvent = false
    @State var isPresetingAddEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: sportEvent?
    @State var eventToSave: sportEvent?
    
    @State var title = ""
    @State var subtitle = ""
    @State var date = ""
    
    var body: some View {
        
        VStack {
            Button {
                isPresetingAddEvent = true
            } label: {
                Text("Add Sport Event")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            List {
                ForEach(eventlist) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .fontWeight(.semibold)
                        Text(event.subtitle)
                        Text(event.date)
                    }.contextMenu {
                        Button("Delete", role: .destructive) {
                            temptitle = event.title
                            // isConfirmingDeleteEvent = true
                            eventToDelete = event
                            if let eventToDelete = eventToDelete {
                                dataManager.deleteSportEventNews(forSport: currentsport, sportEvent: eventToDelete)
                            }
                            dataManager.getSportsEvent(forSport: currentsport) { events, error in
                                if let error = error {
                                    print("Error updating events: \(error.localizedDescription)")
                                }
                                if let events = events {
                                    eventlist = events
                                }
                            }
                        }
                    }
                }
            }
        }.navigationTitle("Edit Sport Events")
        .onAppear {
            dataManager.getSportsEvent(forSport: currentsport) { events, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let events = events {
                    eventlist = events
                    print("UPDATED THAT SHIT")
                    print(eventlist)
                }
            }
        }
        .alert(isPresented: $isConfirmingDeleteEvent) {
            Alert(
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the event '\(temptitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let eventToDelete = eventToDelete {
                        dataManager.deleteSportEventNews(forSport: currentsport, sportEvent: eventToDelete)
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .sheet(isPresented: $isPresetingAddEvent) {
            VStack {
                HStack {
                    Button("Cancel") {
                        isPresetingAddEvent = false
                    }.padding()
                    Spacer()
                }
                Form {
                    Section(header: Text("Sports Event details")) {
                        TextField("Title", text: $title)
                        TextField("Subtitle", text: $subtitle)
                        TextField("Date", text: $date)
                    }
                    Button("Publish new sport event") {
                        eventToSave = sportEvent(documentID: "NAN", title: title, subtitle: subtitle, date: date)
                        if let eventToSave = eventToSave {
                            dataManager.createSportEvent(forSport: currentsport, sportEvent: eventToSave)
                            isPresetingAddEvent = false
                            
                        }
                        dataManager.getSportsEvent(forSport: currentsport) { events, error in
                            if let error = error {
                                print("Error updating events: \(error.localizedDescription)")
                            }
                            if let events = events {
                                eventlist = events
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("Edit Sport Events")
            
        }
    
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SportEventsAdminView(currentsport: "Boys Hockey Varsity")
    }
}
