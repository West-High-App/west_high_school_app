//
//  StaffView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI

struct StaffView: View {
    private var allteachers = teacherslist.allteacherslist
    @State var searchText = ""

    private var filteredteachers: [teacher] {
        return searchText == ""
            ? allteachers
            : allteachers.filter {
                $0.teachername.lowercased().contains(searchText.lowercased())
            }
    }
    var body: some View {
        VStack {
                List{
                    ForEach(filteredteachers, id: \.id) { teacher in
                        NavigationLink {
                            Text("")
                            StaffDetailView(currentteacher: teacher)
                        }label: {
                            
                            
                            HStack{
                                VStack(alignment: .leading, spacing: 0.0) {
                                    HStack {
                                        Text(teacher.teachername)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.leading,40)
                                        Spacer()
                                        //ForEach(teacher.classes, id: \.self) { //taughtclass in
                                        //  Text(taughtclass)
                                        //       .padding()
                                        //}
                                        
                                    }
                                    HStack{
                                        ForEach(teacher.classes, id: \.self){item in
                                            Text(item)
                                        }
                                    }
                                        .padding(.horizontal)
                                        .padding(.leading,25)
                                        .foregroundColor(.black)
                                }
                                Image(teacher.teacherphoto)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:50 ,height:50)
                                    .cornerRadius(50)
                                    .padding(.trailing, 30)
                            }
                            .frame(width:400, height: 80)
                            .padding(.horizontal, 15)
                            .padding(.vertical, -10)
                        }
                    }
                }
                
                .navigationBarTitle(Text("Staff List"))
                .searchable(text: $searchText)
            
        }
        
    }
}

struct StaffView_Previews: PreviewProvider {
    static var previews: some View {
        StaffView()
    }
}
