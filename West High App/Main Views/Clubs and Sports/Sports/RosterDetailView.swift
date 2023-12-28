import SwiftUI

struct ZoomableImageView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = CGSize.zero
    let image: UIImage
    func resetImageState() {
   
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
         
        }
    }
    
    
    var body: some View {
            
            ZStack{
                Color.clear
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x:2, y: 2)
                    .opacity(isAnimating ? 1: 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                                
                            }
                        }else{
                            resetImageState()
                            
                        }
                    }
                    .gesture(DragGesture()
                        .onChanged{ value in
                            withAnimation(.linear(duration: 1)){
                                if imageScale <= 1  {
                                    imageOffset = value.translation
                                }else{
                                    imageOffset = value.translation

                                }
                                
                               
                            }
                        }
                        .onEnded{ value in
                            if imageScale <= 1 {
                                resetImageState()
                            }
                            
                          
                        }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded{ _ in
                                
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                                      
                    
                    )
                
            }
            .padding(.bottom, 70)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }

            .overlay(
                Group{
                    HStack{
                        // SCALE DOWN
                        Button{
                            withAnimation(.spring()){
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                           ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // RESET
                        Button{
                            resetImageState()
                        } label: {
                           ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // SCALE UP
                        Button{
                            withAnimation(.spring()){
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                           ControlImageView(icon: "plus.magnifyingglass")
                        }
                        
                    }//: HSTACK
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            
            
            
        
        .navigationViewStyle(.stack)
        .onTapGesture(count: 3) {
            if(imageScale > 1){
                resetImageState()
            }
        }
    }
}

