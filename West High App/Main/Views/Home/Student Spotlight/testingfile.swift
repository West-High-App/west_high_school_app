//
//  testingfile.swift
//  West High
//
//  Created by Aiden Lee on 10/5/23.
//

import SwiftUI

struct testingfile: View {
    @State var screen = ScreenSize()
    var body: some View {
        VStack{
            Image("westhighschool")
                .resizable()
                .padding(.bottom, 2)
                .aspectRatio(contentMode: .fill)
                .frame(width: screen.screenWidth - 60, height: 230)
                .clipped()
                .cornerRadius(30)
            VStack(alignment: .leading, spacing:2){
                HStack{
                    Text("By HI")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Spacer()
                    Text("Oct 5, 1929")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                Text("Test bob")
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                Text("ruhiegjrwguojhiuheiuhuihf iwrhfiohqoriwughr ihroihriofhioqheiuhfq")
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

            }.padding(.horizontal)
            Divider()
                .padding(.horizontal)
        }
//            .padding(.vertical, 5)
            .listRowBackground(
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 7)
                    .shadow(radius: 5)
            )    }
}


struct thing: View {
    var body : some View {
        testingfile()
    }
}
struct testingfile_Previews: PreviewProvider {
    static var previews: some View {
        thing()
    }
}
