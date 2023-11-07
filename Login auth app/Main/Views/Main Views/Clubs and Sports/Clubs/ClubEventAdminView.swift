// MARK: Aiden this is what is was tryna do
//
//
//


import SwiftUI

struct ClubsEventsAdminView: View {
    var currentclub: club
    var admin: Bool
    @State var eventlist: [clubEvent] = []
    @StateObject var dataManager = clubEventManager.shared
    @State var temptitle = ""
    @State var isConfirmingDeleteEvent = false
    @State var isPresetingAddEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: clubEvent?
    @State var eventToSave: clubEvent?
    @State var editingeventslist: [clubEvent] = []
    @State var screen = ScreenSize()
        
    @State var selectedevent = 0
    @State var selectedtime = 0
    
    var typelist = ["Meeting", "Mandatory Meeting", "Competition", "Special Event"]
    
    @State private var selectedTime = Date()
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: selectedTime)
    }
    
    @State private var eventyear = ""
    let calendar = Calendar.current
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    @State var years: [String] = []
    let year = Calendar.current.component(.year, from: Date())
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYearIndex = 0
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    
    @State var title = ""
    @State var subtitle = ""
    @State var date = ""
    
    @State var selectedclubevent: clubEvent?
        
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("You are currently editing source data. Any changes will be made public across all devices.")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    Spacer()
                }
            }
            Button {
                isPresetingAddEvent = true
            } label: {
                Text("Add Club Event")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(10)
                    .cornerRadius(15.0)
                    .frame(width: screen.screenWidth-30)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .background(Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    )
            }
            if dataManager.clubsEvents.count > 0 {
                List {
                    ForEach(dataManager.clubsEvents, id: \.id) { event in
                        HStack {
                            VStack {
                                Text(event.month)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.red)
                                Text(event.day)
                                    .font(.system(size: 26, weight: .regular, design: .rounded))
                                
                            }
                            .frame(width:50,height:50)
                            Divider()
                                .padding(.vertical, 10)
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .lineLimit(2)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded)) // semibold
                                Text(event.subtitle)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                    .lineLimit(1)
                            }
                            .padding(.leading, 5)
                            Spacer()
                            
                        }
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                temptitle = event.title
                                // isConfirmingDeleteEvent = true
                                eventToDelete = event
                                if let eventToDelete = eventToDelete {
                                    editingeventslist.removeAll {$0 == eventToDelete}
                                    print("Removed \(eventToDelete)")
                                    dataManager.deleteClubEvent(forClub: "\(currentclub.clubname)", clubEvent: eventToDelete)
                                }
                            }
                        }
                    }
                }
            }
            // Spacer()
            else if dataManager.clubsEvents.count == 0 {
                Text("No upcoming events.")
                    .lineLimit(1)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                Spacer()
                    .frame(height: 500)
            }
        }.navigationTitle("Edit Club Events")
            .alert(isPresented: $isConfirmingDeleteEvent) {
                Alert(
                    title: Text("Delete Event"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let eventToDelete = eventToDelete {
                            dataManager.deleteClubEvent(forClub: "\(currentclub.clubname)", clubEvent: eventToDelete)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        
            .sheet(isPresented: $isPresetingAddEvent) {
                ClubEventAdminDetailView(dataManager: dataManager, currentclub: currentclub, admin: admin)
            }
            .sheet(item: $selectedclubevent) { event in
                ClubEventAdminDetailView(dataManager: dataManager, editingEvent: event, currentclub: currentclub, admin: admin)
            }
            
    }
}


struct ClubEventAdminDetailView: View {
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var dataManager: clubEventManager
   @State private var eventname = ""
   var editingEvent: clubEvent?
    var currentclub: club
    
    @State var isConfirmingDeleteEvent = false
    @State var isPresetingAddEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: clubEvent?
    @State var eventToSave: clubEvent?
    @State var editingeventslist: [clubEvent] = []
    @State var screen = ScreenSize()
    
    @State var selectedevent = 0
    @State var selectedtime = 0
    
    var typelist = ["Meeting", "Mandatory Meeting", "Competition", "Special Event"]
    
    @State private var selectedTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date()
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: selectedTime)
    }
    
    @State private var eventyear = ""
    let calendar = Calendar.current
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    @State var years: [String] = []
    let year = Calendar.current.component(.year, from: Date())
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYearIndex = 0
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    
    @State var title = ""
    @State var subtitle = ""
    @State var date = ""
    
    @State var isPresentingAddClub = false
    
    var admin: Bool
      
   @State private var isConfirmingAddClubEvent = false
    
    var monthdays: [String: Int] = ["Jan": 31, "Feb": 28, "Mar": 31, "Apr": 30, "May": 31, "Jun": 30, "Jul": 31, "Aug": 31, "Sep": 30, "Oct": 31, "Nov": 30, "Dec": 31]
    
    var isRealDate: Bool {
        if monthdays[months[selectedMonthIndex]] ?? 32 >= days[selectedDayIndex] {
            return true
        }
        if months[selectedMonthIndex] == "Feb" && days[selectedDayIndex] == 29 && ((Int(years[selectedYearIndex]) ?? 1) % 4 == 0) {
            return true
        }
        return false
    }
   
   var body: some View {
       NavigationView {
           Form {
               Section(header: Text("Clubs Event details")) {
                   if admin {
                       //bob
                       TextField("Title", text: $title)
                       DatePicker("Pick a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                           .labelsHidden()
                           .datePickerStyle(WheelDatePickerStyle())
                       
                   } else {
                       Picker("Event Type", selection: $selectedevent) {
                           Text("Meeting")
                               .tag(0)
                           Text("Mandatory Meeting")
                               .tag(1)
                           Text("Competition")
                               .tag(2)
                           Text("Special Event")
                               .tag(3)
                       }
                       DatePicker("Pick a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                           .labelsHidden()
                           .datePickerStyle(WheelDatePickerStyle())
                   }
                   
                   Picker("Month", selection: $selectedMonthIndex) {
                       ForEach(0..<months.count, id: \.self) { index in
                           Text(months[index]).tag(index)
                       }
                   }
                   
                   Picker("Day", selection: $selectedDayIndex) {
                       ForEach(0..<days.count, id: \.self) { index in
                           Text("\(days[index])").tag(index)
                       }
                   }
                   
                   Picker("Year", selection: $selectedYearIndex) {
                       ForEach(0..<years.count, id: \.self) { index in
                           Text("\(years[index])").tag(index)
                       }
                   }
               }
               
               if ((admin && !title.isEmpty) || !admin) && isRealDate {
                   Button {
                       isConfirmingAddClubEvent = true
                   } label: {
                       Text("Publish New Club Event")
                           .foregroundColor(.white)
                           .fontWeight(.semibold)
                           .padding(10)
                           .cornerRadius(15.0)
                           .frame(width: screen.screenWidth-60)
                           .font(.system(size: 17, weight: .semibold, design: .rounded))
                           .background(Rectangle()
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                           )
                   }
               } else {
                   Text("Publish New Club Event")
                       .foregroundColor(.white)
                       .fontWeight(.semibold)
                       .padding(10)
                       .cornerRadius(15.0)
                       .frame(width: screen.screenWidth-60)
                       .font(.system(size: 17, weight: .semibold, design: .rounded))
                       .background(Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                       )
               }
           }
               
           .navigationBarTitle("Add Club Event")
           .navigationBarItems(leading: Button("Cancel") {
               presentationMode.wrappedValue.dismiss()
           })
           .alert(isPresented: $isConfirmingAddClubEvent) {
               Alert(
                   title: Text("Publish Club Event"),
                   message: Text("This action cannot be undone."),
                   primaryButton: .default(Text("Publish")) {
                       if admin {
                           eventToSave = clubEvent(
                               documentID: "NAN",
                               title: title,
                               subtitle: formattedTime,
                               month: months[selectedMonthIndex],
                               day: "\(days[selectedDayIndex])",
                               year: years[selectedYearIndex],
                               publisheddate: "\(months[selectedMonthIndex])   \(days[selectedDayIndex]),\(eventyear)")
                       } else {
                           eventToSave = clubEvent(
                               documentID: "NAN",
                               title: typelist[selectedevent],
                               subtitle: formattedTime,
                               month: months[selectedMonthIndex],
                               day: "\(days[selectedDayIndex])",
                               year: years[selectedYearIndex],
                               publisheddate: "\(months[selectedMonthIndex])   \(days[selectedDayIndex]),\(eventyear)")
                       }
                       if let eventToSave = eventToSave {
                           print("Event to save")
                           print(eventToSave)
                           
                           editingeventslist.append(eventToSave)
                           
                           dataManager.createClubEvent(forClub: "\(currentclub.clubname)", clubEvent: eventToSave)
                       }
                       presentationMode.wrappedValue.dismiss()
                   },
                   secondaryButton: .cancel()
               )
           }
           .onAppear{
               for i in 0...2 {
                   years.append(String(Int(year) + Int(i)))
               }
               let currentYear = calendar.component(.year, from: Date())
               eventyear = String(currentYear)
           }
       }
   }
}



struct ClubContentView_Previews: PreviewProvider {
    static var previews: some View {
        SportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: UUID()))
    }
}
