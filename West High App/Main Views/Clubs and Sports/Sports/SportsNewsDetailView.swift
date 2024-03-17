import SwiftUI

struct SportsNewsDetailView: View {
    var currentnews: sportNews
    @StateObject var imagemanager = imageManager()
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    @State var imagedata: [UIImage] = []
    var body: some View {
        ScrollView{
            VStack(spacing:10){
                HStack {
                    Text(currentnews.newstitle)
                        .titleText()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text("By \(currentnews.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text(currentnews.newsdate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                VStack {
                    TabView {
                        
                        // Loop through each recipe
                        ForEach(imagedata.indices, id: \.self) { index in
                                
                                VStack(spacing: 0) {
                                    Image(uiImage: imagedata[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: screen.screenWidth - 20, height: 250)
                                        .clipped()
                                        .cornerRadius(30)
                                }
                        
                        }
                        
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                }
                .cornerRadius(30)
                .frame(width: screen.screenWidth - 20, height: 250)
                .shadow(color: .gray, radius: 4, x:2, y:3)
                .padding(.horizontal)
                
                Divider()
                    .frame(width: screen.screenWidth / 1.2, height: 2)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            
            LinkTextView(text: currentnews.newsdescription)
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(Color(UIColor.systemGray6))
//                    )
                .padding(.bottom)

//                .multilineTextAlignment(.leading)
//                .foregroundColor(Color.black)
//                .font(.system(size: 17, weight: .regular, design: .rounded))
//                .padding(.horizontal, 25)
//                .padding(.vertical, 5)
//                .background(Rectangle()
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                    .shadow(radius: 5, x: 3, y: 3)
//                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
//                .padding(.bottom)
                
            
        }
        .onAppear {
            if !hasAppeared || currentnews.imagedata == [] || currentnews.imagedata.first == UIImage() || currentnews.imagedata.first == nil {
            
                for image in currentnews.newsimage {
                    imagemanager.getImage(fileName: image) { uiimage in
                         if let uiimage = uiimage {
                             imagedata.append(uiimage)
                         }
                    }
                }
                 hasAppeared = true
            } else {
            }
            
       }

        }
    }

struct SportsNewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SportsNewsDetailView(currentnews: sportNews(
            newstitle: "Varsity Football Team Wins Regional Championship",
            newsimage: ["football"],
            newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
            newsdate: "Nov 15, 2022", newsdateSwift: Date(),
            author: "Emily Thompson", isApproved: false, imagedata: [], documentID: "NAN", writerEmail: ""))
    }
}
