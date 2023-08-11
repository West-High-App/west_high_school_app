//
//  StaffDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import SwiftUI

struct StaffDetailView: View {
    var currentteacher: teacher
    var body: some View {
        ScrollView{
            VStack{
                    // crop profile picture
                    
                    let pfp = UIImage(
                        named: currentteacher.teacherphoto
                    )!
                    let sideLength = min(
                        pfp.size.width,
                        pfp.size.height
                    )
                    let sourceSize = pfp.size
                    let xOffset = (sourceSize.width - sideLength) / 2.0
                    let yOffset = (sourceSize.height - sideLength) / 2.0
                    let cropRect = CGRect(
                        x: xOffset,
                        y: yOffset,
                        width: sideLength,
                        height: sideLength
                    ).integral
                    let sourceCGImage = pfp.cgImage!
                    let croppedCGImage = sourceCGImage.cropping(
                        to: cropRect
                    )!
                    let croppedImage = UIImage(
                        cgImage: croppedCGImage,
                        scale: pfp.imageRendererFormat.scale,
                        orientation: pfp.imageOrientation
                    )

                    
                    
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .cornerRadius(1000)
                        .padding(.horizontal, 10)
                    //.padding(.leading,10)
                    Text(currentteacher.teachername)
                    //.padding(.leading,10)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .font(.system(size: 36, weight: .semibold))
                Spacer()
                    .frame(height: 10)
                VStack{
                    Text("Email : " + currentteacher.email)
                    Text("Phone : " + currentteacher.phone)
                    HStack{
                        Text("Classes :")
                        ForEach(currentteacher.classes, id: \.self){item in
                            Text(item)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical,10)
                    .background(Rectangle()
                        .cornerRadius(9.0)
                        .frame(width: 400)
                        .padding(.horizontal)
                        .shadow(radius: 5, x: 3, y: 3)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    }
                    .foregroundColor(Color(red: 43/255, green: 46/255, blue: 44/255))
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 10)
                //43, 46, 44
                VStack {
                    Text("About me:")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.top, 5)
                    Text(currentteacher.aboutme)
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }.multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .background(Rectangle()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(9.0)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                }
            }
    }}

struct StaffDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StaffDetailView(currentteacher: teacherslist.allteacherslist.first!)
    }
}
