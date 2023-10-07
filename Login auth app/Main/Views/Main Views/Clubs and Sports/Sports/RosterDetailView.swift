import SwiftUI

struct ZoomableImageView: View {
    @GestureState private var magnifyBy: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    let image: UIImage
    
    var body: some View {
        let magnifiedScale = max(scale * magnifyBy, 1.0)
        
        return Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(magnifiedScale)
            .offset(
                CGSize(
                    width: offset.width + dragOffset.width,
                    height: offset.height + dragOffset.height
                )
            )
            .gesture(
                MagnificationGesture()
                    .updating($magnifyBy) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        scale *= value
                    }
            )
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        offset.width += value.translation.width
                        offset.height += value.translation.height
                    }
            )
    }
}
