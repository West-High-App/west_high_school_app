import SwiftUI

struct ClubsNewsDetailView: View {
    var currentclubnews: clubNews
    @StateObject var imagemanager = imageManager()
    @State private var imagedata: [UIImage] = []
    @State private var screen = ScreenSize()
    @State private var hasAppeared = false
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack{
                    Text(currentclubnews.newstitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text("By \(currentclubnews.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text(currentclubnews.newsdate)
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
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            
            LinkTextView(text: currentclubnews.newsdescription)
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.bottom)
        }
        .onAppear {
            if !hasAppeared || currentclubnews.imagedata == [] || currentclubnews.imagedata.first == UIImage() || currentclubnews.imagedata.first == nil {
            
                for image in currentclubnews.newsimage {
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

struct ClubsNewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsNewsDetailView(currentclubnews: clubNews(
            newstitle: "August learns how to piss!",
            newsimage: ["roboticsclub"],
            newsdescription: "This is a hardcoded example, is not from firebase and should never be shown on the app",
            newsdate: "Apr 1, 2023",
            newsdateSwift: Date(),
            author: "Aiden Jamae Lee (not funny)",
            isApproved: false,
            documentID: "NAN",
            writerEmail: "",
            imagedata: []))
    }
}
